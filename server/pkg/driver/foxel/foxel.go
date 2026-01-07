package foxel

import (
	"context"
	"errors"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"net/url"
	filepath "path"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
	"github.com/honmaple/maple-file/server/pkg/util"
	httputil "github.com/honmaple/maple-file/server/pkg/util/http"
	"github.com/tidwall/gjson"
)

type Option struct {
	base.Option
	Endpoint string `json:"endpoint"  validate:"required"`
	Username string `json:"username"  validate:"required"`
	Password string `json:"password"  validate:"required"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Foxel struct {
	driver.Base
	opt    *Option
	token  string
	client *httputil.Client
}

var _ driver.FS = (*Foxel)(nil)

func encodePath(fullPath string) string {
	fullPath = strings.TrimPrefix(fullPath, "/")
	if fullPath == "" {
		return ""
	}
	parts := strings.Split(fullPath, "/")
	for i, p := range parts {
		parts[i] = url.PathEscape(p)
	}
	return strings.Join(parts, "/")
}

func (d *Foxel) browsePath(fullPath string) string {
	if fullPath == "/" {
		return "/api/fs/"
	}
	return "/api/fs/" + encodePath(fullPath)
}

func (d *Foxel) statPath(fullPath string) string {
	if fullPath == "/" {
		return "/api/fs/stat/"
	}
	return "/api/fs/stat/" + encodePath(fullPath)
}

func (d *Foxel) streamPath(fullPath string) string {
	if fullPath == "/" {
		return "/api/fs/stream/"
	}
	return "/api/fs/stream/" + encodePath(fullPath)
}

func (d *Foxel) uploadPath(fullPath string) string {
	return "/api/fs/upload/" + encodePath(fullPath)
}

func (d *Foxel) request(ctx context.Context, method, url string, opts ...httputil.Option) (*http.Response, error) {
	if opts == nil {
		opts = make([]httputil.Option, 0)
	}

	opts = append(opts, httputil.WithHost(d.opt.Endpoint))
	opts = append(opts, httputil.WithContext(ctx))

	if d.token != "" {
		opts = append(opts, httputil.WithHeaders(map[string]string{
			"Authorization": "Bearer " + d.token,
		}))
	}
	return d.client.Request(method, url, opts...)
}

func (d *Foxel) unwrapSuccess(payload []byte) (gjson.Result, error) {
	code := gjson.GetBytes(payload, "code").Int()
	if code != 0 && code != 200 {
		msg := gjson.GetBytes(payload, "msg").String()
		if msg == "" {
			msg = "Foxel 上游错误"
		}
		return gjson.Result{}, errors.New(msg)
	}
	return gjson.GetBytes(payload, "data"), nil
}

func (d *Foxel) login(ctx context.Context) error {
	resp, err := d.client.Request(
		http.MethodPost,
		"/api/auth/login",
		httputil.WithHost(d.opt.Endpoint),
		httputil.WithContext(ctx),
		httputil.WithForm(map[string]string{
			"username": d.opt.Username,
			"password": d.opt.Password,
		}),
	)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("登录失败，状态码: %d", resp.StatusCode)
	}
	b, err := io.ReadAll(resp.Body)
	if err != nil {
		return err
	}

	token := gjson.GetBytes(b, "access_token").String()
	if token == "" {
		return errors.New("登录错误，无法获取Token")
	}
	d.token = token
	return nil
}

func (d *Foxel) requestJSON(ctx context.Context, method, url string, buildOpts func() []httputil.Option) (gjson.Result, error) {
	for i := 0; i < 2; i++ {
		resp, err := d.request(ctx, method, url, buildOpts()...)
		if err != nil {
			return gjson.Result{}, err
		}
		b, err := io.ReadAll(resp.Body)
		resp.Body.Close()
		if err != nil {
			return gjson.Result{}, err
		}
		if resp.StatusCode == http.StatusUnauthorized && i == 0 {
			d.token = ""
			if err := d.login(ctx); err != nil {
				return gjson.Result{}, err
			}
			continue
		}
		if resp.StatusCode < http.StatusOK || resp.StatusCode >= http.StatusMultipleChoices {
			return gjson.Result{}, fmt.Errorf("请求失败，状态码: %d", resp.StatusCode)
		}
		return d.unwrapSuccess(b)
	}
	return gjson.Result{}, errors.New("请求失败")
}

func (d *Foxel) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	files := make([]driver.File, 0)

	pageSize := 500
	for page := 1; ; page++ {
		data, err := d.requestJSON(ctx, http.MethodGet, d.browsePath(path), func() []httputil.Option {
			return []httputil.Option{
				httputil.WithQueryParams(map[string]string{
					"page":       fmt.Sprintf("%d", page),
					"page_size":  fmt.Sprintf("%d", pageSize),
					"sort_by":    "name",
					"sort_order": "asc",
				}),
			}
		})
		if err != nil {
			return nil, err
		}

		entries := data.Get("entries").Array()
		for _, entry := range entries {
			files = append(files, driver.NewFile(path, &fileinfo{info: entry}))
		}

		total := data.Get("pagination.total").Int()
		if total > 0 && int64(len(files)) >= total {
			break
		}
		if len(entries) < pageSize {
			break
		}
	}
	return files, nil
}

func (d *Foxel) Get(ctx context.Context, path string) (driver.File, error) {
	data, err := d.requestJSON(ctx, http.MethodGet, d.statPath(path), func() []httputil.Option { return nil })
	if err != nil {
		return nil, err
	}
	return driver.NewFile(filepath.Dir(path), &fileinfo{info: data, name: filepath.Base(path)}), nil
}

func (d *Foxel) Open(path string) (driver.FileReader, error) {
	info, err := d.Get(context.Background(), path)
	if err != nil {
		return nil, err
	}
	if info.IsDir() {
		return nil, driver.ErrOpenDirectory
	}

	rangeFunc := func(offset, length int64) (io.ReadCloser, error) {
		ctx := context.Background()
		for i := 0; i < 2; i++ {
			resp, err := d.request(ctx, http.MethodGet, d.streamPath(path),
				httputil.WithNeverTimeout(),
				httputil.WithRequest(func(req *http.Request) {
					if length > 0 {
						req.Header.Add("Range", fmt.Sprintf("bytes=%d-%d", offset, offset+length-1))
					} else {
						req.Header.Add("Range", fmt.Sprintf("bytes=%d-", offset))
					}
				}),
			)
			if err != nil {
				return nil, err
			}
			if resp.StatusCode == http.StatusUnauthorized && i == 0 {
				resp.Body.Close()
				d.token = ""
				if err := d.login(ctx); err != nil {
					return nil, err
				}
				continue
			}

			if resp.StatusCode == http.StatusOK || resp.StatusCode == http.StatusPartialContent {
				return resp.Body, nil
			}
			resp.Body.Close()
			return nil, fmt.Errorf("打开失败，状态码: %d", resp.StatusCode)
		}
		return nil, errors.New("打开失败")
	}
	return driver.NewFileReader(info.Size(), rangeFunc)
}

func (d *Foxel) Create(path string) (driver.FileWriter, error) {
	r, w := util.Pipe()
	go func() {
		ctx := context.Background()

		bodyReader, bodyWriter := io.Pipe()
		mpWriter := multipart.NewWriter(bodyWriter)

		writeErrCh := make(chan error, 1)
		go func() {
			defer close(writeErrCh)

			part, err := mpWriter.CreateFormFile("file", filepath.Base(path))
			if err != nil {
				_ = bodyWriter.CloseWithError(err)
				writeErrCh <- err
				return
			}
			if _, err := io.Copy(part, r); err != nil {
				_ = mpWriter.Close()
				_ = bodyWriter.CloseWithError(err)
				writeErrCh <- err
				return
			}

			if err := mpWriter.Close(); err != nil {
				_ = bodyWriter.CloseWithError(err)
				writeErrCh <- err
				return
			}
			_ = bodyWriter.Close()
			writeErrCh <- nil
		}()

		resp, err := d.request(
			ctx,
			http.MethodPost,
			d.uploadPath(path),
			httputil.WithNeverTimeout(),
			httputil.WithHeaders(map[string]string{
				"Content-Type": mpWriter.FormDataContentType(),
			}),
			httputil.WithBody(bodyReader),
		)
		if err == nil {
			b, rerr := io.ReadAll(resp.Body)
			resp.Body.Close()
			if rerr != nil {
				err = rerr
			} else if resp.StatusCode < http.StatusOK || resp.StatusCode >= http.StatusMultipleChoices {
				err = fmt.Errorf("上传失败，状态码: %d", resp.StatusCode)
			} else if _, uerr := d.unwrapSuccess(b); uerr != nil {
				err = uerr
			}
		}

		if werr := <-writeErrCh; err == nil && werr != nil {
			err = werr
		}

		_ = bodyReader.Close()
		r.CloseWithError(err)
	}()
	return w, nil
}

func (d *Foxel) Rename(ctx context.Context, path, newName string) error {
	dst := filepath.Join(filepath.Dir(path), newName)
	_, err := d.requestJSON(ctx, http.MethodPost, "/api/fs/rename", func() []httputil.Option {
		return []httputil.Option{
			httputil.WithQueryParams(map[string]string{"overwrite": "true"}),
			httputil.WithJson(map[string]string{
				"src": path,
				"dst": dst,
			}),
		}
	})
	return err
}

func (d *Foxel) Move(ctx context.Context, src, dst string) error {
	dst = filepath.Join(dst, filepath.Base(src))
	_, err := d.requestJSON(ctx, http.MethodPost, "/api/fs/move", func() []httputil.Option {
		return []httputil.Option{
			httputil.WithQueryParams(map[string]string{"overwrite": "true"}),
			httputil.WithJson(map[string]string{
				"src": src,
				"dst": dst,
			}),
		}
	})
	return err
}

func (d *Foxel) Copy(ctx context.Context, src, dst string) error {
	dst = filepath.Join(dst, filepath.Base(src))
	_, err := d.requestJSON(ctx, http.MethodPost, "/api/fs/copy", func() []httputil.Option {
		return []httputil.Option{
			httputil.WithQueryParams(map[string]string{"overwrite": "true"}),
			httputil.WithJson(map[string]string{
				"src": src,
				"dst": dst,
			}),
		}
	})
	return err
}

func (d *Foxel) Remove(ctx context.Context, path string) error {
	_, err := d.requestJSON(ctx, http.MethodDelete, d.browsePath(path), func() []httputil.Option { return nil })
	return err
}

func (d *Foxel) MakeDir(ctx context.Context, path string) error {
	_, err := d.requestJSON(ctx, http.MethodPost, "/api/fs/mkdir", func() []httputil.Option {
		return []httputil.Option{
			httputil.WithJson(map[string]string{
				"path": path,
			}),
		}
	})
	return err
}

func (d *Foxel) Close() error {
	return nil
}

func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	d := &Foxel{
		opt:    opt,
		client: httputil.New(),
	}
	if err := d.login(context.Background()); err != nil {
		return nil, err
	}
	return opt.Option.NewFS(d)
}

func init() {
	driver.Register("foxel", func() driver.Option {
		return &Option{}
	})
}

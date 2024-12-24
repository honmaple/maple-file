package alist

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"path/filepath"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
	httputil "github.com/honmaple/maple-file/server/pkg/util/http"
	"github.com/tidwall/gjson"
)

type Option struct {
	driver.BaseOption
	Endpoint string `json:"endpoint"  validate:"required"`
	Username string `json:"username"  validate:"required"`
	Password string `json:"password"  validate:"required"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Alist struct {
	driver.Base
	opt    *Option
	token  string
	client *httputil.Client
}

var _ driver.FS = (*Alist)(nil)

func (d *Alist) request(ctx context.Context, method, url string, opts ...httputil.Option) (io.ReadCloser, error) {
	if strings.HasPrefix(url, "/") {
		url = strings.TrimSuffix(d.opt.Endpoint, "/") + url
	}

	if opts == nil {
		opts = make([]httputil.Option, 0)
	}

	opts = append(opts, httputil.WithContext(ctx))
	if d.token != "" {
		opts = append(opts, httputil.WithHeaders(map[string]string{
			"Authorization": d.token,
		}))
	}

	resp, err := d.client.Request(method, url, opts...)
	if err != nil {
		return nil, err
	}

	if code := resp.StatusCode; code == http.StatusPartialContent || code == http.StatusOK {
		return resp.Body, nil
	}
	resp.Body.Close()
	return nil, fmt.Errorf("bad status: %d", resp.StatusCode)
}

func (d *Alist) requestWithData(ctx context.Context, method, url string, data map[string]any) ([]byte, error) {
	r, err := d.request(ctx, method, url, httputil.WithJson(data))
	if err != nil {
		return nil, err
	}
	defer r.Close()

	return io.ReadAll(r)
}

func (d *Alist) List(ctx context.Context, path string) ([]driver.File, error) {
	resp, err := d.requestWithData(ctx, http.MethodPost, "/api/fs/list", map[string]any{
		"page":     1,
		"per_page": 0,
		"path":     path,
		"password": "",
		"refresh":  false,
	})
	if err != nil {
		return nil, err
	}
	results := gjson.ParseBytes(resp).Get("data.content").Array()

	files := make([]driver.File, len(results))
	for i, result := range results {
		files[i] = driver.NewFile(path, &fileinfo{result})
	}
	return files, nil
}

func (d *Alist) Rename(ctx context.Context, path, newName string) error {
	_, err := d.requestWithData(ctx, http.MethodPost, "/api/fs/rename", map[string]any{
		"path": path,
		"name": newName,
	})
	return err
}

func (d *Alist) Move(ctx context.Context, src, dst string) error {
	_, err := d.requestWithData(ctx, http.MethodPost, "/api/fs/move", map[string]any{
		"src_dir": filepath.Dir(src),
		"dst_dir": dst,
		"names":   []string{filepath.Base(src)},
	})
	return err
}

func (d *Alist) Copy(ctx context.Context, src, dst string) error {
	_, err := d.requestWithData(ctx, http.MethodPost, "/api/fs/copy", map[string]any{
		"src_dir": filepath.Dir(src),
		"dst_dir": dst,
		"names":   []string{filepath.Base(src)},
	})
	return err
}

func (d *Alist) Remove(ctx context.Context, path string) error {
	_, err := d.requestWithData(ctx, http.MethodPost, "/api/fs/remove", map[string]any{
		"dir":   filepath.Dir(path),
		"names": []string{filepath.Base(path)},
	})
	return err
}

func (d *Alist) MakeDir(ctx context.Context, path string) error {
	_, err := d.requestWithData(ctx, http.MethodPost, "/api/fs/mkdir", map[string]any{
		"path": path,
	})
	return err
}

func (d *Alist) Get(path string) (driver.File, error) {
	resp, err := d.requestWithData(context.Background(), http.MethodPost, "/api/fs/get", map[string]any{
		"path":     path,
		"password": "",
	})
	if err != nil {
		return nil, err
	}
	return driver.NewFile(filepath.Dir(path), &fileinfo{gjson.ParseBytes(resp).Get("data")}), nil
}

func (d *Alist) Open(path string) (driver.FileReader, error) {
	resp, err := d.requestWithData(context.Background(), http.MethodPost, "/api/fs/get", map[string]any{
		"path":     path,
		"password": "",
	})
	if err != nil {
		return nil, err
	}
	result := gjson.ParseBytes(resp)

	url := result.Get("data.raw_url").String()
	if url == "" {
		return nil, fmt.Errorf("can't open %s", path)
	}

	rangeFunc := func(offset, length int64) (io.ReadCloser, error) {
		return d.request(context.Background(), http.MethodGet, url, httputil.WithNeverTimeout(), httputil.WithRequest(func(req *http.Request) {
			if length > 0 {
				req.Header.Add("Range", fmt.Sprintf("bytes=%d-%d", offset, offset+length-1))
			} else {
				req.Header.Add("Range", fmt.Sprintf("bytes=%d-", offset))
			}
		}))
	}
	return driver.NewFileReader(result.Get("data.size").Int(), rangeFunc)
}

func (d *Alist) Create(path string) (driver.FileWriter, error) {
	r, w := io.Pipe()
	go func() {
		resp, err := d.request(context.Background(), http.MethodPut, "/api/fs/put", httputil.WithBody(r), httputil.WithNeverTimeout(), httputil.WithRequest(func(req *http.Request) {
			req.Header.Set("File-Path", path)
			req.Header.Set("Password", "")
		}))
		if err != nil {
			r.CloseWithError(err)
			return
		}
		defer resp.Close()
		r.Close()
	}()
	return w, nil
}

func (d *Alist) login() error {
	ctx := context.Background()
	if d.opt.Username == "" || d.opt.Password == "" {
		resp, err := d.requestWithData(ctx, http.MethodGet, "/api/me", nil)
		if err != nil {
			return err
		}
		result := gjson.ParseBytes(resp)
		if result.Get("code").Int() == 401 {
			return errors.New("游客无法访问")
		}
		return nil
	}
	resp, err := d.requestWithData(ctx, http.MethodPost, "/api/auth/login", map[string]any{
		"username": d.opt.Username,
		"password": d.opt.Password,
	})
	if err != nil {
		return err
	}
	d.token = gjson.ParseBytes(resp).Get("data.token").String()
	if d.token == "" {
		return errors.New("登录错误，无法获取Token")
	}
	return nil
}

func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	d := &Alist{
		opt:    opt,
		client: httputil.New(),
	}

	if err := d.login(); err != nil {
		return nil, err
	}

	if opt.RootPath != "" {
		return driver.PrefixFS(d, opt.RootPath), nil
	}
	return d, nil
}

func init() {
	driver.Register("alist", func() driver.Option {
		return &Option{}
	})
}

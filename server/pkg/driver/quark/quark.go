package quark

import (
	"context"
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"

	filepath "path"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
	httputil "github.com/honmaple/maple-file/server/pkg/util/http"
	"github.com/tidwall/gjson"
)

const (
	api     = "https://drive-pc.quark.cn/1/clouddrive"
	referer = "https://pan.quark.cn"
)

type Option struct {
	base.Option
	Cookie string `json:"cookie"  validate:"required"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Quark struct {
	driver.Base
	opt    *Option
	token  string
	client *httputil.Client
}

var _ driver.FS = (*Quark)(nil)

func (d *Quark) request(ctx context.Context, method, url string, opts ...httputil.Option) (io.ReadCloser, error) {
	if strings.HasPrefix(url, "/") {
		url = api + url
	}

	if opts == nil {
		opts = make([]httputil.Option, 0)
	}

	opts = append(opts, httputil.WithContext(ctx))
	opts = append(opts, httputil.WithHeaders(map[string]string{
		"Cookie":  d.opt.Cookie,
		"Accept":  "application/json, text/plain, */*",
		"Referer": referer,
	}))
	opts = append(opts, httputil.WithQueryParams(map[string]string{
		"fr": "pc",
		"pr": "ucpro",
	}))

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

func (d *Quark) requestWithData(ctx context.Context, method, url string, data map[string]any) ([]byte, error) {
	r, err := d.request(ctx, method, url, httputil.WithJson(data))
	if err != nil {
		return nil, err
	}
	defer r.Close()

	return io.ReadAll(r)
}

func (d *Quark) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	r, err := d.request(ctx, http.MethodGet, "/file/sort", httputil.WithQueryParams(map[string]string{
		"_page":        "1",
		"_size":        "50",
		"_fetch_total": "1",
		"_sort=":       "file_type:asc,updated_at:desc",
		"pdir_fid":     path,
	}))
	if err != nil {
		return nil, err
	}
	defer r.Close()

	resp, err := io.ReadAll(r)
	if err != nil {
		return nil, err
	}

	files := make([]driver.File, 0)

	results := gjson.ParseBytes(resp).Get("data.list").Array()
	for _, result := range results {
		info := &driver.FileInfo{
			Path:    path,
			Name:    result.Get("file_name").String(),
			Size:    result.Get("size").Int(),
			IsDir:   result.Get("dir").Bool(),
			ModTime: time.UnixMilli(result.Get("updated_at").Int()),
			ExtraInfo: map[string]any{
				"id": result.Get("fid").String(),
				// "preview_url": result.Get("preview_url").String(),
			},
		}
		if !info.IsDir {
			info.Type = result.Get("format_type").String()
		}
		files = append(files, info.File())
	}
	return files, nil
}

func (d *Quark) Rename(ctx context.Context, path, newName string) error {
	_, err := d.requestWithData(ctx, http.MethodPost, "/file/rename", map[string]any{
		"fid":       path,
		"file_name": newName,
	})
	return err
}

func (d *Quark) Move(ctx context.Context, src, dst string) error {
	_, err := d.requestWithData(ctx, http.MethodPost, "/file/move", map[string]any{
		"action_type":  1,
		"exclude_fids": []string{},
		"filelist":     []string{src},
		"to_pdir_fid":  dst,
	})
	return err
}

func (d *Quark) MakeDir(ctx context.Context, path string) error {
	_, err := d.requestWithData(ctx, http.MethodPost, "/file", map[string]any{
		"dir_init_lock": false,
		"dir_path":      "",
		"pdir_fid":      filepath.Dir(path),
		"file_name":     filepath.Base(path),
	})
	return err
}

func (d *Quark) Remove(ctx context.Context, path string) error {
	_, err := d.requestWithData(ctx, http.MethodPost, "/file/delete", map[string]any{
		"action_type":  1,
		"exclude_fids": []string{},
		"filelist":     []string{path},
	})
	return err
}

func (d *Quark) Open(path string) (driver.FileReader, error) {
	resp, err := d.requestWithData(context.Background(), http.MethodPost, "/file/download", map[string]any{
		"fids": []string{path},
	})
	if err != nil {
		return nil, err
	}

	result := gjson.ParseBytes(resp).Get("data.0")

	url := result.Get("download_url").String()
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
	return driver.NewFileReader(result.Get("size").Int(), rangeFunc)
}

func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	d := &Quark{
		opt:    opt,
		client: httputil.New(),
	}
	return opt.Option.NewFS(WrapFS(d, 60))
}

func init() {
	driver.Register("quark", func() driver.Option {
		return &Option{}
	})
}

package alist

import (
	"bytes"
	"context"
	"crypto/tls"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net"
	"net/http"
	"path/filepath"
	"strings"
	"time"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/tidwall/gjson"
)

type Option struct {
	Endpoint string `json:"endpoint"`
	Username string `json:"username"`
	Password string `json:"password"`
	RootPath string `json:"root_path"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Alist struct {
	driver.Base
	opt    *Option
	client *http.Client
	token  string
}

var _ driver.FS = (*Alist)(nil)

func (d *Alist) request(ctx context.Context, method, url string, r io.Reader, opts ...func(*http.Request)) (io.ReadCloser, error) {
	if strings.HasPrefix(url, "/") {
		url = strings.TrimSuffix(d.opt.Endpoint, "/") + url
	}

	req, err := http.NewRequestWithContext(ctx, method, url, r)
	if err != nil {
		return nil, err
	}

	headers := map[string]string{
		"X-Real-IP":  randomIP(),
		"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5, AppleWebKit/605.1.15 (KHTML, like Gecko,",
	}
	for k, v := range headers {
		req.Header.Set(k, v)
	}
	if d.token != "" {
		req.Header.Set("Authorization", d.token)
	}

	for _, opt := range opts {
		opt(req)
	}

	resp, err := d.client.Do(req)
	if err != nil {
		return nil, err
	}

	if resp.StatusCode == http.StatusPartialContent || resp.StatusCode == http.StatusOK {
		return resp.Body, nil
	}
	resp.Body.Close()
	return nil, fmt.Errorf("bad status: %d", resp.StatusCode)
}

func (d *Alist) requestWithData(ctx context.Context, method, url string, data map[string]any) ([]byte, error) {
	var (
		body io.Reader
	)

	if method != http.MethodGet && data != nil {
		buf, err := json.Marshal(data)
		if err != nil {
			return nil, err
		}
		body = bytes.NewBuffer(buf)
	}

	r, err := d.request(ctx, method, url, body, func(req *http.Request) {
		if method == http.MethodGet && data != nil {
			q := req.URL.Query()
			for k, v := range data {
				q.Add(k, fmt.Sprintf("%v", v))
			}
			req.URL.RawQuery = q.Encode()
		}
		req.Header.Set("Content-Type", "application/json")
	})
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
		return d.request(context.Background(), http.MethodGet, url, nil, func(req *http.Request) {
			if length > 0 {
				req.Header.Add("Range", fmt.Sprintf("bytes=%d-%d", offset, offset+length-1))
			} else {
				req.Header.Add("Range", fmt.Sprintf("bytes=%d-", offset))
			}
		})
	}
	return driver.NewFileReader(result.Get("data.size").Int(), rangeFunc)
}

func (d *Alist) Create(path string) (driver.FileWriter, error) {
	r, w := io.Pipe()
	go func() {
		resp, err := d.request(context.Background(), http.MethodPut, "/api/fs/put", r, func(req *http.Request) {
			req.Header.Set("File-Path", path)
			req.Header.Set("Password", "")
		})
		if err != nil {
			r.CloseWithError(err)
			return
		}
		defer resp.Close()
		r.Close()
	}()
	return w, nil
}

func newClient() *http.Client {
	transport := &http.Transport{
		IdleConnTimeout:       120 * time.Second,
		ResponseHeaderTimeout: 20 * time.Second,
		Dial: (&net.Dialer{
			Timeout:   3 * time.Second,
			KeepAlive: 60 * time.Second,
		}).Dial,
		TLSClientConfig: &tls.Config{
			InsecureSkipVerify: true,
		},
	}
	return &http.Client{
		Transport: transport,
		Timeout:   10 * time.Second,
	}
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
	d := &Alist{
		opt:    opt,
		client: newClient(),
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

package mirror

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
	"github.com/honmaple/maple-file/server/pkg/driver"
	httputil "github.com/honmaple/maple-file/server/pkg/util/http"
)

type Option struct {
	Endpoint string `json:"endpoint"  validate:"required"`
	Format   string `json:"format"`
	RootPath string `json:"root_path" validate:"omitempty,startswith=/"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Mirror struct {
	driver.Base
	opt    *Option
	client *httputil.Client
}

var _ driver.FS = (*Mirror)(nil)

func (d *Mirror) getURL(path string) string {
	return strings.TrimSuffix(d.opt.Endpoint, "/") + filepath.Clean(path)
}

func (d *Mirror) List(ctx context.Context, path string) ([]driver.File, error) {
	file, err := d.Get(path)
	if err != nil {
		return nil, err
	}
	if !file.IsDir() {
		return []driver.File{file}, nil
	}

	resp, err := d.client.Request(http.MethodGet, d.getURL(path), httputil.WithContext(ctx))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if code := resp.StatusCode; code != http.StatusOK {
		return nil, fmt.Errorf("bad status: %d", resp.StatusCode)
	}

	doc, err := goquery.NewDocumentFromReader(resp.Body)
	if err != nil {
		return nil, err
	}

	var files []driver.File

	switch d.opt.Format {
	case "tuna":
		files = parseTuna(path, doc)
	case "aliyun":
		files = parseAliyun(path, doc)
	default:
		files = parseNginx(path, doc)
	}
	return files, nil
}

func (d *Mirror) Get(path string) (driver.File, error) {
	resp, err := d.client.Request(http.MethodHead, d.getURL(path))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if code := resp.StatusCode; code != http.StatusOK {
		return nil, fmt.Errorf("bad status: %d", resp.StatusCode)
	}

	info := &fileinfo{
		name: filepath.Base(path),
	}
	if typ := resp.Header.Get("Content-Type"); strings.HasPrefix(typ, "text/html") {
		info.isDir = true
		return driver.NewFile(filepath.Dir(path), info), nil
	}

	size, err := strconv.Atoi(resp.Header.Get("Content-Length"))
	if err != nil {
		return nil, err
	}
	modTime, err := time.Parse(time.RFC1123, resp.Header.Get("Last-Modified"))
	if err != nil {
		return nil, err
	}
	info.size = int64(size)
	info.modTime = modTime
	return driver.NewFile(filepath.Dir(path), info), nil
}

func (d *Mirror) Open(path string) (driver.FileReader, error) {
	info, err := d.Get(path)
	if err != nil {
		return nil, err
	}
	if info.IsDir() {
		return nil, errors.New("can't open dir")
	}

	rangeFunc := func(offset, length int64) (io.ReadCloser, error) {
		resp, err := d.client.Request(http.MethodGet, d.getURL(path), httputil.WithNeverTimeout(), httputil.WithRequest(func(req *http.Request) {
			if length > 0 {
				req.Header.Add("Range", fmt.Sprintf("bytes=%d-%d", offset, offset+length-1))
			} else {
				req.Header.Add("Range", fmt.Sprintf("bytes=%d-", offset))
			}
		}))
		if err != nil {
			return nil, err
		}
		return resp.Body, nil
	}
	return driver.NewFileReader(info.Size(), rangeFunc)
}

func New(opt *Option) (driver.FS, error) {
	d := &Mirror{
		opt:    opt,
		client: httputil.New(),
	}

	if opt.RootPath != "" {
		return driver.PrefixFS(d, opt.RootPath), nil
	}
	return d, nil
}

func init() {
	driver.Register("mirror", func() driver.Option {
		return &Option{}
	})
}

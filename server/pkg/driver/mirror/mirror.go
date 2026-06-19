package mirror

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"

	filepath "path"

	"github.com/PuerkitoBio/goquery"
	"github.com/honmaple/cloudfs"
	cloudfsdriver "github.com/honmaple/cloudfs/driver"
	mapledriver "github.com/honmaple/maple-file/server/pkg/driver"
	httputil "github.com/honmaple/maple-file/server/pkg/util/http"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type Option struct {
	mapledriver.CommonOption
	Endpoint string `json:"endpoint"  validate:"required"`
	Format   string `json:"format"`
}

func (opt *Option) NewFS() (cloudfs.FS, error) {
	return New(opt)
}

type Mirror struct {
	cloudfs.BaseFS
	opt    *Option
	client *httputil.Client
}

var _ cloudfs.FS = (*Mirror)(nil)

func (d *Mirror) getURL(path string) string {
	return strings.TrimSuffix(d.opt.Endpoint, "/") + path
}

func (d *Mirror) List(ctx context.Context, path string, _ ...cloudfs.ListOption) ([]cloudfs.FileInfo, error) {
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

	var files []cloudfs.FileInfo

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

func (d *Mirror) Stat(ctx context.Context, path string) (cloudfs.FileInfo, error) {
	resp, err := d.client.Request(http.MethodHead, d.getURL(path), httputil.WithContext(ctx))
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
		return newFile(path, info), nil
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
	return newFile(path, info), nil
}

func (d *Mirror) Open(ctx context.Context, path string) (cloudfs.File, error) {
	info, err := d.Stat(ctx, path)
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
	return cloudfs.NewFile(info.Size(), rangeFunc)
}

func New(opt *Option) (cloudfs.FS, error) {
	if err := util.VerifyOption(opt); err != nil {
		return nil, err
	}

	raw := &Mirror{
		opt:    opt,
		client: httputil.New(),
	}
	wraps, err := mapledriver.NewCommonWraps(&opt.CommonOption)
	if err != nil {
		return nil, err
	}
	return cloudfs.New(raw, wraps...)
}

func init() {
	cloudfsdriver.Register("mirror", func() cloudfsdriver.Option {
		return &Option{}
	})
}

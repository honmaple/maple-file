package upyun

import (
	"context"
	"fmt"
	"io"
	"path/filepath"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/upyun/go-sdk/v3/upyun"
)

type Option struct {
	Bucket   string `json:"bucket"    validate:"required"`
	Operator string `json:"operator"  validate:"required"`
	Password string `json:"password"  validate:"required"`
	RootPath string `json:"root_path" validate:"omitempty,startswith=/"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Upyun struct {
	driver.Base
	opt    *Option
	client *upyun.UpYun
}

var _ driver.FS = (*Upyun)(nil)

func (d *Upyun) List(ctx context.Context, path string) ([]driver.File, error) {
	errs := make(chan error, 1)

	infos := make(chan *upyun.FileInfo)
	go func() {
		errs <- d.client.List(&upyun.GetObjectsConfig{
			Path:        path,
			ObjectsChan: infos,
		})
	}()

	files := make([]driver.File, 0)
	for info := range infos {
		files = append(files, driver.NewFile(path, &fileinfo{info}))
	}

	if err := <-errs; err != nil {
		return nil, err
	}
	return files, nil
}

func (d *Upyun) Rename(ctx context.Context, path, newName string) error {
	return d.Move(ctx, path, filepath.Join(filepath.Dir(path), newName))
}

func (d *Upyun) Move(ctx context.Context, src, dst string) error {
	return d.client.Move(&upyun.MoveObjectConfig{
		SrcPath:  src,
		DestPath: dst,
	})
}

func (d *Upyun) Copy(ctx context.Context, src, dst string) error {
	return d.client.Copy(&upyun.CopyObjectConfig{
		SrcPath:  src,
		DestPath: dst,
	})
}

func (d *Upyun) Remove(ctx context.Context, path string) error {
	return d.client.Delete(&upyun.DeleteObjectConfig{
		Path:  path,
		Async: false,
	})
}

func (d *Upyun) MakeDir(ctx context.Context, path string) error {
	return d.client.Mkdir(path)
}

func (d *Upyun) Get(path string) (driver.File, error) {
	info, err := d.client.GetInfo(path)
	if err != nil {
		return nil, err
	}
	return driver.NewFile(filepath.Dir(path), &fileinfo{info}), nil
}

func (d *Upyun) Open(path string) (driver.FileReader, error) {
	info, err := d.client.GetInfo(path)
	if err != nil {
		return nil, err
	}

	rangeFunc := func(offset, length int64) (io.ReadCloser, error) {
		headers := make(map[string]string)
		if length > 0 {
			headers["Range"] = fmt.Sprintf("bytes=%d-%d", offset, offset+length-1)
		} else {
			headers["Range"] = fmt.Sprintf("bytes=%d-", offset)
		}

		r, w := io.Pipe()
		go func() {
			_, err := d.client.Get(&upyun.GetObjectConfig{
				Path:    path,
				Writer:  w,
				Headers: headers,
			})
			w.CloseWithError(err)
		}()
		return r, nil
	}
	return driver.NewFileReader(info.Size, rangeFunc)
}

func (d *Upyun) Create(path string) (driver.FileWriter, error) {
	r, w := io.Pipe()
	go func() {
		err := d.client.Put(&upyun.PutObjectConfig{
			Path:   path,
			Reader: r,
		})
		r.CloseWithError(err)
	}()
	return w, nil
}

func (d *Upyun) Close() error {
	// 不要执行d.client.Close(), 会导致 panic: close of nil channel
	return nil
}

func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	d := &Upyun{
		opt: opt,
		client: upyun.NewUpYun(&upyun.UpYunConfig{
			Bucket:   opt.Bucket,
			Operator: opt.Operator,
			Password: opt.Password,
		}),
	}
	if opt.RootPath != "" {
		return driver.PrefixFS(d, opt.RootPath), nil
	}
	return d, nil
}

func init() {
	driver.Register("upyun", func() driver.Option {
		return &Option{}
	})
}

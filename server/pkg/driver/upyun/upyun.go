package upyun

import (
	"context"
	"errors"
	"io"
	"io/fs"
	"path/filepath"

	"github.com/honmaple/maple-file/server/pkg/driver"

	"github.com/upyun/go-sdk/v3/upyun"
)

type Option struct {
	Endpoint string `json:"endpoint"`
	Bucket   string `json:"bucket"`
	Operator string `json:"operator"`
	Password string `json:"password"`
	RootPath string `json:"root_path"`
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

func (d *Upyun) walkDir(ctx context.Context, root string, fi fs.FileInfo, fn driver.WalkDirFunc) error {
	if fi == nil {
		i, err := d.client.GetInfo(root)
		if err != nil {
			return err
		}
		fi = &fileinfo{i}

		if err = fn(driver.NewFile(root, fi), nil); err != nil {
			return err
		}
	}

	if !fi.IsDir() {
		return nil
	}

	iter := ""
	for {
		infos, it, err := d.client.ListObjects(&upyun.ListObjectsConfig{
			Path: root,
			Iter: iter,
		})
		if err != nil {
			return err
		}
		for _, i := range infos {
			info := &fileinfo{i}
			file := driver.NewFile(root, info)

			if err := fn(file, nil); err != nil {
				if info.IsDir() && errors.Is(err, fs.SkipDir) {
					continue
				}
				return err
			}
			if !info.IsDir() {
				continue
			}
			if err := d.walkDir(ctx, filepath.Join(root, info.Name()), info, fn); err != nil {
				return err
			}
		}
		if it == "" {
			break
		}
		iter = it
	}
	return nil
}

func (d *Upyun) WalkDir(ctx context.Context, root string, fn driver.WalkDirFunc) error {
	return d.walkDir(ctx, root, nil, fn)
}

func (d *Upyun) List(ctx context.Context, path string) ([]driver.File, error) {
	info, err := d.client.GetInfo(path)
	if err != nil {
		return nil, err
	}

	fi := &fileinfo{info}

	if fi.IsDir() {
		files := make([]driver.File, 0)

		if err := d.walkDir(ctx, path, fi, func(file driver.File, err error) error {
			if err != nil {
				return err
			}
			files = append(files, file)
			if file.IsDir() {
				return fs.SkipDir
			}
			return nil
		}); err != nil {
			return nil, err
		}
		return files, nil
	}
	return []driver.File{driver.NewFile(path, fi)}, nil
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

	r, w := io.Pipe()
	go func() {
		_, err := d.client.Get(&upyun.GetObjectConfig{
			Path:   path,
			Writer: w,
		})
		w.CloseWithError(err)
	}()
	return driver.ReadSeeker(r, info.Size), nil
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

func New(opt *Option) (driver.FS, error) {
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

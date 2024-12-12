package webdav

import (
	"context"
	"errors"
	"io"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/honmaple/maple-file/server/pkg/driver"

	"github.com/studio-b12/gowebdav"
)

type Option struct {
	Endpoint string      `json:"Endpoint"`
	Username string      `json:"username"`
	Password string      `json:"password"`
	DirPerm  os.FileMode `json:"dir_perm"`
	RootPath string      `json:"root_path"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Webdav struct {
	driver.Base
	opt    *Option
	client *gowebdav.Client
}

var _ driver.FS = (*Webdav)(nil)

func (d *Webdav) walkDir(ctx context.Context, root string, fi fs.FileInfo, fn driver.WalkDirFunc) error {
	if fi == nil {
		i, err := d.client.Stat(root)
		if err != nil {
			return err
		}
		fi = i

		if err = fn(driver.NewFile(root, fi), nil); err != nil {
			return err
		}
	}
	if !fi.IsDir() {
		return nil
	}

	infos, err := d.client.ReadDir(root)
	if err != nil {
		return err
	}

	for _, info := range infos {
		path := filepath.Join(root, info.Name())
		file := driver.NewFile(path, info)

		if err := fn(file, nil); err != nil {
			if info.IsDir() && errors.Is(err, fs.SkipDir) {
				continue
			}
			return err
		}
		if !info.IsDir() {
			continue
		}
		if err := d.walkDir(ctx, path, info, fn); err != nil {
			return err
		}
	}
	return nil
}

func (d *Webdav) WalkDir(ctx context.Context, root string, fn driver.WalkDirFunc) error {
	return d.walkDir(ctx, root, nil, fn)
}

func (d *Webdav) List(ctx context.Context, path string) ([]driver.File, error) {
	fi, err := d.client.Stat(path)
	if err != nil {
		return nil, err
	}
	if fi.IsDir() {
		infos, err := d.client.ReadDir(path)
		if err != nil {
			return nil, err
		}

		files := make([]driver.File, len(infos))
		for i, info := range infos {
			files[i] = driver.NewFile(path, info)
		}
		return files, nil
	}
	return []driver.File{driver.NewFile(path, fi)}, nil
}

func (d *Webdav) Move(ctx context.Context, src, dst string) error {
	return d.client.Rename(src, dst, false)
}

func (d *Webdav) Copy(ctx context.Context, src, dst string) error {
	return d.client.Copy(src, dst, false)
}

func (d *Webdav) Rename(ctx context.Context, path, newName string) error {
	return d.client.Rename(path, filepath.Join(filepath.Dir(path), newName), false)
}

func (d *Webdav) Remove(ctx context.Context, path string) error {
	return d.client.Remove(path)
}

func (d *Webdav) MakeDir(ctx context.Context, path string) error {
	return d.client.MkdirAll(path, d.opt.DirPerm)
}

func (d *Webdav) Open(path string) (driver.FileReader, error) {
	info, err := d.client.Stat(path)
	if err != nil {
		return nil, err
	}

	// r, err := d.client.ReadStream(path)
	// if err != nil {
	//	return nil, err
	// }

	rangeFunc := func(offset, length int64) (io.ReadCloser, error) {
		return d.client.ReadStreamRange(path, offset, length)
	}
	return driver.NewFileReader(info.Size(), rangeFunc)

}

func (d *Webdav) Create(path string) (driver.FileWriter, error) {
	r, w := io.Pipe()
	go func() {
		r.CloseWithError(d.client.WriteStream(path, r, d.opt.DirPerm))
	}()
	return w, nil
}

func (d *Webdav) Get(path string) (driver.File, error) {
	fi, err := d.client.Stat(path)
	if err != nil {
		return nil, err
	}
	// 绿联webdav stat无法获取文件名
	return driver.NewFile(filepath.Dir(path), &fileinfo{FileInfo: fi, name: filepath.Base(path)}), nil
}

func (d *Webdav) Close() error {
	return nil
}

func New(opt *Option) (driver.FS, error) {
	// if opt.DirPerm == 0 {
	//	opt.DirPerm = 755
	// }
	opt.DirPerm = 0755

	client := gowebdav.NewAuthClient(opt.Endpoint, gowebdav.NewAutoAuth(opt.Username, opt.Password))
	if err := client.Connect(); err != nil {
		return nil, err
	}
	d := &Webdav{opt: opt, client: client}
	if opt.RootPath != "" {
		return driver.PrefixFS(d, opt.RootPath), nil
	}
	return d, nil
}

func init() {
	driver.Register("webdav", func() driver.Option {
		return &Option{}
	})
}

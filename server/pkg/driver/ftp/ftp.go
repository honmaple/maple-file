package ftp

import (
	"context"
	"fmt"
	"io"
	"path/filepath"
	"time"

	"github.com/honmaple/maple-file/server/pkg/driver"

	"github.com/jlaffaye/ftp"
)

type Option struct {
	Host     string `json:"host"`
	Port     int    `json:"port"`
	Username string `json:"username"`
	Password string `json:"password"`
	RootPath string `json:"root_path"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type FTP struct {
	driver.Base
	opt    *Option
	client *ftp.ServerConn
}

var _ driver.FS = (*FTP)(nil)

func (d *FTP) Close() error {
	return d.client.Logout()
}

func (d *FTP) Get(path string) (driver.File, error) {
	info, err := d.client.GetEntry(path)
	if err != nil {
		return nil, err
	}
	return driver.NewFile(filepath.Dir(path), &fileinfo{info}), nil
}

func (d *FTP) Open(path string) (driver.FileReader, error) {
	info, err := d.client.GetEntry(path)
	if err != nil {
		return nil, err
	}

	r, err := d.client.Retr(path)
	if err != nil {
		return nil, err
	}
	return driver.ReadSeeker(r, int64(info.Size)), nil
}

func (d *FTP) Create(path string) (driver.FileWriter, error) {
	r, w := io.Pipe()
	go func() {
		err := d.client.Stor(path, r)
		r.CloseWithError(err)
	}()
	return w, nil
}

func (d *FTP) WalkDir(ctx context.Context, root string, fn driver.WalkDirFunc) error {
	walker := d.client.Walk(root)
	for walker.Next() {
		if walker.Err() != nil {
			continue
		}
		err := fn(driver.NewFile(walker.Path(), &fileinfo{walker.Stat()}), walker.Err())
		if err == io.EOF {
			return nil
		}
		if err != nil {
			return err
		}
	}
	return nil
}

func (d *FTP) List(ctx context.Context, path string) ([]driver.File, error) {
	fi, err := d.client.GetEntry(path)
	if err != nil {
		return nil, err
	}

	if fi.Type == ftp.EntryTypeFolder {
		entries, err := d.client.List(path)
		if err != nil {
			return nil, err
		}

		files := make([]driver.File, len(entries))
		for i, info := range entries {
			files[i] = driver.NewFile(path, &fileinfo{info})
		}
		return files, nil
	}
	return []driver.File{driver.NewFile(path, &fileinfo{fi})}, nil
}

func (d *FTP) Move(ctx context.Context, src, dst string) error {
	return d.client.Rename(src, dst)
}

func (d *FTP) Copy(ctx context.Context, src, dst string) error {
	return driver.ErrNotSupport
}

func (d *FTP) Rename(ctx context.Context, path, newName string) error {
	return d.client.Rename(path, filepath.Join(filepath.Dir(path), newName))
}

func (d *FTP) MakeDir(ctx context.Context, path string) error {
	return d.client.MakeDir(path)
}

func (d *FTP) removeFile(path string) error {
	return d.client.Delete(path)
}

func (d *FTP) removeDir(path string) error {
	return d.client.RemoveDirRecur(path)
}

func (d *FTP) Remove(ctx context.Context, path string) error {
	fi, err := d.client.GetEntry(path)
	if err != nil {
		return err
	}
	if fi.Type == ftp.EntryTypeFolder {
		return d.removeDir(path)
	}
	return d.removeFile(path)
}

func New(opt *Option) (driver.FS, error) {
	if opt.Username == "" || opt.Password == "" {
		return nil, driver.ErrOption
	}

	if opt.Port == 0 {
		opt.Port = 21
	}

	conn, err := ftp.Dial(fmt.Sprintf("%s:%d", opt.Host, opt.Port), ftp.DialWithTimeout(10*time.Second))
	if err != nil {
		return nil, err
	}

	if err := conn.Login(opt.Username, opt.Password); err != nil {
		return nil, err
	}

	d := &FTP{opt: opt, client: conn}
	if opt.RootPath != "" {
		return driver.PrefixFS(d, opt.RootPath), nil
	}
	return d, nil
}

func init() {
	driver.Register("ftp", func() driver.Option {
		return &Option{}
	})
}

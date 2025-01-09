package ftp

import (
	"context"
	"fmt"
	"io"
	"io/fs"
	"time"

	filepath "path"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
	"github.com/honmaple/maple-file/server/pkg/util"
	"github.com/jlaffaye/ftp"
)

type Option struct {
	base.Option
	Host     string `json:"host"      validate:"required"`
	Port     int    `json:"port"`
	Username string `json:"username"  validate:"required"`
	Password string `json:"password"  validate:"required"`
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

func (d *FTP) Get(ctx context.Context, path string) (driver.File, error) {
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
	if info.Type == ftp.EntryTypeFolder {
		return nil, &fs.PathError{Op: "open", Path: path, Err: driver.ErrOpenDirectory}
	}

	rangeFunc := func(offset, length int64) (io.ReadCloser, error) {
		return d.client.RetrFrom(path, uint64(offset))
	}
	return driver.NewFileReader(int64(info.Size), rangeFunc)
}

func (d *FTP) Create(path string) (driver.FileWriter, error) {
	r, w := util.Pipe()
	go func() {
		err := d.client.Stor(path, r)
		r.CloseWithError(err)
	}()
	return w, nil
}

func (d *FTP) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
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

func (d *FTP) Move(ctx context.Context, src, dst string) error {
	return d.client.Rename(src, dst)
}

func (d *FTP) Copy(ctx context.Context, src, dst string) error {
	return driver.Copy(ctx, d, src, dst)
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
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
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
	return opt.Option.NewFS(d)
}

func init() {
	driver.Register("ftp", func() driver.Option {
		return &Option{}
	})
}

package smb

import (
	"context"
	"fmt"
	"io/fs"
	"net"
	"path/filepath"
	"strings"

	"github.com/hirochachacha/go-smb2"
	"github.com/honmaple/maple-file/server/pkg/driver"
)

type Option struct {
	Host      string `json:"host"       validate:"required"`
	Port      int    `json:"port"`
	Username  string `json:"username"   validate:"required"`
	Password  string `json:"password"   validate:"required"`
	ShareName string `json:"share_name" validate:"required"`
	RootPath  string `json:"root_path"  validate:"omitempty,startswith=/"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type SMB struct {
	driver.Base
	opt    *Option
	client *smb2.Share
}

var _ driver.FS = (*SMB)(nil)

func (d *SMB) Close() error {
	return d.client.Umount()
}

func (d *SMB) Get(path string) (driver.File, error) {
	info, err := d.client.Stat(path)
	if err != nil {
		return nil, err
	}
	return driver.NewFile(path, info), nil
}

func (d *SMB) Open(path string) (driver.FileReader, error) {
	return d.client.Open(path)
}

func (d *SMB) Create(path string) (driver.FileWriter, error) {
	return d.client.Create(path)
}

func (d *SMB) WalkDir(ctx context.Context, root string, fn driver.WalkDirFunc) error {
	return fs.WalkDir(d.client.DirFS(root), ".", func(path string, entry fs.DirEntry, err error) error {
		if err != nil {
			return fn(nil, err)
		}
		info, err := entry.Info()
		if err != nil {
			return fn(nil, err)
		}
		return fn(driver.NewFile(path, info), nil)
	})
}

func (d *SMB) List(ctx context.Context, path string) ([]driver.File, error) {
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

func (d *SMB) Move(ctx context.Context, src, dst string) error {
	return d.client.Rename(src, dst)
}

func (d *SMB) Copy(ctx context.Context, src, dst string) error {
	return driver.ErrNotSupport
}

func (d *SMB) Rename(ctx context.Context, path, newName string) error {
	return d.client.Rename(path, filepath.Join(filepath.Dir(path), newName))
}

func (d *SMB) MakeDir(ctx context.Context, path string) error {
	return d.client.Mkdir(path, 0700)
}

func (d *SMB) removeFile(path string) error {
	return d.client.Remove(path)
}

func (d *SMB) removeDir(path string) error {
	return d.client.RemoveAll(path)
}

func (d *SMB) Remove(ctx context.Context, path string) error {
	fi, err := d.client.Stat(path)
	if err != nil {
		return err
	}
	if fi.IsDir() {
		return d.removeDir(path)
	}
	return d.removeFile(path)
}

func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	if opt.Port == 0 {
		opt.Port = 445
	}

	conn, err := net.Dial("tcp", fmt.Sprintf("%s:%d", opt.Host, opt.Port))
	if err != nil {
		return nil, err
	}

	dialer := &smb2.Dialer{
		Initiator: &smb2.NTLMInitiator{
			User:     opt.Username,
			Password: opt.Password,
		},
	}

	s, err := dialer.Dial(conn)
	if err != nil {
		return nil, err
	}

	client, err := s.Mount(opt.ShareName)
	if err != nil {
		return nil, err
	}

	d := &SMB{opt: opt, client: client}

	if opt.RootPath != "" {
		return driver.PrefixFS(d, opt.RootPath), nil
	}
	return driver.NewFS(
		// smb访问路径不能以/开头
		func(path string) (driver.FS, string, error) {
			return d, strings.TrimPrefix(path, "/"), nil
		},
		func(root string, file driver.File) driver.File {
			return file
		},
	), nil
}

func init() {
	driver.Register("smb", func() driver.Option {
		return &Option{}
	})
}

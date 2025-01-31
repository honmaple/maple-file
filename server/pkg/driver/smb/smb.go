package smb

import (
	"context"
	"errors"
	"fmt"
	"io/fs"
	"net"

	filepath "path"

	"github.com/hirochachacha/go-smb2"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type Option struct {
	base.Option
	Host      string `json:"host"       validate:"required"`
	Port      int    `json:"port"`
	Username  string `json:"username"   validate:"required"`
	Password  string `json:"password"   validate:"required"`
	Domain    string `json:"domain"`
	ShareName string `json:"share_name" validate:"required"`
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

func (d *SMB) Get(ctx context.Context, path string) (driver.File, error) {
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

func (d *SMB) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
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

func (d *SMB) Move(ctx context.Context, src, dst string) error {
	return d.client.Rename(src, dst)
}

func (d *SMB) copyFile(ctx context.Context, src, dst string) error {
	srcFile, err := d.client.Open(src)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	dstFile, err := d.client.Open(dst)
	if err != nil {
		return err
	}

	if _, err = util.CopyWithContext(ctx, dstFile, srcFile); err != nil {
		dstFile.Close()
		return err
	}

	if err = dstFile.Close(); err != nil {
		return err
	}

	info, err := d.client.Stat(src)
	if err != nil {
		return err
	}
	return d.client.Chmod(dst, info.Mode())
}

func (d *SMB) copyDir(ctx context.Context, src, dst string) error {
	info, err := d.client.Stat(src)
	if err != nil {
		return err
	}

	if err := d.client.MkdirAll(dst, info.Mode()); err != nil {
		return err
	}

	files, err := d.client.ReadDir(src)
	if err != nil {
		return fmt.Errorf("cannot read dir %s: %s", src, err.Error())
	}

	for _, file := range files {
		srcPath := filepath.Join(src, file.Name())
		dstPath := filepath.Join(dst, file.Name())

		if file.IsDir() {
			err = d.copyDir(ctx, srcPath, dstPath)
		} else {
			err = d.copyFile(ctx, srcPath, dstPath)
		}
		if err != nil {
			return err
		}
	}
	return nil
}

func (d *SMB) Copy(ctx context.Context, src, dst string) error {
	dstFile, err := d.Get(ctx, dst)
	if err != nil {
		return err
	} else if !dstFile.IsDir() {
		return &fs.PathError{Op: "copy", Path: dst, Err: errors.New("copy dst must be a dir")}
	} else {
		dst = filepath.Join(dst, filepath.Base(src))
	}

	srcFile, err := d.Get(ctx, src)
	if err != nil {
		return err
	}
	if srcFile.IsDir() {
		return d.copyDir(ctx, src, dst)
	}
	return d.copyFile(ctx, src, dst)
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
			Domain:   opt.Domain,
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

	// smb访问路径不能以/开头
	return opt.Option.NewFS(base.TrimPrefixFS(d, "/"))
}

func init() {
	driver.Register("smb", func() driver.Option {
		return &Option{}
	})
}

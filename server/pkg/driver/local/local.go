package local

import (
	"context"
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type Option struct {
	base.Option
	Path    string `json:"path" validate:"required,startswith=/"`
	DirPerm uint32 `json:"-"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Local struct {
	driver.Base
	opt *Option
}

func (d *Local) getActualPath(path string) string {
	return filepath.Join(d.opt.Path, path)
}

func (d *Local) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	entries, err := os.ReadDir(d.getActualPath(path))
	if err != nil {
		return nil, err
	}

	files := make([]driver.File, len(entries))
	for i, entry := range entries {
		info, err := entry.Info()
		if err != nil {
			return nil, err
		}
		files[i] = driver.NewFile(path, info)
	}
	return files, nil
}

func (d *Local) Get(ctx context.Context, path string) (driver.File, error) {
	info, err := os.Stat(d.getActualPath(path))
	if err != nil {
		return nil, err
	}
	return driver.NewFile(filepath.Dir(path), info), nil
}

func (d *Local) Open(path string) (driver.FileReader, error) {
	return os.Open(d.getActualPath(path))
}

func (d *Local) Create(path string) (driver.FileWriter, error) {
	return os.Create(d.getActualPath(path))
}

func (d *Local) Rename(ctx context.Context, path, newName string) error {
	actualPath := d.getActualPath(path)
	return os.Rename(actualPath, filepath.Join(filepath.Dir(actualPath), newName))
}

func (d *Local) Move(ctx context.Context, src, dst string) error {
	dstFile, err := d.Get(ctx, dst)
	if err != nil {
		return err
	}
	if !dstFile.IsDir() {
		return errors.New("move dst must be a dir")
	}
	return os.Rename(d.getActualPath(src), filepath.Join(d.getActualPath(dst), filepath.Base(src)))
}

func (d *Local) copyFile(ctx context.Context, src, dst string) error {
	srcFile, err := os.Open(src)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	dstFile, err := os.Create(dst)
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

	info, err := os.Stat(src)
	if err != nil {
		return err
	}
	return os.Chmod(dst, info.Mode())
}

func (d *Local) copyDir(ctx context.Context, src, dst string) error {
	info, err := os.Stat(src)
	if err != nil {
		return err
	}

	if err := os.MkdirAll(dst, info.Mode()); err != nil {
		return err
	}

	files, err := os.ReadDir(src)
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

func (d *Local) Copy(ctx context.Context, src, dst string) error {
	dstFile, err := d.Get(ctx, dst)
	if err != nil {
		return err
	}
	if !dstFile.IsDir() {
		return errors.New("copy dst must be a dir")
	}

	srcFile, err := d.Get(ctx, src)
	if err != nil {
		return err
	}

	src = d.getActualPath(src)
	dst = filepath.Join(d.getActualPath(dst), filepath.Base(src))
	if srcFile.IsDir() {
		return d.copyDir(ctx, src, dst)
	}
	return d.copyFile(ctx, src, dst)
}

func (d *Local) MakeDir(ctx context.Context, path string) error {
	return os.MkdirAll(d.getActualPath(path), fs.FileMode(0755))
}

func (d *Local) Remove(ctx context.Context, path string) error {
	file, err := d.Get(ctx, path)
	if err != nil {
		return err
	}

	actualPath := d.getActualPath(path)
	if file.IsDir() {
		return os.RemoveAll(actualPath)
	}
	return os.Remove(actualPath)
}

func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}
	if util.CleanPath(opt.Path) != opt.Path {
		return nil, fs.ErrInvalid
	}

	opt.DirPerm = 0755

	d := &Local{opt: opt}
	return opt.Option.NewFS(d)
}

func init() {
	driver.Register("local", func() driver.Option {
		return &Option{}
	})
}

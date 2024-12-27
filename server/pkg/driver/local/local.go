package local

import (
	"context"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
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

func fileExists(path string) bool {
	if _, err := os.Stat(path); os.IsExist(err) || err == nil {
		return true
	}
	return false
}

func isDir(src string) (bool, error) {
	fi, err := os.Lstat(src)
	if err != nil {
		return false, err
	}
	return fi.IsDir(), nil
}

func copyDir(src, dst string) error {
	src = filepath.Clean(src)
	dst = filepath.Clean(dst)

	// We use os.Lstat() here to ensure we don't fall in a loop where a symlink
	// actually links to a one of its parent directories.
	fi, err := os.Lstat(src)
	if err != nil {
		return err
	}
	if !fi.IsDir() {
		return driver.ErrSrcNotExist
	}

	_, err = os.Stat(dst)
	if err != nil && !os.IsNotExist(err) {
		return err
	}
	if err == nil {
		return driver.ErrDstIsExist
	}

	if err = os.MkdirAll(dst, fi.Mode()); err != nil {
		return fmt.Errorf("cannot mkdir %s: %s", dst, err.Error())
	}

	files, err := os.ReadDir(src)
	if err != nil {
		return fmt.Errorf("cannot read directory %s: %s", dst, err.Error())
	}

	for _, file := range files {
		srcPath := filepath.Join(src, file.Name())
		dstPath := filepath.Join(dst, file.Name())

		if file.IsDir() {
			if err = copyDir(srcPath, dstPath); err != nil {
				return fmt.Errorf("copying directory failed: %s", err.Error())
			}
		} else {
			if err = copyFile(srcPath, dstPath); err != nil {
				return fmt.Errorf("copying file failed: %s", err.Error())
			}
		}
	}

	return nil
}

func copyFile(src, dst string) (err error) {
	in, err := os.Open(src)
	if err != nil {
		return
	}
	defer in.Close()

	out, err := os.Create(dst)
	if err != nil {
		return
	}

	if _, err = io.Copy(out, in); err != nil {
		out.Close()
		return
	}

	if err = out.Close(); err != nil {
		return
	}

	info, err := in.Stat()
	if err != nil {
		return
	}
	err = os.Chmod(dst, info.Mode())
	return
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
	src = d.getActualPath(src)
	dst = filepath.Join(d.getActualPath(dst), filepath.Base(src))
	return os.Rename(src, dst)
}

func (d *Local) Copy(ctx context.Context, src, dst string) error {
	src = d.getActualPath(src)
	dst = filepath.Join(d.getActualPath(dst), filepath.Base(src))

	if ok, err := isDir(src); err != nil {
		return err
	} else if ok {
		return copyDir(src, dst)
	}
	return copyFile(src, dst)
}

func (d *Local) MakeDir(ctx context.Context, path string) error {
	return os.MkdirAll(d.getActualPath(path), fs.FileMode(0755))
}

func (d *Local) Remove(ctx context.Context, path string) error {
	actualPath := d.getActualPath(path)

	fi, err := os.Stat(actualPath)
	if err != nil {
		return err
	}
	if fi.IsDir() {
		return os.RemoveAll(actualPath)
	}
	return os.Remove(actualPath)
}

func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	opt.Path = strings.TrimRight(opt.Path, "/")
	opt.DirPerm = 0755

	d := &Local{opt: opt}
	return opt.Option.NewFS(d)
}

func init() {
	driver.Register("local", func() driver.Option {
		return &Option{}
	})
}

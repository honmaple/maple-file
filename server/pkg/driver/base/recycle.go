package base

import (
	"context"
	"fmt"
	"io/fs"
	"path/filepath"
	"strings"
	"time"

	"github.com/honmaple/maple-file/server/pkg/driver"
)

const (
	recycleName = ".maplerecycle"
)

type RecycleOption struct {
	Path string `json:"path" validate:"omitempty,startswith=/"`
}

func (opt *RecycleOption) NewFS(fs driver.FS) (driver.FS, error) {
	return RecycleFS(fs, opt)
}

type recycleFS struct {
	driver.FS
	opt *RecycleOption
}

var _ driver.FS = (*recycleFS)(nil)

func (d *recycleFS) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	if path == d.opt.Path {
		_, err := d.FS.Get(ctx, path)
		if err != nil {
			err = d.FS.MakeDir(ctx, path)
		}
		if err != nil {
			return nil, err
		}
	}
	files, err := d.FS.List(ctx, path, metas...)
	if err != nil {
		return nil, err
	}

	if path == filepath.Dir(d.opt.Path) {
		exists := false
		for i, file := range files {
			if file.IsDir() && file.Name() == filepath.Base(d.opt.Path) {
				files[i] = driver.NewFile(file.Path(), file, func(info *driver.FileInfo) {
					info.Type = "RECYCLE"
				})
				exists = true
				break
			}
		}
		if !exists {
			info := &driver.FileInfo{
				Path:  path,
				Name:  filepath.Base(d.opt.Path),
				Type:  "RECYCLE",
				IsDir: true,
				Mode:  fs.ModeDir,
			}
			files = append(files, info.File())
		}
	}
	return files, nil
}

func (d *recycleFS) Remove(ctx context.Context, path string) error {
	if strings.HasPrefix(path, d.opt.Path) {
		return d.FS.Remove(ctx, path)
	}
	newName := fmt.Sprintf("%s.%s", filepath.Base(path), time.Now().Format("20060102150405"))
	if err := d.FS.Rename(ctx, path, newName); err != nil {
		return err
	}
	return d.FS.Move(ctx, filepath.Join(filepath.Dir(path), newName), d.opt.Path)
}

func RecycleFS(fs driver.FS, opt *RecycleOption) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	if opt.Path == "" {
		opt.Path = "/" + recycleName
	}
	return &recycleFS{FS: fs, opt: opt}, nil
}

package base

import (
	"context"
	filepath "path"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type HookOption struct {
	PathFn func(string) string
	FileFn func(driver.File) (driver.File, bool)
}

func (opt *HookOption) NewFS(fs driver.FS) (driver.FS, error) {
	return HookFS(fs, opt), nil
}

type hookFS struct {
	driver.FS
	opt *HookOption
}

var _ driver.FS = (*hookFS)(nil)

func (d *hookFS) getActualPath(path string) string {
	path = util.CleanPath(path)
	if d.opt.PathFn == nil {
		return path
	}
	return d.opt.PathFn(path)
}

func (d *hookFS) getActualFile(file driver.File) (driver.File, bool) {
	if d.opt.FileFn == nil {
		return file, true
	}
	return d.opt.FileFn(file)
}

func (d *hookFS) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	files, err := d.FS.List(ctx, d.getActualPath(path), metas...)
	if err != nil {
		return nil, err
	}
	if d.opt.FileFn == nil {
		return files, nil
	}

	newFiles := make([]driver.File, 0, len(files))
	for _, file := range files {
		newFile, ok := d.getActualFile(file)
		if !ok {
			continue
		}
		newFiles = append(newFiles, newFile)
	}
	return newFiles, nil
}

func (d *hookFS) Get(ctx context.Context, path string) (driver.File, error) {
	file, err := d.FS.Get(ctx, d.getActualPath(path))
	if err != nil {
		return nil, err
	}

	newFile, _ := d.getActualFile(file)
	return newFile, nil
}

func (d *hookFS) Open(path string) (driver.FileReader, error) {
	return d.FS.Open(d.getActualPath(path))
}

func (d *hookFS) Create(path string) (driver.FileWriter, error) {
	return d.FS.Create(d.getActualPath(path))
}

func (d *hookFS) Copy(ctx context.Context, src string, dst string) error {
	return d.FS.Copy(ctx, d.getActualPath(src), d.getActualPath(dst))
}

func (d *hookFS) Move(ctx context.Context, src string, dst string) error {
	return d.FS.Move(ctx, d.getActualPath(src), d.getActualPath(dst))
}

func (d *hookFS) Rename(ctx context.Context, path, newName string) error {
	return d.FS.Rename(ctx, d.getActualPath(path), newName)
}

func (d *hookFS) Remove(ctx context.Context, path string) error {
	return d.FS.Remove(ctx, d.getActualPath(path))
}

func (d *hookFS) MakeDir(ctx context.Context, path string) error {
	return d.FS.MakeDir(ctx, d.getActualPath(path))
}

func HookFS(fs driver.FS, opt *HookOption) driver.FS {
	return &hookFS{
		FS:  fs,
		opt: opt,
	}
}

func PrefixFS(fs driver.FS, prefix string) driver.FS {
	if prefix == "" {
		return fs
	}
	return HookFS(
		fs,
		&HookOption{
			PathFn: func(path string) string {
				return filepath.Join(prefix, path)
			},
			FileFn: func(file driver.File) (driver.File, bool) {
				return driver.NewFile(strings.TrimPrefix(file.Path(), prefix), file), true
			},
		},
	)
}

func TrimPrefixFS(fs driver.FS, prefix string) driver.FS {
	if prefix == "" {
		return fs
	}
	return HookFS(
		fs,
		&HookOption{
			PathFn: func(path string) string {
				return strings.TrimPrefix(path, prefix)
			},
			FileFn: func(file driver.File) (driver.File, bool) {
				return driver.NewFile(filepath.Join(prefix, file.Path()), file), true
			},
		},
	)
}

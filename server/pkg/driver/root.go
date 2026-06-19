package driver

import (
	"context"
	"strings"

	"github.com/honmaple/cloudfs"

	filepath "path"
)

type rootFS struct {
	cloudfs.BaseFS
	fn     func(string) (FS, string, error)
	fileFn func(string, cloudfs.FileInfo) cloudfs.FileInfo
}

var _ FS = (*rootFS)(nil)

func (d *rootFS) List(ctx context.Context, path string, opts ...cloudfs.ListOption) ([]cloudfs.FileInfo, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}

	files, err := dstFS.List(ctx, dstPath, opts...)
	if err != nil {
		return nil, err
	}
	root := strings.TrimSuffix(path, dstPath)
	for i, file := range files {
		files[i] = d.fileFn(root, file)
	}
	return files, nil
}

func (d *rootFS) Stat(ctx context.Context, path string) (cloudfs.FileInfo, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}

	file, err := dstFS.Stat(ctx, dstPath)
	if err != nil {
		return nil, err
	}
	file = d.fileFn(strings.TrimSuffix(path, dstPath), file)
	return file, nil
}

func (d *rootFS) Open(ctx context.Context, path string) (cloudfs.File, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}
	return dstFS.Open(ctx, dstPath)
}

func (d *rootFS) Create(ctx context.Context, path string) (cloudfs.FileWriter, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}
	return dstFS.Create(ctx, dstPath)
}

func (d *rootFS) Copy(ctx context.Context, src string, dst string) error {
	srcFS, srcPath, err := d.fn(src)
	if err != nil {
		return err
	}
	_, dstPath, err := d.fn(dst)
	if err != nil {
		return err
	}
	if strings.TrimSuffix(src, srcPath) != strings.TrimSuffix(dst, dstPath) {
		return ErrNotSupport
	}
	return srcFS.Copy(ctx, srcPath, dstPath)
}

func (d *rootFS) Move(ctx context.Context, src string, dst string) error {
	srcFS, srcPath, err := d.fn(src)
	if err != nil {
		return err
	}
	_, dstPath, err := d.fn(dst)
	if err != nil {
		return err
	}
	if strings.TrimSuffix(src, srcPath) != strings.TrimSuffix(dst, dstPath) {
		return ErrNotSupport
	}
	return srcFS.Move(ctx, srcPath, dstPath)
}

func (d *rootFS) Rename(ctx context.Context, path, newName string) error {
	srcFS, srcPath, err := d.fn(path)
	if err != nil {
		return err
	}
	return srcFS.Rename(ctx, srcPath, newName)
}

func (d *rootFS) Remove(ctx context.Context, path string) error {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return err
	}
	return dstFS.Remove(ctx, dstPath)
}

func (d *rootFS) MakeDir(ctx context.Context, path string) error {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return err
	}
	return dstFS.MakeDir(ctx, dstPath)
}

func NewFS(fn func(string) (FS, string, error), fileFn func(string, cloudfs.FileInfo) cloudfs.FileInfo) FS {
	fs := &rootFS{}
	if fileFn == nil {
		fileFn = func(root string, file cloudfs.FileInfo) cloudfs.FileInfo {
			return NewFile(filepath.Join(root, file.Path()), file)
		}
	}
	fs.fn = fn
	fs.fileFn = fileFn
	return fs
}

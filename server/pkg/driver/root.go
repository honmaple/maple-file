package driver

import (
	"context"
	"path/filepath"
	"strings"
)

type rootFS struct {
	Base
	fn     func(string) (FS, string, error)
	fileFn func(string, File) File
}

var _ FS = (*rootFS)(nil)

func (d *rootFS) List(ctx context.Context, path string, metas ...Meta) ([]File, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}

	files, err := dstFS.List(ctx, dstPath, metas...)
	if err != nil {
		return nil, err
	}
	root := strings.TrimSuffix(path, dstPath)
	for i, file := range files {
		files[i] = d.fileFn(root, file)
	}
	return files, nil
}

func (d *rootFS) Get(ctx context.Context, path string) (File, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}

	file, err := dstFS.Get(ctx, dstPath)
	if err != nil {
		return nil, err
	}
	file = d.fileFn(strings.TrimSuffix(path, dstPath), file)
	return file, nil
}

func (d *rootFS) Open(path string) (FileReader, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}
	return dstFS.Open(dstPath)
}

func (d *rootFS) Create(path string) (FileWriter, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}
	return dstFS.Create(dstPath)
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

func NewFS(fn func(string) (FS, string, error), fileFn func(string, File) File) FS {
	fs := &rootFS{}
	if fileFn == nil {
		fileFn = func(root string, file File) File {
			return NewFile(filepath.Join(root, file.Path()), file)
		}
	}
	fs.fn = fn
	fs.fileFn = fileFn
	return fs
}

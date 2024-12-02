package driver

import (
	"context"
	"io/fs"
	"path/filepath"
	"strings"
)

type rootFS struct {
	Base
	fn     func(string) (FS, string, error)
	fileFn func(string, File) File
}

func (d *rootFS) WalkDir(ctx context.Context, path string, fn WalkDirFunc) error {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return err
	}

	root := strings.TrimSuffix(path, dstPath)
	return dstFS.WalkDir(ctx, dstPath, func(file File, err error) error {
		if err != nil {
			return err
		}
		return fn(d.fileFn(root, file), nil)
	})
}

func (d *rootFS) List(ctx context.Context, path string) ([]File, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}

	files, err := dstFS.List(ctx, dstPath)
	if err != nil {
		return nil, err
	}
	root := strings.TrimSuffix(path, dstPath)
	for i, file := range files {
		files[i] = d.fileFn(root, file)
	}
	return files, nil
}

func (d *rootFS) Get(path string) (File, error) {
	dstFS, dstPath, err := d.fn(path)
	if err != nil {
		return nil, err
	}

	file, err := dstFS.Get(dstPath)
	if err != nil {
		return nil, err
	}
	file = d.fileFn(strings.TrimSuffix(path, dstPath), file)
	return file, nil
}

func (d *rootFS) Read(path string) (fs.File, error) {
	fi, err := d.Get(path)
	if err != nil {
		return nil, err
	}
	file, err := d.Open(path)
	if err != nil {
		return nil, err
	}
	return &fsFile{fi, file}, nil
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

func PrefixFS(fs FS, prefix string) FS {
	if prefix == "" {
		return fs
	}
	prefix = strings.TrimRight(prefix, "/")
	return NewFS(
		func(path string) (FS, string, error) {
			return fs, filepath.Join(prefix, path), nil
		},
		func(root string, file File) File {
			return NewFile(strings.TrimPrefix(file.Path(), prefix), file)
		},
	)
}

package driver

import (
	"context"

	"github.com/honmaple/cloudfs"
)

type (
	WalkDirFunc func(string, File, error) error
)

func CopyFile(ctx context.Context, srcFS FS, src, dst string) error {
	return cloudfs.CopyFile(ctx, unwrapFS(srcFS), src, dst)
}

func CopyDir(ctx context.Context, srcFS FS, src, dst string) error {
	return cloudfs.CopyDir(ctx, unwrapFS(srcFS), src, dst)
}

func Copy(ctx context.Context, srcFS FS, src, dst string, metas ...Meta) error {
	return cloudfs.Copy(ctx, unwrapFS(srcFS), src, dst, newMeta(metas...).mapValue())
}

func WalkDir(ctx context.Context, srcFS FS, root string, walkDirFn WalkDirFunc) error {
	return cloudfs.WalkDir(ctx, unwrapFS(srcFS), root, func(path string, info cloudfs.FileInfo, err error) error {
		if info == nil {
			return walkDirFn(path, nil, err)
		}
		return walkDirFn(path, info, err)
	})
}

func unwrapFS(srcFS FS) cloudfs.FS {
	if fs, ok := srcFS.(*cloudFS); ok {
		return fs.raw
	}

	return &fsAdapter{FS: srcFS}
}

func AsCloudFS(srcFS FS) cloudfs.FS {
	return unwrapFS(srcFS)
}

func AsDriverFS(srcFS cloudfs.FS) FS {
	return wrapCloudFS(srcFS)
}

type fsAdapter struct {
	FS
}

func (d *fsAdapter) List(ctx context.Context, path string, _ ...cloudfs.ListOption) ([]cloudfs.FileInfo, error) {
	files, err := d.FS.List(ctx, path)
	if err != nil {
		return nil, err
	}
	results := make([]cloudfs.FileInfo, len(files))
	for i, file := range files {
		results[i] = file
	}
	return results, nil
}

func (d *fsAdapter) Stat(ctx context.Context, path string) (cloudfs.FileInfo, error) {
	return d.FS.Get(ctx, path)
}

func (d *fsAdapter) Open(ctx context.Context, path string) (cloudfs.File, error) {
	return d.FS.Open(path)
}

func (d *fsAdapter) Create(ctx context.Context, path string) (cloudfs.FileWriter, error) {
	return d.FS.Create(path)
}

func (d *fsAdapter) Rename(ctx context.Context, path, newName string) error {
	return d.FS.Rename(ctx, path, newName)
}

func (d *fsAdapter) Move(ctx context.Context, src, dst string) error {
	return d.FS.Move(ctx, src, dst)
}

func (d *fsAdapter) Copy(ctx context.Context, src, dst string) error {
	return d.FS.Copy(ctx, src, dst)
}

func (d *fsAdapter) Remove(ctx context.Context, path string) error {
	return d.FS.Remove(ctx, path)
}

func (d *fsAdapter) MakeDir(ctx context.Context, path string) error {
	return d.FS.MakeDir(ctx, path)
}

func (d *fsAdapter) Close() error {
	return d.FS.Close()
}

var _ cloudfs.FS = (*fsAdapter)(nil)

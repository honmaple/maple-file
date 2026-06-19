package driver

import (
	"context"

	"github.com/honmaple/cloudfs"
)

type (
	WalkDirFunc func(string, cloudfs.FileInfo, error) error
)

func CopyFile(ctx context.Context, srcFS FS, src, dst string) error {
	return cloudfs.CopyFile(ctx, srcFS, src, dst)
}

func CopyDir(ctx context.Context, srcFS FS, src, dst string) error {
	return cloudfs.CopyDir(ctx, srcFS, src, dst)
}

func Copy(ctx context.Context, srcFS FS, src, dst string, opts ...Meta) error {
	return cloudfs.Copy(ctx, srcFS, src, dst, cloudfs.ListOptions(opts...).AllSettings())
}

func WalkDir(ctx context.Context, srcFS FS, root string, walkDirFn WalkDirFunc) error {
	return cloudfs.WalkDir(ctx, srcFS, root, func(path string, info cloudfs.FileInfo, err error) error {
		if info == nil {
			return walkDirFn(path, nil, err)
		}
		return walkDirFn(path, info, err)
	})
}

package driver

import (
	"context"
	"errors"
	"io/fs"
	"path/filepath"

	"github.com/honmaple/maple-file/server/pkg/util"
)

type (
	WalkDirFunc func(string, File, error) error
)

func CopyFile(ctx context.Context, srcFS FS, src, dst string) error {
	srcFile, err := srcFS.Open(src)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	dstFile, err := srcFS.Create(dst)
	if err != nil {
		return err
	}

	if _, err := util.CopyWithContext(ctx, dstFile, srcFile); err != nil {
		dstFile.Close()
		return err
	}
	return dstFile.Close()
}

func CopyDir(ctx context.Context, srcFS FS, src, dst string) error {
	if err := srcFS.MakeDir(ctx, dst); err != nil {
		return err
	}

	files, err := srcFS.List(ctx, src)
	if err != nil {
		return err
	}

	for _, file := range files {
		srcPath := filepath.Join(src, file.Name())
		dstPath := filepath.Join(dst, file.Name())

		if file.IsDir() {
			err = CopyDir(ctx, srcFS, srcPath, dstPath)
		} else {
			err = CopyFile(ctx, srcFS, srcPath, dstPath)
		}
		if err != nil {
			return err
		}
	}
	return nil
}

func Copy(ctx context.Context, srcFS FS, src, dst string, metas ...Meta) error {
	meta := NewMeta(metas...)

	dstFile, err := srcFS.Get(ctx, dst)
	if err != nil {
		// 复制并重命名
		if !meta.GetBool("auto_rename") {
			return err
		}
		_, err = srcFS.Get(ctx, filepath.Dir(dst))
		if err != nil {
			return err
		}
	} else if !dstFile.IsDir() {
		return &fs.PathError{Op: "copy", Path: dst, Err: errors.New("copy dst must be a dir")}
	} else {
		dst = filepath.Join(dst, filepath.Base(src))
	}

	srcFile, err := srcFS.Get(ctx, src)
	if err != nil {
		return err
	}
	if srcFile.IsDir() {
		return CopyDir(ctx, srcFS, src, dst)
	}
	return CopyFile(ctx, srcFS, src, dst)
}

func walkDir(ctx context.Context, srcFS FS, root string, d File, walkDirFn WalkDirFunc) error {
	if err := walkDirFn(root, d, nil); err != nil || !d.IsDir() {
		if err == fs.SkipDir && d.IsDir() {
			err = nil
		}
		return err
	}

	files, err := srcFS.List(ctx, filepath.Join(d.Path(), d.Name()))
	if err != nil {
		err = walkDirFn(root, d, err)
		if err != nil {
			if err == fs.SkipDir && d.IsDir() {
				err = nil
			}
			return err
		}
		return err
	}
	for _, file := range files {
		name := filepath.Join(root, file.Name())
		if err := walkDir(ctx, srcFS, name, file, walkDirFn); err != nil {
			if err == fs.SkipDir {
				break
			}
			return err
		}
	}
	return nil
}

func WalkDir(ctx context.Context, srcFS FS, root string, walkDirFn WalkDirFunc) error {
	info, err := srcFS.Get(ctx, root)
	if err != nil {
		err = walkDirFn(root, nil, err)
	} else {
		err = walkDir(ctx, srcFS, root, info, walkDirFn)
	}
	if err == fs.SkipDir || err == fs.SkipAll {
		return nil
	}
	return err
}

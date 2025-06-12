package quark

import (
	"context"
	"time"

	filepath "path"

	"github.com/hashicorp/golang-lru/v2/expirable"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/spf13/viper"
)

type wrapFS struct {
	driver.FS
	cache *expirable.LRU[string, driver.File]
}

var _ driver.FS = (*wrapFS)(nil)

func (d *wrapFS) getActualPath(ctx context.Context, path string) (string, error) {
	if path == "/" {
		return "0", nil
	}

	file, err := d.Get(ctx, path)
	if err != nil {
		return "", err
	}
	cf := viper.New()
	for k, v := range file.ExtraInfo() {
		cf.Set(k, v)
	}
	return cf.GetString("id"), nil
}

func (d *wrapFS) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	actualPath, err := d.getActualPath(ctx, path)
	if err != nil {
		return nil, err
	}
	files, err := d.FS.List(ctx, actualPath, metas...)
	if err != nil {
		return nil, err
	}

	newFiles := make([]driver.File, len(files))
	for i, file := range files {
		newFiles[i] = driver.NewFile(path, file, func(info *driver.FileInfo) {
			info.ExtraInfo = file.ExtraInfo()
		})
	}
	return newFiles, nil
}

func (d *wrapFS) Rename(ctx context.Context, path, newName string) error {
	actualPath, err := d.getActualPath(ctx, path)
	if err != nil {
		return err
	}
	return d.FS.Rename(ctx, actualPath, newName)
}

func (d *wrapFS) Move(ctx context.Context, src, dst string) error {
	actualSrcPath, err := d.getActualPath(ctx, src)
	if err != nil {
		return err
	}
	actualDstPath, err := d.getActualPath(ctx, dst)
	if err != nil {
		return err
	}
	return d.FS.Move(ctx, actualSrcPath, actualDstPath)
}

func (d *wrapFS) Copy(ctx context.Context, src, dst string) error {
	actualSrcPath, err := d.getActualPath(ctx, src)
	if err != nil {
		return err
	}
	actualDstPath, err := d.getActualPath(ctx, src)
	if err != nil {
		return err
	}
	return d.FS.Copy(ctx, actualSrcPath, actualDstPath)
}

func (d *wrapFS) MakeDir(ctx context.Context, path string) error {
	actualPath, err := d.getActualPath(ctx, filepath.Dir(path))
	if err != nil {
		return err
	}
	return d.FS.MakeDir(ctx, filepath.Join(actualPath, filepath.Base(path)))
}

func (d *wrapFS) Remove(ctx context.Context, path string) error {
	actualPath, err := d.getActualPath(ctx, path)
	if err != nil {
		return err
	}
	return d.FS.Remove(ctx, actualPath)
}

func (d *wrapFS) Open(path string) (driver.FileReader, error) {
	actualPath, err := d.getActualPath(context.TODO(), path)
	if err != nil {
		return nil, err
	}
	return d.FS.Open(actualPath)
}

// func (d *wrapFS) Create(path string) (driver.FileWriter, error) {
//	actualPath, err := d.getActualPath(context.TODO(), path)
//	if err != nil {
//		return nil, err
//	}
//	return d.FS.Create(actualPath)
// }

func (d *wrapFS) Get(ctx context.Context, path string) (driver.File, error) {
	// /aaa/bbb/ccc/ddd
	if path == "/" {
		return nil, driver.ErrNotSupport
	}

	if file, ok := d.cache.Get(path); ok {
		return file, nil
	}

	dir, name := filepath.Split(path)

	files, err := d.List(ctx, filepath.Clean(dir))
	if err != nil {
		return nil, err
	}
	for _, file := range files {
		if file.Name() == name {
			d.cache.Add(path, file)
			return file, nil
		}
	}
	return nil, driver.ErrDstNotExist
}

func WrapFS(fs driver.FS, expireTime time.Duration) driver.FS {
	if expireTime <= 0 {
		expireTime = 60
	}
	return &wrapFS{
		FS:    fs,
		cache: expirable.NewLRU[string, driver.File](0, nil, expireTime*time.Second),
	}
}

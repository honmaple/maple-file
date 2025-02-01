package base

import (
	"context"
	"time"

	"github.com/hashicorp/golang-lru/v2/expirable"
	"github.com/honmaple/maple-file/server/pkg/driver"
)

type CacheOption struct {
	ExpireTime time.Duration `json:"expire_time"`
}

func (opt *CacheOption) NewFS(fs driver.FS) (driver.FS, error) {
	return CacheFS(fs, opt)
}

type cacheFS struct {
	driver.FS
	opt   *CacheOption
	cache *expirable.LRU[string, []driver.File]
}

var _ driver.FS = (*cacheFS)(nil)

func (d *cacheFS) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	files, ok := d.cache.Get(path)
	if ok {
		return files, nil
	}

	files, err := d.FS.List(ctx, path, metas...)
	if err != nil {
		return nil, err
	}

	d.cache.Add(path, files)
	return files, nil
}

func CacheFS(fs driver.FS, opt *CacheOption) (driver.FS, error) {
	if opt.ExpireTime <= 0 {
		opt.ExpireTime = 60
	}

	return &cacheFS{
		FS:    fs,
		opt:   opt,
		cache: expirable.NewLRU[string, []driver.File](0, nil, opt.ExpireTime*time.Second),
	}, nil
}

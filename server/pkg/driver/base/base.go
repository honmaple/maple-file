package base

import (
	filepath "path"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type Option struct {
	RootPath        string          `json:"root_path"   validate:"omitempty,startswith=/"`
	HiddenFiles     []string        `json:"hidden_files"`
	Encrypt         bool            `json:"encrypt"`
	EncryptOption   EncryptOption   `json:"encrypt_option"`
	Compress        bool            `json:"compress"`
	CompressOption  CompressOption  `json:"compress_option"`
	Recycle         bool            `json:"recycle"`
	RecycleOption   RecycleOption   `json:"recycle_option"`
	Cache           bool            `json:"cache"`
	CacheOption     CacheOption     `json:"cache_option"`
	RateLimit       bool            `json:"rate_limit"`
	RateLimitOption RateLimitOption `json:"rate_limit_option"`
}

func (opt *Option) getActualPath(path string) string {
	path = util.CleanPath(path)
	if opt.RootPath == "" {
		return path
	}
	return filepath.Join(opt.RootPath, path)
}

func (opt *Option) getActualFile(file driver.File) (driver.File, bool) {
	if opt.RootPath != "" {
		file = driver.NewFile(strings.TrimPrefix(file.Path(), opt.RootPath), file)
	}
	if len(opt.HiddenFiles) > 0 && Included(file, opt.HiddenFiles) {
		return file, false
	}
	return file, true
}

func (opt *Option) NewFS(fs driver.FS) (driver.FS, error) {
	return New(fs, opt)
}

func New(fs driver.FS, opt *Option) (driver.FS, error) {
	opts := make([]WrapOption, 0)
	if opt.Encrypt {
		opts = append(opts, &opt.EncryptOption)
	}
	if opt.Compress {
		opts = append(opts, &opt.CompressOption)
	}
	if opt.Recycle {
		opts = append(opts, &opt.RecycleOption)
	}
	if opt.RateLimit {
		opts = append(opts, &opt.RateLimitOption)
	}
	if opt.Cache {
		opts = append(opts, &opt.CacheOption)
	}
	opts = append(opts, &HookOption{
		PathFn: opt.getActualPath,
		FileFn: opt.getActualFile,
	})
	return WrapFS(fs, opts...)
}

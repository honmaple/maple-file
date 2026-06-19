package driver

import (
	"context"
	"encoding/json"
	"fmt"
	"io/fs"
	filepath "path"
	"strings"
	"time"

	"github.com/honmaple/cloudfs"
	cloudmiddleware "github.com/honmaple/cloudfs/middleware"
	"github.com/honmaple/maple-file/server/pkg/util"
)

const recycleName = ".maplerecycle"

type CommonOption struct {
	RootPath        string                          `json:"root_path" validate:"omitempty,startswith=/"`
	HiddenFiles     []string                        `json:"hidden_files"`
	Encrypt         bool                            `json:"encrypt"`
	EncryptOption   cloudmiddleware.EncryptOption   `json:"encrypt_option"`
	Compress        bool                            `json:"compress"`
	CompressOption  cloudmiddleware.CompressOption  `json:"compress_option"`
	Recycle         bool                            `json:"recycle"`
	RecycleOption   recycleOption                   `json:"recycle_option"`
	Cache           bool                            `json:"cache"`
	CacheOption     cloudmiddleware.CacheOption     `json:"cache_option"`
	RateLimit       bool                            `json:"rate_limit"`
	RateLimitOption cloudmiddleware.RateLimitOption `json:"rate_limit_option"`
}

type recycleOption struct {
	Path string `json:"path" validate:"omitempty,startswith=/"`
}

func verifyWrapOptionJSON(option string) error {
	var opt CommonOption
	if err := json.Unmarshal([]byte(option), &opt); err != nil {
		return err
	}
	return VerifyOption(&opt)
}

func wrapFuncsFromJSON(option string) ([]cloudfs.WrapFunc, error) {
	var opt CommonOption
	if option == "" {
		return NewCommonWraps(&opt)
	}
	if err := json.Unmarshal([]byte(option), &opt); err != nil {
		return nil, err
	}
	return NewCommonWraps(&opt)
}

func NewCommonWraps(opt *CommonOption) ([]cloudfs.WrapFunc, error) {
	if err := VerifyOption(opt); err != nil {
		return nil, err
	}

	wraps := make([]cloudfs.WrapFunc, 0)
	if opt.Encrypt {
		wraps = append(wraps, cloudmiddleware.EncryptFS(&opt.EncryptOption))
	}
	if opt.Compress {
		wraps = append(wraps, cloudmiddleware.CompressFS(&opt.CompressOption))
	}
	if opt.Recycle {
		wraps = append(wraps, recycleWrap(&opt.RecycleOption))
	}
	if opt.RateLimit {
		wraps = append(wraps, cloudmiddleware.RateLimitFS(&opt.RateLimitOption))
	}
	if opt.Cache {
		wraps = append(wraps, cloudmiddleware.CacheFS(&opt.CacheOption))
	}

	if opt.RootPath != "" || len(opt.HiddenFiles) > 0 {
		wraps = append(wraps, cloudmiddleware.HookFS(&cloudmiddleware.HookOption{
			PathFn: func(path string) string {
				path = util.CleanPath(path)
				if opt.RootPath == "" {
					return path
				}
				return filepath.Join(opt.RootPath, path)
			},
			FileFn: func(file cloudfs.FileInfo) (cloudfs.FileInfo, bool) {
				if opt.RootPath != "" {
					file = cloudfs.NewFileInfo(file, func(info *cloudfs.Entry) {
						info.Path = strings.TrimPrefix(file.Path(), opt.RootPath)
					})
				}
				if len(opt.HiddenFiles) > 0 && included(file, opt.HiddenFiles) {
					return file, false
				}
				return file, true
			},
		}))
	}

	return wraps, nil
}

func included(file cloudfs.FileInfo, types []string) bool {
	if len(types) == 0 {
		return false
	}
	ext := filepath.Ext(file.Name())
	for _, typ := range types {
		exclude := false
		if strings.HasPrefix(typ, "-") {
			typ = typ[1:]
			exclude = true
		}
		if ext == typ {
			return !exclude
		}

		name := file.Name()
		if strings.Contains(typ, "/") {
			name = strings.TrimPrefix(filepath.Join(file.Path(), name), "/")
		}
		if m, _ := filepath.Match(typ, name); m {
			return !exclude
		}
	}
	return false
}

func recycleWrap(opt *recycleOption) cloudfs.WrapFunc {
	return func(fs cloudfs.FS) (cloudfs.FS, error) {
		if opt.Path == "" {
			opt.Path = "/" + recycleName
		}
		return &recycleFS{FS: fs, opt: opt}, nil
	}
}

type recycleFS struct {
	cloudfs.FS
	opt *recycleOption
}

func (d *recycleFS) List(ctx context.Context, path string, opts ...cloudfs.ListOption) ([]cloudfs.FileInfo, error) {
	if path == d.opt.Path {
		_, err := d.FS.Stat(ctx, path)
		if err != nil {
			err = d.FS.MakeDir(ctx, path)
		}
		if err != nil {
			return nil, err
		}
	}
	files, err := d.FS.List(ctx, path, opts...)
	if err != nil {
		return nil, err
	}

	if path == filepath.Dir(d.opt.Path) {
		exists := false
		for i, file := range files {
			if file.IsDir() && file.Name() == filepath.Base(d.opt.Path) {
				files[i] = cloudfs.NewFileInfo(file, func(info *cloudfs.Entry) {
					info.Type = "RECYCLE"
				})
				exists = true
				break
			}
		}
		if !exists {
			files = append(files, NewDir(path, filepath.Base(d.opt.Path), func(entry *cloudfs.Entry) {
				entry.Type = "RECYCLE"
				entry.Mode = fs.ModeDir
			}))
		}
	}
	return files, nil
}

func (d *recycleFS) Remove(ctx context.Context, path string) error {
	if util.IsSubPath(d.opt.Path, path) {
		return d.FS.Remove(ctx, path)
	}
	newName := fmt.Sprintf("%s.%s", filepath.Base(path), time.Now().Format("20060102150405"))
	if err := d.FS.Rename(ctx, path, newName); err != nil {
		return err
	}
	return d.FS.Move(ctx, filepath.Join(filepath.Dir(path), newName), d.opt.Path)
}

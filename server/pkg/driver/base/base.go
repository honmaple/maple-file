package base

import (
	"context"
	"path/filepath"

	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
)

type Option struct {
	RootPath       string         `json:"root_path" validate:"omitempty,startswith=/"`
	HiddenFiles    []string       `json:"hidden_files"`
	Encrypt        bool           `json:"encrypt"`
	EncryptOption  EncryptOption  `json:"encrypt_option"`
	Compress       bool           `json:"compress"`
	CompressOption CompressOption `json:"compress_option"`
}

func (opt *Option) NewFS(fs driver.FS) (driver.FS, error) {
	return New(fs, opt)
}

type baseFS struct {
	driver.FS
	opt        *Option
	encryptFS  driver.FS
	compressFS driver.FS
}

var _ driver.FS = (*baseFS)(nil)

func (d *baseFS) getActualPath(path string) string {
	if d.opt.RootPath == "" {
		return path
	}
	return filepath.Join(strings.TrimRight(d.opt.RootPath, "/"), path)
}

func (d *baseFS) getActualFile(file driver.File) driver.File {
	if d.opt.RootPath == "" {
		return file
	}
	return driver.NewFile(strings.TrimPrefix(file.Path(), strings.TrimRight(d.opt.RootPath, "/")), file)
}

func (d *baseFS) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	path = d.getActualPath(path)

	var (
		err   error
		files []driver.File
	)
	if d.opt.Encrypt {
		files, err = d.encryptFS.List(ctx, path, metas...)
	} else {
		files, err = d.FS.List(ctx, path, metas...)
	}
	if err != nil {
		return nil, err
	}

	if len(d.opt.HiddenFiles) == 0 && d.opt.RootPath == "" {
		return files, nil
	}

	newFiles := make([]driver.File, 0, len(files))
	for _, file := range files {
		file = d.getActualFile(file)
		if len(d.opt.HiddenFiles) > 0 && Included(file, d.opt.HiddenFiles) {
			continue
		}
		newFiles = append(newFiles, file)
	}
	return newFiles, nil
}

func (d *baseFS) Get(ctx context.Context, path string) (driver.File, error) {
	path = d.getActualPath(path)

	var (
		err  error
		file driver.File
	)
	if d.opt.Encrypt {
		file, err = d.encryptFS.Get(ctx, path)
	} else {
		file, err = d.FS.Get(ctx, path)
	}

	if err != nil {
		return nil, err
	}
	return d.getActualFile(file), nil
}

func (d *baseFS) Open(path string) (driver.FileReader, error) {
	path = d.getActualPath(path)

	if d.opt.Encrypt && d.opt.Compress {
		r, err := d.encryptFS.Open(path)
		if err != nil {
			return nil, err
		}

		nr, err := d.compressFS.(*compressFS).uncompress(r)
		if err != nil {
			return nil, err
		}
		return &WrapReader{r, nr}, nil
	}

	if d.opt.Encrypt {
		return d.encryptFS.Open(path)
	}

	if d.opt.Compress {
		return d.compressFS.Open(path)
	}
	return d.FS.Open(path)
}

func (d *baseFS) Create(path string) (driver.FileWriter, error) {
	path = d.getActualPath(path)

	if d.opt.Encrypt && d.opt.Compress {
		w, err := d.encryptFS.Create(path)
		if err != nil {
			return nil, err
		}
		nw, err := d.compressFS.(*compressFS).compress(w)
		if err != nil {
			return nil, err
		}
		return &WrapWriter{w, nw}, nil
	}

	if d.opt.Encrypt {
		return d.encryptFS.Create(path)
	}

	if d.opt.Compress {
		return d.compressFS.Create(path)
	}

	return d.FS.Create(path)
}

func (d *baseFS) Copy(ctx context.Context, src string, dst string) error {
	src = d.getActualPath(src)
	dst = d.getActualPath(dst)
	if d.opt.Encrypt {
		return d.encryptFS.Copy(ctx, src, dst)
	}
	return d.FS.Copy(ctx, src, dst)
}

func (d *baseFS) Move(ctx context.Context, src string, dst string) error {
	src = d.getActualPath(src)
	dst = d.getActualPath(dst)
	if d.opt.Encrypt {
		return d.encryptFS.Move(ctx, src, dst)
	}
	return d.FS.Move(ctx, src, dst)
}

func (d *baseFS) Rename(ctx context.Context, path, newName string) error {
	path = d.getActualPath(path)
	if d.opt.Encrypt {
		return d.encryptFS.Rename(ctx, path, newName)
	}
	return d.FS.Rename(ctx, path, newName)
}

func (d *baseFS) Remove(ctx context.Context, path string) error {
	path = d.getActualPath(path)
	if d.opt.Encrypt {
		return d.encryptFS.Remove(ctx, path)
	}
	return d.FS.Remove(ctx, path)
}

func (d *baseFS) MakeDir(ctx context.Context, path string) error {
	path = d.getActualPath(path)
	if d.opt.Encrypt {
		return d.encryptFS.MakeDir(ctx, path)
	}
	return d.FS.MakeDir(ctx, path)
}

func New(fs driver.FS, opt *Option) (driver.FS, error) {
	d := &baseFS{
		FS:  fs,
		opt: opt,
	}
	if opt.Encrypt {
		encryptFS, err := NewEncryptFS(fs, &opt.EncryptOption)
		if err != nil {
			return nil, err
		}
		d.encryptFS = encryptFS
	}
	if opt.Compress {
		compressFS, err := NewCompressFS(fs, &opt.CompressOption)
		if err != nil {
			return nil, err
		}
		d.compressFS = compressFS
	}
	return d, nil
}

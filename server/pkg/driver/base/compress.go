package base

import (
	"compress/gzip"
	"io"

	"github.com/honmaple/maple-file/server/pkg/driver"
)

type CompressOption struct {
	Level int `json:"level"`
}

func (opt *CompressOption) NewFS(fs driver.FS) (driver.FS, error) {
	return CompressFS(fs, opt)
}

type compressFS struct {
	driver.FS
	opt *CompressOption
}

var _ driver.FS = (*compressFS)(nil)

func (d *compressFS) compress(out io.Writer) (*gzip.Writer, error) {
	level := d.opt.Level
	if level == 0 {
		level = gzip.BestCompression
	}
	return gzip.NewWriterLevel(out, level)
}

func (d *compressFS) uncompress(in io.Reader) (*gzip.Reader, error) {
	return gzip.NewReader(in)
}

func (d *compressFS) Open(path string) (driver.FileReader, error) {
	r, err := d.FS.Open(path)
	if err != nil {
		return nil, err
	}

	nr, err := d.uncompress(r)
	if err != nil {
		return nil, err
	}
	return &WrapReader{r, nr}, nil
}

func (d *compressFS) Create(path string) (driver.FileWriter, error) {
	w, err := d.FS.Create(path)
	if err != nil {
		return nil, err
	}
	nw, err := d.compress(w)
	if err != nil {
		return nil, err
	}
	return &WrapWriter{w, nw}, nil
}

func CompressFS(fs driver.FS, opt *CompressOption) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}
	return &compressFS{FS: fs, opt: opt}, nil
}

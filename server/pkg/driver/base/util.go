package base

import (
	"io"
	"mime"
	"path/filepath"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
)

type WrapFile struct {
	driver.File
	name string
}

func (f *WrapFile) Name() string { return f.name }
func (f *WrapFile) Type() string {
	if f.IsDir() {
		return "DIR"
	}
	return mime.TypeByExtension(filepath.Ext(f.name))
}

type WrapReader struct {
	driver.FileReader
	r io.Reader
}

func (r *WrapReader) Read(p []byte) (n int, err error) { return r.r.Read(p) }

type WrapWriter struct {
	driver.FileWriter
	w io.WriteCloser
}

func (w *WrapWriter) Write(p []byte) (n int, err error) { return w.w.Write(p) }
func (w *WrapWriter) Close() error {
	w.FileWriter.Close()
	w.w.Close()
	return nil
}

func Included(file driver.File, types []string) bool {
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

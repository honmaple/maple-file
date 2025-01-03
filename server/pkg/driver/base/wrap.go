package base

import (
	"io"

	"github.com/honmaple/maple-file/server/pkg/driver"
)

type WrapOption interface {
	NewFS(driver.FS) (driver.FS, error)
}

func WrapFS(fs driver.FS, opts ...WrapOption) (newFS driver.FS, err error) {
	newFS = fs
	for _, opt := range opts {
		newFS, err = opt.NewFS(newFS)
		if err != nil {
			return nil, err
		}
	}
	return
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

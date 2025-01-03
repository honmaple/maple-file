package util

import (
	"context"
	"fmt"
	"io"
	"math"
	"sync"
)

type readerFunc func(p []byte) (n int, err error)

func (rf readerFunc) Read(p []byte) (n int, err error) { return rf(p) }

func Copy(ctx context.Context, dst io.Writer, src io.Reader, progress func(int64)) (int64, error) {
	var written int

	return io.Copy(dst, readerFunc(func(p []byte) (int, error) {
		select {
		case <-ctx.Done():
			return 0, ctx.Err()
		default:
			n, err := src.Read(p)
			if progress != nil {
				written += n
				progress(int64(written))
			}
			return n, err
		}
	}))
}

func CopyN(ctx context.Context, dst io.Writer, src io.Reader, n int64, progress func(int64)) (int64, error) {
	return Copy(ctx, dst, io.LimitReader(src, n), progress)
}

func CopyWithContext(ctx context.Context, dst io.Writer, src io.Reader) (int64, error) {
	return Copy(ctx, dst, src, nil)
}

func CopyNWithContext(ctx context.Context, dst io.Writer, src io.Reader, n int64) (int64, error) {
	return CopyN(ctx, dst, src, n, nil)
}

func PrettyByteSize(b int) string {
	bf := float64(b)
	for _, unit := range []string{"", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei", "Zi"} {
		if math.Abs(bf) < 1024.0 {
			return fmt.Sprintf("%3.1f%sB", bf, unit)
		}
		bf /= 1024.0
	}
	return fmt.Sprintf("%.1fYiB", bf)
}

func Pipe() (*reader, *writer) {
	r, w := io.Pipe()

	wg := &sync.WaitGroup{}
	wg.Add(2)

	return &reader{PipeReader: r, wg: wg}, &writer{PipeWriter: w, wg: wg}
}

type writer struct {
	*io.PipeWriter
	wg   *sync.WaitGroup
	once sync.Once
}

func (w *writer) done() {
	w.wg.Done()
	w.wg.Wait()
}

func (w *writer) Close() error {
	err := w.PipeWriter.Close()
	w.once.Do(w.done)
	return err
}

func (w *writer) CloseWithError(err error) error {
	err = w.PipeWriter.CloseWithError(err)
	w.once.Do(w.done)
	return err
}

type reader struct {
	*io.PipeReader
	wg   *sync.WaitGroup
	once sync.Once
}

func (r *reader) done() {
	r.wg.Done()
	r.wg.Wait()
}

func (r *reader) Close() error {
	err := r.PipeReader.Close()
	r.once.Do(r.done)
	return err
}

func (r *reader) CloseWithError(err error) error {
	err = r.PipeReader.CloseWithError(err)
	r.once.Do(r.done)
	return err
}

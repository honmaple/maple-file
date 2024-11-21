package util

import (
	"context"
	"fmt"
	"io"
	"math"
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

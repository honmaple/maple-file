package aes

import (
	"crypto/cipher"
	"io"
)

type StreamReader struct {
	S cipher.Stream
	R io.Reader
}

func (r StreamReader) Read(dst []byte) (n int, err error) {
	n, err = r.R.Read(dst)
	r.S.XORKeyStream(dst[:n], dst[:n])
	return
}

func (r StreamReader) Close() error {
	closer, ok := r.R.(io.Closer)
	if ok {
		return closer.Close()
	}
	return nil
}

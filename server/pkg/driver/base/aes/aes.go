package aes

import (
	"crypto/aes"
	"crypto/cipher"
	"io"
)

type BlockMode string

const (
	CTR BlockMode = "CTR"
	CFB BlockMode = "CFB"
	OFB BlockMode = "OFB"
)

type Cipher struct {
	iv      []byte
	mode    BlockMode
	block   cipher.Block
	padding PaddingMode
}

func (c *Cipher) SetIV(iv []byte) {
	c.iv = iv
}

func (c *Cipher) SetPadding(padding PaddingMode) {
	c.padding = padding
}

func (c *Cipher) encryptStream() cipher.Stream {
	var stream cipher.Stream
	switch c.mode {
	case CTR:
		stream = cipher.NewCTR(c.block, c.iv[:])
	case OFB:
		stream = cipher.NewOFB(c.block, c.iv[:])
	default:
		stream = cipher.NewCFBEncrypter(c.block, c.iv[:])
	}
	return stream
}

func (c *Cipher) Encrypt(src []byte) []byte {
	switch c.padding {
	case PKCS5:
		src = pkcs7Padding(src, 8)
	case PKCS7:
		src = pkcs7Padding(src, 16)
	}

	dst := make([]byte, len(src))
	stream := c.encryptStream()
	stream.XORKeyStream(dst, src)
	return dst
}

func (c *Cipher) StreamEncrypt(w io.Writer) io.WriteCloser {
	return &cipher.StreamWriter{S: c.encryptStream(), W: w}
}

func (c *Cipher) decryptStream() cipher.Stream {
	var stream cipher.Stream
	switch c.mode {
	case CTR:
		stream = cipher.NewCTR(c.block, c.iv[:])
	case OFB:
		stream = cipher.NewOFB(c.block, c.iv[:])
	default:
		stream = cipher.NewCFBDecrypter(c.block, c.iv[:])
	}
	return stream
}

func (c *Cipher) Decrypt(src []byte) []byte {
	dst := make([]byte, len(src))
	stream := c.decryptStream()
	stream.XORKeyStream(dst, src)

	switch c.padding {
	case PKCS5:
		dst = pkcs7UnPadding(dst)
	case PKCS7:
		dst = pkcs7UnPadding(dst)
	}
	return dst
}

func (c *Cipher) StreamDecrypt(r io.Reader) io.ReadCloser {
	return &StreamReader{S: c.decryptStream(), R: r}
}

func NewCipher(mode BlockMode, key []byte) (*Cipher, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}
	return &Cipher{block: block, mode: mode, padding: PKCS7}, nil
}
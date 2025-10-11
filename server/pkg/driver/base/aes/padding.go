package aes

import (
	"bytes"
)

type PaddingMode string

const (
	PKCS5 PaddingMode = "PKCS5"
	PKCS7 PaddingMode = "PKCS7"
)

func pkcs7Padding(src []byte, blockSize int) []byte {
	paddingSize := blockSize - len(src)%blockSize
	paddingText := bytes.Repeat([]byte{byte(paddingSize)}, paddingSize)
	return append(src, paddingText...)
}

func pkcs7UnPadding(src []byte) []byte {
	if len(src) == 0 {
		return nil
	}

	paddingSize := int(src[len(src)-1])
	if paddingSize > len(src) || paddingSize == 0 {
		return src
	}
	return src[:len(src)-paddingSize]
}

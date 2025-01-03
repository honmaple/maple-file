package base

import (
	"bytes"
	"context"
	"crypto/aes"
	"crypto/cipher"
	"crypto/md5"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	"path/filepath"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
)

type EncryptOption struct {
	DirName      bool   `json:"dir_name"`
	FileName     bool   `json:"file_name"`
	Suffix       string `json:"suffix"`
	Password     string `json:"password"`
	PasswordSalt string `json:"password_salt"`
}

func (opt *EncryptOption) NewFS(fs driver.FS) (driver.FS, error) {
	return EncryptFS(fs, opt)
}

type encryptFS struct {
	driver.FS
	opt   *EncryptOption
	iv    []byte
	block cipher.Block
}

var _ driver.FS = (*encryptFS)(nil)

func deriveKey(key string) []byte {
	has := md5.Sum([]byte(key))
	return []byte(fmt.Sprintf("%x", has))
}

func pkcs5Padding(src []byte) []byte {
	return pkcs7Padding(src, 16)
}

func pkcs5UnPadding(src []byte) []byte {
	return pkcs7UnPadding(src)
}

func pkcs7Padding(src []byte, blockSize int) []byte {
	paddingSize := blockSize - len(src)%blockSize
	paddingText := bytes.Repeat([]byte{byte(paddingSize)}, paddingSize)
	return append(src, paddingText...)
}

func pkcs7UnPadding(src []byte) []byte {
	if len(src) == 0 {
		return []byte("")
	}
	n := len(src) - int(src[len(src)-1])
	return src[0:n]
}

func (d *encryptFS) decrypt(ciphertext []byte) (string, error) {
	ciphertext, err := base64.RawURLEncoding.DecodeString(string(ciphertext))
	if err != nil {
		return "", err
	}

	blockSize := d.block.BlockSize()
	if len(ciphertext) < blockSize {
		return "", errors.New("ciphertext too short")
	}

	plaintext := make([]byte, len(ciphertext))

	stream := cipher.NewCFBDecrypter(d.block, d.iv[:])
	stream.XORKeyStream(plaintext, ciphertext)

	return string(pkcs7UnPadding(plaintext)), nil
}

func (d *encryptFS) decryptPath(path string) (string, error) {
	strs := strings.Split(path, "/")

	for i, str := range strs {
		if str == "" {
			continue
		}
		plaintext, err := d.decrypt([]byte(str))
		if err != nil {
			return "", err
		}
		strs[i] = plaintext
	}
	return strings.Join(strs, "/"), nil
}

func (d *encryptFS) decryptReader(in io.Reader) (*cipher.StreamReader, error) {
	return &cipher.StreamReader{S: cipher.NewCFBDecrypter(d.block, d.iv[:]), R: in}, nil
}

func (d *encryptFS) encrypt(plaintext []byte) string {
	plaintext = pkcs7Padding(plaintext, d.block.BlockSize())

	ciphertext := make([]byte, len(plaintext))

	stream := cipher.NewCFBEncrypter(d.block, d.iv[:])
	stream.XORKeyStream(ciphertext, plaintext)

	return base64.RawURLEncoding.EncodeToString(ciphertext)
}

func (d *encryptFS) encryptPath(path string) string {
	strs := strings.Split(path, "/")

	for i, str := range strs {
		if str == "" {
			continue
		}
		strs[i] = d.encrypt([]byte(str))
	}
	return strings.Join(strs, "/")
}

func (d *encryptFS) encryptWriter(out io.Writer) (*cipher.StreamWriter, error) {
	return &cipher.StreamWriter{S: cipher.NewCFBEncrypter(d.block, d.iv[:]), W: out}, nil
}

func (d *encryptFS) getActualPath(path string, isDir bool) string {
	if isDir {
		if d.opt.DirName {
			return d.encryptPath(path)
		}
		return path
	}
	path, name := filepath.Dir(path), filepath.Base(path)
	if d.opt.DirName {
		path = d.encryptPath(path)
	}
	if d.opt.FileName {
		name = d.encrypt([]byte(name))
	} else if d.opt.Suffix != "" {
		name = name + d.opt.Suffix
	}
	return filepath.Join(path, name)
}

func (d *encryptFS) getActualFile(file driver.File) driver.File {
	path, name := file.Path(), file.Name()

	if file.IsDir() {
		if d.opt.DirName {
			if p, err := d.decryptPath(path); err == nil {
				path = p
			}
			if n, err := d.decrypt([]byte(name)); err == nil {
				name = n
			}
			return driver.NewFile(path, file, func(info *driver.FileInfo) {
				info.Name = name
			})
		}
		return file
	}

	if d.opt.DirName {
		if p, err := d.decryptPath(path); err == nil {
			path = p
		}
	}
	if d.opt.FileName {
		if n, err := d.decrypt([]byte(name)); err == nil {
			name = n
		}
	} else if d.opt.Suffix != "" {
		name = strings.TrimSuffix(name, d.opt.Suffix)
	}
	return driver.NewFile(path, file, func(info *driver.FileInfo) {
		info.Name = name
	})
}

func (d *encryptFS) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	// 加密目录名称
	actualPath := d.getActualPath(path, true)

	files, err := d.FS.List(ctx, actualPath, metas...)
	if err != nil {
		return nil, err
	}
	// 解密目录或文件名称
	for i, file := range files {
		files[i] = d.getActualFile(file)
	}
	return files, nil
}

func (d *encryptFS) Get(ctx context.Context, path string) (driver.File, error) {
	// 不知道path是文件还是目录，所以请求两次
	file, err := d.FS.Get(ctx, d.getActualPath(path, true))
	if err != nil {
		if d.opt.FileName == d.opt.DirName {
			return nil, err
		}
		file, err = d.FS.Get(ctx, d.getActualPath(path, false))
		if err != nil {
			return nil, err
		}
	}
	return d.getActualFile(file), nil
}

func (d *encryptFS) Open(path string) (driver.FileReader, error) {
	r, err := d.FS.Open(d.getActualPath(path, false))
	if err != nil {
		return nil, err
	}

	nr, err := d.decryptReader(r)
	if err != nil {
		return nil, err
	}
	return &WrapReader{r, nr}, nil
}

func (d *encryptFS) Create(path string) (driver.FileWriter, error) {
	actualPath := d.getActualPath(path, false)

	w, err := d.FS.Create(actualPath)
	if err != nil {
		return nil, err
	}
	nw, err := d.encryptWriter(w)
	if err != nil {
		return nil, err
	}
	return &WrapWriter{w, nw}, nil
}

func (d *encryptFS) Copy(ctx context.Context, src string, dst string) error {
	srcFile, err := d.Get(ctx, src)
	if err != nil {
		return err
	}
	return d.FS.Copy(ctx, d.getActualPath(src, srcFile.IsDir()), d.getActualPath(dst, true))
}

func (d *encryptFS) Move(ctx context.Context, src string, dst string) error {
	srcFile, err := d.Get(ctx, src)
	if err != nil {
		return err
	}
	return d.FS.Move(ctx, d.getActualPath(src, srcFile.IsDir()), d.getActualPath(dst, true))
}

func (d *encryptFS) Rename(ctx context.Context, path, newName string) error {
	file, err := d.Get(ctx, path)
	if err != nil {
		return err
	}
	if d.opt.FileName {
		newName = d.encrypt([]byte(newName))
	} else if d.opt.Suffix != "" {
		newName = newName + d.opt.Suffix
	}
	return d.FS.Rename(ctx, d.getActualPath(path, file.IsDir()), newName)
}

func (d *encryptFS) Remove(ctx context.Context, path string) error {
	file, err := d.Get(ctx, path)
	if err != nil {
		return err
	}

	return d.FS.Remove(ctx, d.getActualPath(path, file.IsDir()))
}

func (d *encryptFS) MakeDir(ctx context.Context, path string) error {
	return d.FS.MakeDir(ctx, d.getActualPath(path, true))
}

func EncryptFS(fs driver.FS, opt *EncryptOption) (driver.FS, error) {
	if opt.Password == "" {
		return nil, errors.New("Password is required")
	}

	block, err := aes.NewCipher(deriveKey(opt.Password))
	if err != nil {
		return nil, err
	}
	if opt.PasswordSalt == "" {
		opt.PasswordSalt = opt.Password
	}
	blockSize := block.BlockSize()
	iv := pkcs7Padding([]byte(opt.PasswordSalt), blockSize)
	if len(iv) > blockSize {
		iv = iv[:blockSize]
	}
	return &encryptFS{
		FS:    fs,
		opt:   opt,
		iv:    iv,
		block: block,
	}, nil
}

package base

import (
	"bytes"
	"context"
	"crypto/md5"
	"encoding/base64"
	"errors"
	"fmt"
	"io"
	filepath "path"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base/aes"
)

type EncryptOption struct {
	Mode         string `json:"mode"`
	DirName      bool   `json:"dir_name"`
	FileName     bool   `json:"file_name"`
	Suffix       string `json:"suffix"`
	Password     string `json:"password"`
	PasswordSalt string `json:"password_salt"`
	Version      string `json:"version"`
}

func (opt *EncryptOption) NewFS(fs driver.FS) (driver.FS, error) {
	return EncryptFS(fs, opt)
}

type encryptFS struct {
	driver.FS
	opt *EncryptOption

	cipher *aes.Cipher
}

var _ driver.FS = (*encryptFS)(nil)

func (d *encryptFS) decrypt(src string) (string, error) {
	ciphertext, err := base64.RawURLEncoding.DecodeString(string(src))
	if err != nil {
		return "", err
	}

	dst := d.cipher.Decrypt(ciphertext)
	return string(dst), nil
}

func (d *encryptFS) decryptPath(path string) (string, error) {
	strs := strings.Split(path, "/")

	for i, str := range strs {
		if str == "" {
			continue
		}
		plaintext, err := d.decrypt(str)
		if err != nil {
			return "", err
		}
		strs[i] = plaintext
	}
	return strings.Join(strs, "/"), nil
}

func (d *encryptFS) encrypt(src string) string {
	dst := d.cipher.Encrypt([]byte(src))
	return base64.RawURLEncoding.EncodeToString(dst)
}

func (d *encryptFS) encryptPath(path string) string {
	strs := strings.Split(path, "/")

	for i, str := range strs {
		if str == "" {
			continue
		}
		strs[i] = d.encrypt(str)
	}
	return strings.Join(strs, "/")
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
		name = d.encrypt(name)
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
			if n, err := d.decrypt(name); err == nil {
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
		if n, err := d.decrypt(name); err == nil {
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
	actualPath := d.getActualPath(path, false)

	info, err := d.FS.Get(context.TODO(), actualPath)
	if err != nil {
		return nil, err
	}

	rangeFunc := func(offset int64, length int64) (io.ReadCloser, error) {
		r, err := d.FS.Open(actualPath)
		if err != nil {
			return nil, err
		}

		dr := d.cipher.StreamDecrypt(r)

		// 通过丢弃内容实现偏移
		_, err = io.CopyN(io.Discard, dr, offset)
		if err != nil {
			return nil, err
		}
		return dr, nil
	}
	return driver.NewFileReader(info.Size(), rangeFunc)
}

func (d *encryptFS) Create(path string) (driver.FileWriter, error) {
	actualPath := d.getActualPath(path, false)

	w, err := d.FS.Create(actualPath)
	if err != nil {
		return nil, err
	}
	return d.cipher.StreamEncrypt(w), nil
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
		newName = d.encrypt(newName)
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

func pkcs7Padding(src []byte, blockSize int) []byte {
	paddingSize := blockSize - len(src)%blockSize
	paddingText := bytes.Repeat([]byte{byte(paddingSize)}, paddingSize)
	return append(src, paddingText...)
}

func generateIV(key string) []byte {
	iv := generateKey(key)
	if len(iv) > 16 {
		iv = iv[:16]
	}
	return iv
}

func generateIV_v1(key string) []byte {
	iv := pkcs7Padding([]byte(key), 16)
	if len(iv) > 16 {
		iv = iv[:16]
	}
	return iv
}

func generateKey(key string) []byte {
	hash := md5.Sum([]byte(key))
	return []byte(fmt.Sprintf("%x", hash))
}

func EncryptFS(fs driver.FS, opt *EncryptOption) (driver.FS, error) {
	if opt.Password == "" {
		return nil, errors.New("password is required")
	}
	if opt.PasswordSalt == "" {
		opt.PasswordSalt = opt.Password
	}

	var mode aes.BlockMode

	switch opt.Mode {
	case "CTR":
		mode = aes.CTR
	case "OFB":
		mode = aes.OFB
	default:
		mode = aes.CFB
	}

	c, err := aes.NewCipher(mode, generateKey(opt.Password))
	if err != nil {
		return nil, err
	}
	c.SetPadding(aes.PKCS7)

	// 兼容第一版的iv
	if opt.Version == "v2" {
		c.SetIV(generateIV(opt.PasswordSalt))
	} else {
		c.SetIV(generateIV_v1(opt.PasswordSalt))
	}

	return &encryptFS{
		FS:     fs,
		opt:    opt,
		cipher: c,
	}, nil
}

package sftp

import (
	"context"
	"errors"
	"fmt"
	"io"
	"path/filepath"

	"github.com/honmaple/maple-file/server/pkg/driver"

	"github.com/pkg/sftp"
	"golang.org/x/crypto/ssh"
)

type Option struct {
	Host           string `json:"host"`
	Port           int    `json:"port"`
	Username       string `json:"username"`
	Password       string `json:"password"`
	PrivateKey     string `json:"private_key"`
	PrivateKeyPath string `json:"private_key_path"`
	RootPath       string `json:"root_path"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type SFTP struct {
	driver.Base
	opt    *Option
	client *sftp.Client
}

var _ driver.FS = (*SFTP)(nil)

func (d *SFTP) Close() error {
	return d.client.Close()
}

func (d *SFTP) Get(path string) (driver.File, error) {
	info, err := d.client.Stat(path)
	if err != nil {
		return nil, err
	}
	return driver.NewFile(path, info), nil
}

func (d *SFTP) Open(path string) (driver.FileReader, error) {
	// d.client.OpenFile
	return d.client.Open(path)
}

func (d *SFTP) Create(path string) (driver.FileWriter, error) {
	return d.client.Create(path)
}

func (d *SFTP) WalkDir(ctx context.Context, root string, fn driver.WalkDirFunc) error {
	walker := d.client.Walk(root)
	for walker.Step() {
		if walker.Err() != nil {
			continue
		}
		err := fn(driver.NewFile(walker.Path(), walker.Stat()), walker.Err())
		if err == io.EOF {
			return nil
		}
		if err != nil {
			return err
		}
	}
	return nil
}

func (d *SFTP) List(ctx context.Context, path string) ([]driver.File, error) {
	fi, err := d.client.Stat(path)
	if err != nil {
		return nil, err
	}
	if fi.IsDir() {
		infos, err := d.client.ReadDir(path)
		if err != nil {
			return nil, err
		}

		files := make([]driver.File, len(infos))
		for i, info := range infos {
			files[i] = driver.NewFile(path, info)
		}
		return files, nil
	}
	return []driver.File{driver.NewFile(path, fi)}, nil
}

func (d *SFTP) Move(ctx context.Context, src, dst string) error {
	return d.client.Rename(src, dst)
}

func (d *SFTP) Copy(ctx context.Context, src, dst string) error {
	return driver.ErrNotSupport
}

func (d *SFTP) Rename(ctx context.Context, src, dst string) error {
	return d.client.Rename(src, dst)
}

func (d *SFTP) MakeDir(ctx context.Context, path string) error {
	return d.client.MkdirAll(path)
}

func (d *SFTP) removeFile(path string) error {
	return d.client.Remove(path)
}

func (d *SFTP) removeDir(path string) error {
	files, err := d.client.ReadDir(path)
	if err != nil {
		return err
	}
	for _, file := range files {
		dstPath := filepath.Join(path, file.Name())
		if file.IsDir() {
			err = d.removeDir(dstPath)
		} else {
			err = d.removeFile(dstPath)
		}

		if err != nil {
			return err
		}
	}
	return d.client.RemoveDirectory(path)
}

func (d *SFTP) Remove(ctx context.Context, path string) error {
	fi, err := d.client.Stat(path)
	if err != nil {
		return err
	}
	if fi.IsDir() {
		return d.removeDir(path)
	}
	return d.removeFile(path)
}

func New(opt *Option) (driver.FS, error) {
	config := &ssh.ClientConfig{
		User:            opt.Username,
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
	}
	if opt.Password != "" {
		config.Auth = []ssh.AuthMethod{
			ssh.Password(opt.Password),
		}
	} else if opt.PrivateKey != "" {
		signer, err := ssh.ParsePrivateKey([]byte(opt.PrivateKey))
		if err != nil {
			return nil, err
		}
		config.Auth = []ssh.AuthMethod{
			ssh.PublicKeys(signer),
		}
	} else {
		return nil, errors.New("error ssh auth")
	}

	if opt.Port == 0 {
		opt.Port = 22
	}

	conn, err := ssh.Dial("tcp", fmt.Sprintf("%s:%d", opt.Host, opt.Port), config)
	if err != nil {
		return nil, err
	}

	client, err := sftp.NewClient(conn)
	if err != nil {
		return nil, err
	}

	d := &SFTP{opt: opt, client: client}
	if opt.RootPath != "" {
		return driver.PrefixFS(d, opt.RootPath), nil
	}
	return d, nil
}

func init() {
	driver.Register("sftp", func() driver.Option {
		return &Option{}
	})
}
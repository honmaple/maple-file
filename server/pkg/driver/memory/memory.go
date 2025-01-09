package memory

import (
	"bytes"
	"context"
	"errors"
	"io"
	"io/fs"
	"strings"
	"testing/fstest"
	"time"

	filepath "path"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type Option struct {
	base.Option
	Files fstest.MapFS
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Memory struct {
	driver.Base
	opt    *Option
	client fstest.MapFS
}

func (d *Memory) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	entries, err := d.client.ReadDir(path)
	if err != nil {
		return nil, err
	}

	files := make([]driver.File, len(entries))
	for i, entry := range entries {
		info, err := entry.Info()
		if err != nil {
			return nil, err
		}
		files[i] = driver.NewFile(path, info)
	}
	return files, nil
}

func (d *Memory) Get(ctx context.Context, path string) (driver.File, error) {
	info, err := d.client.Stat(path)
	if err != nil {
		return nil, err
	}
	return driver.NewFile(filepath.Dir(path), info), nil
}

func (d *Memory) Open(path string) (driver.FileReader, error) {
	info, err := d.client.Stat(path)
	if err != nil {
		return nil, err
	}

	rangeFunc := func(offset, length int64) (io.ReadCloser, error) {
		return d.client.Open(path)
	}
	return driver.NewFileReader(info.Size(), rangeFunc)
}

func (d *Memory) Create(path string) (driver.FileWriter, error) {
	_, err := d.client.Stat(filepath.Dir(path))
	if err != nil {
		return nil, err
	}

	r, w := util.Pipe()
	go func() {
		var buf bytes.Buffer
		_, err := io.Copy(&buf, r)

		d.client[path] = &fstest.MapFile{
			Data: buf.Bytes(),
		}
		r.CloseWithError(err)
	}()
	return w, nil
}

func (d *Memory) Rename(ctx context.Context, path, newName string) error {
	info, err := d.client.Stat(path)
	if err != nil {
		return err
	}

	dst := filepath.Join(filepath.Dir(path), newName)
	if info.IsDir() {
		newFiles := make(map[string]*fstest.MapFile)
		for key, value := range d.client {
			if util.IsSubPath(path, key) {
				newFiles[filepath.Join(dst, strings.TrimPrefix(key, path))] = value
				delete(d.client, key)
			}
		}
		for k, v := range newFiles {
			d.client[k] = v
		}
		return nil
	}
	d.client[dst] = d.client[path]
	delete(d.client, path)
	return nil
}

func (d *Memory) Move(ctx context.Context, src, dst string) error {
	info, err := d.client.Stat(src)
	if err != nil {
		return err
	}
	dst = filepath.Join(dst, filepath.Base(src))

	if info.IsDir() {
		newFiles := make(map[string]*fstest.MapFile)
		for key, value := range d.client {
			if util.IsSubPath(src, key) {
				newFiles[filepath.Join(dst, strings.TrimPrefix(key, src))] = value
				delete(d.client, key)
			}
		}
		for k, v := range newFiles {
			d.client[k] = v
		}
		return nil
	}
	d.client[dst] = d.client[src]
	delete(d.client, src)
	return nil
}

func (d *Memory) Copy(ctx context.Context, src, dst string) error {
	info, err := d.client.Stat(src)
	if err != nil {
		return err
	}
	dst = filepath.Join(dst, filepath.Base(src))

	if info.IsDir() {
		newFiles := make(map[string]*fstest.MapFile)
		for key, value := range d.client {
			if util.IsSubPath(src, key) {
				newFiles[filepath.Join(dst, strings.TrimPrefix(key, src))] = value
			}
		}
		for k, v := range newFiles {
			d.client[k] = v
		}
		return nil
	}
	d.client[dst] = d.client[src]
	return nil
}

func (d *Memory) MakeDir(ctx context.Context, path string) error {
	info, err := d.client.Stat(path)
	if err == nil {
		if info.IsDir() {
			return nil
		}
		return errors.New("cannot makedir: file is exists")
	}
	d.client[path] = &fstest.MapFile{
		Mode:    fs.ModeDir,
		ModTime: time.Now(),
	}
	return nil
}

func (d *Memory) Remove(ctx context.Context, path string) error {
	delete(d.client, path)
	return nil
}

// 仅供测试使用
func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	client := make(fstest.MapFS)
	for k, v := range opt.Files {
		client[strings.TrimPrefix(k, "/")] = v
	}

	d := &Memory{opt: opt, client: client}
	return opt.Option.NewFS(base.TrimPrefixFS(d, "/"))
}

func init() {
	driver.Register("memory", func() driver.Option {
		return &Option{}
	})
}

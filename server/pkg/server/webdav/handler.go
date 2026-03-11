package webdav

import (
	"context"
	"errors"
	"io/fs"
	"os"
	"path"
	"path/filepath"
	"strings"
	"time"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"golang.org/x/net/webdav"
)

type (
	FS struct {
		fs driver.FS
	}
	File struct {
		fs     driver.FS
		path   string
		info   driver.File
		files  []driver.File
		reader driver.FileReader
		writer driver.FileWriter
	}
)

func slashClean(name string) string {
	if name == "" || name[0] != '/' {
		name = "/" + name
	}
	return path.Clean(name)
}

func (f *File) Stat() (fs.FileInfo, error) {
	if f.path == "" || f.path == "/" {
		info := &driver.FileInfo{
			Path:    "/",
			Name:    "/",
			IsDir:   true,
			Type:    "DIR",
			ModTime: time.Now(),
		}
		return info.File(), nil
	}

	if f.info != nil {
		return f.info, nil
	}
	info, err := f.fs.Get(context.TODO(), f.path)
	if err != nil {
		return nil, err
	}
	f.info = info
	return info, nil
}

func (f *File) Readdir(count int) ([]fs.FileInfo, error) {
	if f.files == nil {
		files, err := f.fs.List(context.TODO(), f.path)
		if err != nil {
			return nil, err
		}
		f.files = files
	}

	infos := make([]fs.FileInfo, 0)
	for i, file := range f.files {
		if count > 0 && count < i {
			break
		}
		infos = append(infos, file)
	}
	return infos, nil
}

func (f *File) Read(p []byte) (n int, err error) {
	if f.reader == nil {
		stat, err := f.Stat()
		if err != nil {
			return 0, err
		}
		if stat.IsDir() {
			return 0, &fs.PathError{
				Op:   "read",
				Path: f.path,
				Err:  fs.ErrInvalid,
			}
		}
		r, err := f.fs.Open(f.path)
		if err != nil {
			return 0, err
		}
		f.reader = r
	}
	return f.reader.Read(p)
}

func (f *File) Seek(offset int64, whence int) (int64, error) {
	if f.reader == nil {
		stat, err := f.Stat()
		if err != nil {
			return 0, err
		}
		if stat.IsDir() {
			return 0, &fs.PathError{
				Op:   "seek",
				Path: f.path,
				Err:  fs.ErrInvalid,
			}
		}
		r, err := f.fs.Open(f.path)
		if err != nil {
			return 0, err
		}
		f.reader = r
	}
	return f.reader.Seek(offset, whence)
}

func (f *File) Write(p []byte) (n int, err error) {
	if f.writer == nil {
		return 0, &fs.PathError{
			Op:   "write",
			Path: f.path,
			Err:  fs.ErrInvalid,
		}
	}
	return f.writer.Write(p)
}

func (f *File) Close() error {
	if f.reader != nil {
		return f.reader.Close()
	}
	if f.writer != nil {
		return f.writer.Close()
	}
	return nil
}

func (d FS) resolve(name string) string {
	// This implementation is based on Dir.Open's code in the standard net/http package.
	if filepath.Separator != '/' && strings.ContainsRune(name, filepath.Separator) ||
		strings.Contains(name, "\x00") {
		return ""
	}
	return filepath.FromSlash(slashClean(name))
}

func (d FS) Stat(ctx context.Context, name string) (fs.FileInfo, error) {
	if name = d.resolve(name); name == "" {
		return nil, os.ErrNotExist
	}
	info, err := d.fs.Get(ctx, name)
	if err != nil {
		return nil, err
	}
	return info, nil
}

func (d FS) Mkdir(ctx context.Context, name string, perm os.FileMode) error {
	if name = d.resolve(name); name == "" {
		return os.ErrNotExist
	}
	return d.fs.MakeDir(ctx, name)
}

func (d FS) OpenFile(ctx context.Context, name string, flag int, perm os.FileMode) (webdav.File, error) {
	if name = d.resolve(name); name == "" {
		return nil, os.ErrNotExist
	}

	// 不支持的操作
	if flag&os.O_APPEND != 0 {
		return nil, os.ErrInvalid
	}

	file := &File{fs: d.fs, path: name}

	_, err := file.Stat()
	if err != nil {
		if !errors.Is(err, os.ErrNotExist) || (flag&os.O_CREATE) == 0 {
			return nil, err
		}
		// 创建
		w, err := d.fs.Create(name)
		if err != nil {
			return nil, err
		}
		file.writer = w
	}
	return file, nil
}

func (d FS) RemoveAll(ctx context.Context, name string) error {
	if name = d.resolve(name); name == "" {
		return os.ErrNotExist
	}
	return d.fs.Remove(ctx, name)
}

func (d FS) Rename(ctx context.Context, oldName, newName string) error {
	if oldName = d.resolve(oldName); oldName == "" {
		return os.ErrNotExist
	}
	if newName = d.resolve(newName); newName == "" {
		return os.ErrNotExist
	}
	return d.fs.Rename(ctx, oldName, newName)
}

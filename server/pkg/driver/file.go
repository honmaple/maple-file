package driver

import (
	"encoding/json"
	"io"
	"io/fs"
	"mime"
	"os"
	"path/filepath"
	"time"
)

type (
	File interface {
		fs.FileInfo
		Type() string
		Path() string
	}
	FileReader interface {
		io.Seeker
		io.ReadCloser
	}
	FileWriter interface {
		io.WriteCloser
	}
)

type fsFile struct {
	file File
	FileReader
}

func (f *fsFile) Stat() (fs.FileInfo, error) {
	return f.file, nil
}

type emptyFile struct {
	size    int64
	name    string
	path    string
	mode    fs.FileMode
	modTime time.Time
	isDir   bool
}

func (f *emptyFile) Path() string       { return f.path }
func (f *emptyFile) Type() string       { return mime.TypeByExtension(filepath.Ext(f.name)) }
func (f *emptyFile) Name() string       { return f.name }
func (f *emptyFile) Size() int64        { return f.size }
func (f *emptyFile) Mode() fs.FileMode  { return f.mode }
func (f *emptyFile) IsDir() bool        { return f.isDir }
func (f *emptyFile) ModTime() time.Time { return f.modTime }
func (f *emptyFile) Sys() any           { return nil }
func (f *emptyFile) MarshalJSON() ([]byte, error) {
	return json.Marshal(map[string]interface{}{
		// "path":     f.path,
		"name": f.name,
		"size": f.size,
		// "type":     f.Type(),
		"mode":     f.mode,
		"is_dir":   f.isDir,
		"mod_time": f.modTime,
	})
}

type seeker struct {
	r            io.ReadCloser
	offset       int64
	readAtOffset int64
	size         int64
	rangeFunc    func(int64, int64) (io.ReadCloser, error)
}

func (s *seeker) Read(buf []byte) (n int, err error) {
	n, err = s.ReadAt(buf, s.offset)
	s.offset += int64(n)
	return
}

func (s *seeker) ReadAt(buf []byte, off int64) (n int, err error) {
	if off < 0 {
		return -1, os.ErrInvalid
	}

	if off != s.readAtOffset && s.r != nil {
		_ = s.r.Close()
		s.r = nil
	}

	if s.r == nil {
		s.r, err = s.rangeFunc(int64(off), 0)
		s.readAtOffset = off
		if err != nil {
			return 0, err
		}
	}

	n, err = s.r.Read(buf)
	s.readAtOffset += int64(n)
	return
}

func (s *seeker) Seek(offset int64, whence int) (int64, error) {
	oldOffset := s.offset
	var newOffset int64
	switch whence {
	case io.SeekStart:
		newOffset = offset
	case io.SeekCurrent:
		newOffset = oldOffset + offset
	case io.SeekEnd:
		return s.size, nil
	default:
		return -1, os.ErrInvalid
	}

	if newOffset < 0 {
		return oldOffset, os.ErrInvalid
	}
	if newOffset == oldOffset {
		return oldOffset, nil
	}
	s.offset = newOffset
	return newOffset, nil
}

func (s *seeker) Close() error {
	if s.r != nil {
		return s.r.Close()
	}
	return nil
}

func Compare(src, dst File) bool {
	return src.Size() == dst.Size() && src.ModTime().Equal(dst.ModTime())
}

func NewFile(path string, info fs.FileInfo) File {
	return &emptyFile{
		path:    path,
		name:    info.Name(),
		size:    info.Size(),
		mode:    info.Mode(),
		modTime: info.ModTime(),
		isDir:   info.IsDir(),
	}
}

func NewFileReader(size int64, rangeFunc func(int64, int64) (io.ReadCloser, error)) (FileReader, error) {
	return &seeker{
		size:      size,
		rangeFunc: rangeFunc,
	}, nil
}

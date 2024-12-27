package driver

import (
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

type FileInfo struct {
	Name    string      `json:"name"`
	Size    int64       `json:"size"`
	Path    string      `json:"path"`
	Mode    fs.FileMode `json:"mode"`
	IsDir   bool        `json:"is_dir"`
	ModTime time.Time   `json:"mod_time"`
}

type emptyFile struct {
	FileInfo
}

func (f *emptyFile) Type() string {
	if f.FileInfo.IsDir {
		return "DIR"
	}
	return mime.TypeByExtension(filepath.Ext(f.FileInfo.Name))
}
func (f *emptyFile) Path() string       { return f.FileInfo.Path }
func (f *emptyFile) Name() string       { return f.FileInfo.Name }
func (f *emptyFile) Size() int64        { return f.FileInfo.Size }
func (f *emptyFile) Mode() fs.FileMode  { return f.FileInfo.Mode }
func (f *emptyFile) IsDir() bool        { return f.FileInfo.IsDir }
func (f *emptyFile) ModTime() time.Time { return f.FileInfo.ModTime }
func (f *emptyFile) Sys() any           { return nil }

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

func NewFile(path string, info fs.FileInfo) File {
	if path == "" {
		path = "/"
	}
	return &emptyFile{
		FileInfo: FileInfo{
			Path:    path,
			Name:    info.Name(),
			Size:    info.Size(),
			Mode:    info.Mode(),
			ModTime: info.ModTime(),
			IsDir:   info.IsDir(),
		},
	}
}

func NewFileReader(size int64, rangeFunc func(int64, int64) (io.ReadCloser, error)) (FileReader, error) {
	return &seeker{
		size:      size,
		rangeFunc: rangeFunc,
	}, nil
}

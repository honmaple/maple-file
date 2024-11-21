package driver

import (
	"encoding/json"
	"io"
	"io/fs"
	"mime"
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
	io.ReadCloser
	size  int64
	first bool // http.ServeContent 会读取一小块以决定内容类型， 所以第一次read会返回假数据
}

func (s *seeker) Read(p []byte) (n int, err error) {
	if s.first && len(p) == 512 {
		return 0, io.EOF
	}
	return s.ReadCloser.Read(p)
}

func (s *seeker) Seek(offset int64, whence int) (int64, error) {
	if s.first {
		s.first = false
	}
	if offset == 0 {
		switch whence {
		case io.SeekStart:
			return 0, nil
		case io.SeekEnd:
			return s.size, nil
		}
	}
	if r, ok := s.ReadCloser.(io.ReadSeekCloser); ok {
		return r.Seek(offset, whence)
	}
	return 0, ErrNotSupport
}

func Compare(src, dst File) bool {
	return src.Size() == dst.Size() && src.ModTime().Equal(dst.ModTime())
}

func ReadSeeker(r io.ReadCloser, size int64) FileReader {
	first := true
	if _, ok := r.(io.ReadSeekCloser); ok {
		first = false
	}
	return &seeker{r, size, first}
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

package driver

import (
	"io"
	"io/fs"
	"time"

	"github.com/honmaple/cloudfs"
)

type (
	File       = cloudfs.FileInfo
	FileReader = cloudfs.File
	FileWriter = cloudfs.FileWriter
)

type FileInfo struct {
	Name      string         `json:"name"`
	Type      string         `json:"type"`
	Size      int64          `json:"size"`
	Path      string         `json:"path"`
	Mode      fs.FileMode    `json:"mode"`
	IsDir     bool           `json:"is_dir"`
	ModTime   time.Time      `json:"mod_time"`
	ExtraInfo map[string]any `json:"extra_info"`
}

func (info *FileInfo) File() File {
	return cloudfs.NewFileInfo(fileInfoAdapter{info}, func(entry *cloudfs.Entry) {
		entry.Name = info.Name
		entry.Type = info.Type
		entry.Size = info.Size
		entry.Path = info.Path
		entry.Mode = info.Mode
		entry.IsDir = info.IsDir
		entry.ModTime = info.ModTime
		entry.ExtraInfo = info.ExtraInfo
	})
}

type fileInfoAdapter struct {
	info *FileInfo
}

func (f fileInfoAdapter) Name() string       { return f.info.Name }
func (f fileInfoAdapter) Size() int64        { return f.info.Size }
func (f fileInfoAdapter) Mode() fs.FileMode  { return f.info.Mode }
func (f fileInfoAdapter) ModTime() time.Time { return f.info.ModTime }
func (f fileInfoAdapter) IsDir() bool        { return f.info.IsDir }
func (f fileInfoAdapter) Sys() any           { return nil }

func NewFile(path string, info fs.FileInfo, opts ...func(*FileInfo)) File {
	fi := &FileInfo{
		Path:    path,
		Name:    info.Name(),
		Size:    info.Size(),
		Mode:    info.Mode(),
		ModTime: info.ModTime(),
		IsDir:   info.IsDir(),
	}
	for _, opt := range opts {
		opt(fi)
	}
	return cloudfs.NewFileInfo(info, func(entry *cloudfs.Entry) {
		entry.Name = fi.Name
		entry.Type = fi.Type
		entry.Size = fi.Size
		entry.Path = fi.Path
		entry.Mode = fi.Mode
		entry.IsDir = fi.IsDir
		entry.ModTime = fi.ModTime
		entry.ExtraInfo = fi.ExtraInfo
	})
}

func NewFileReader(size int64, rangeFunc func(int64, int64) (io.ReadCloser, error)) (FileReader, error) {
	return cloudfs.NewFile(size, rangeFunc)
}

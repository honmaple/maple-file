package driver

import (
	"io/fs"
	"time"

	"github.com/honmaple/cloudfs"
)

func NewFile(path string, info fs.FileInfo, opts ...func(*cloudfs.Entry)) cloudfs.FileInfo {
	return cloudfs.NewFileInfo(info, append([]func(*cloudfs.Entry){
		func(entry *cloudfs.Entry) {
			entry.Path = path
		},
	}, opts...)...)
}

func NewDir(path, name string, opts ...func(*cloudfs.Entry)) cloudfs.FileInfo {
	return cloudfs.NewFileInfo(dirInfo{name: name}, append([]func(*cloudfs.Entry){
		func(entry *cloudfs.Entry) {
			entry.Path = path
			entry.Name = name
			entry.IsDir = true
			entry.Mode = fs.ModeDir
		},
	}, opts...)...)
}

type dirInfo struct {
	name string
}

func (d dirInfo) Name() string       { return d.name }
func (d dirInfo) Size() int64        { return 0 }
func (d dirInfo) Mode() fs.FileMode  { return fs.ModeDir }
func (d dirInfo) ModTime() time.Time { return time.Time{} }
func (d dirInfo) IsDir() bool        { return true }
func (d dirInfo) Sys() any           { return nil }

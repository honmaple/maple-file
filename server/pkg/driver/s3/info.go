package s3

import (
	"github.com/aws/aws-sdk-go/service/s3"
	"io/fs"
	"time"
)

type fileinfo1 struct {
	size    int64
	name    string
	path    string
	mode    fs.FileMode
	modTime time.Time
	isDir   bool
}

func (d *fileinfo1) Name() string       { return d.name }
func (d *fileinfo1) Size() int64        { return d.size }
func (d *fileinfo1) Mode() fs.FileMode  { return d.mode }
func (d *fileinfo1) ModTime() time.Time { return d.modTime }
func (d *fileinfo1) IsDir() bool        { return d.isDir }
func (d *fileinfo1) Sys() any           { return nil }

type fileinfo struct {
	info *s3.Object
}

func (d *fileinfo) Name() string       { return *d.info.Key }
func (d *fileinfo) Size() int64        { return *d.info.Size }
func (d *fileinfo) Mode() fs.FileMode  { return 0 }
func (d *fileinfo) ModTime() time.Time { return *d.info.LastModified }
func (d *fileinfo) IsDir() bool        { return false }
func (d *fileinfo) Sys() any           { return nil }

type dirinfo struct {
	info *s3.CommonPrefix
}

func (d *dirinfo) Name() string       { return *d.info.Prefix }
func (d *dirinfo) Size() int64        { return 0 }
func (d *dirinfo) Mode() fs.FileMode  { return 0 }
func (d *dirinfo) ModTime() time.Time { return time.Now() }
func (d *dirinfo) IsDir() bool        { return true }
func (d *dirinfo) Sys() any           { return nil }

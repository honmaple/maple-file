package s3

import (
	"io/fs"
	filepath "path"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go/service/s3"
)

type headinfo struct {
	name string
	info *s3.HeadObjectOutput
}

func (d *headinfo) Name() string       { return d.name }
func (d *headinfo) Size() int64        { return *d.info.ContentLength }
func (d *headinfo) Mode() fs.FileMode  { return 0 }
func (d *headinfo) ModTime() time.Time { return *d.info.LastModified }
func (d *headinfo) IsDir() bool        { return *d.info.ContentLength == 0 }
func (d *headinfo) Sys() any           { return nil }

type fileinfo struct {
	info *s3.Object
}

func (d *fileinfo) Name() string       { return filepath.Base(*d.info.Key) }
func (d *fileinfo) Size() int64        { return *d.info.Size }
func (d *fileinfo) Mode() fs.FileMode  { return 0 }
func (d *fileinfo) ModTime() time.Time { return *d.info.LastModified }
func (d *fileinfo) IsDir() bool        { return false }
func (d *fileinfo) Sys() any           { return nil }

type dirinfo struct {
	info *s3.CommonPrefix
}

func (d *dirinfo) Name() string       { return filepath.Base(strings.TrimSuffix(*d.info.Prefix, "/")) }
func (d *dirinfo) Size() int64        { return 0 }
func (d *dirinfo) Mode() fs.FileMode  { return 0 }
func (d *dirinfo) ModTime() time.Time { return time.Now() }
func (d *dirinfo) IsDir() bool        { return true }
func (d *dirinfo) Sys() any           { return nil }

type emptyinfo struct {
	size    int64
	name    string
	mode    fs.FileMode
	isDir   bool
	modTime time.Time
}

func (f *emptyinfo) Name() string       { return f.name }
func (f *emptyinfo) Size() int64        { return f.size }
func (f *emptyinfo) Mode() fs.FileMode  { return f.mode }
func (f *emptyinfo) IsDir() bool        { return f.isDir }
func (f *emptyinfo) ModTime() time.Time { return f.modTime }
func (f *emptyinfo) Sys() any           { return nil }

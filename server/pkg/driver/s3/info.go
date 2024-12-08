package s3

import (
	"github.com/aws/aws-sdk-go/service/s3"
	"io/fs"
	"time"
)

type headinfo struct {
	info *s3.HeadObjectOutput
}

func (d *headinfo) Name() string       { return *d.info.SSEKMSKeyId }
func (d *headinfo) Size() int64        { return *d.info.ContentLength }
func (d *headinfo) Mode() fs.FileMode  { return 0 }
func (d *headinfo) ModTime() time.Time { return *d.info.LastModified }
func (d *headinfo) IsDir() bool        { return false }
func (d *headinfo) Sys() any           { return nil }

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

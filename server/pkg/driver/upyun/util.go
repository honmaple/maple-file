package upyun

import (
	"io/fs"
	"time"

	filepath "path"

	"github.com/upyun/go-sdk/v3/upyun"
)

type fileinfo struct {
	info *upyun.FileInfo
}

func (d *fileinfo) Name() string       { return filepath.Base(d.info.Name) }
func (d *fileinfo) Size() int64        { return d.info.Size }
func (d *fileinfo) Mode() fs.FileMode  { return 0 }
func (d *fileinfo) ModTime() time.Time { return d.info.Time }
func (d *fileinfo) IsDir() bool        { return d.info.IsDir }
func (d *fileinfo) Sys() any           { return nil }

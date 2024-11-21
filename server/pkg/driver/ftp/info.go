package ftp

import (
	"io/fs"
	"time"

	"github.com/jlaffaye/ftp"
)

type fileinfo struct {
	info *ftp.Entry
}

func (d *fileinfo) Name() string       { return d.info.Name }
func (d *fileinfo) Size() int64        { return int64(d.info.Size) }
func (d *fileinfo) Mode() fs.FileMode  { return 0 }
func (d *fileinfo) ModTime() time.Time { return d.info.Time }
func (d *fileinfo) IsDir() bool        { return d.info.Type == ftp.EntryTypeFolder }
func (d *fileinfo) Sys() any           { return nil }

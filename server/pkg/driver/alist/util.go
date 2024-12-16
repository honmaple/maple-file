package alist

import (
	"io/fs"
	"time"

	"github.com/tidwall/gjson"
)

type fileinfo struct {
	info gjson.Result
}

func (d *fileinfo) Name() string       { return d.info.Get("name").String() }
func (d *fileinfo) Size() int64        { return d.info.Get("size").Int() }
func (d *fileinfo) Mode() fs.FileMode  { return 0 }
func (d *fileinfo) ModTime() time.Time { return d.info.Get("modified").Time() }
func (d *fileinfo) IsDir() bool        { return d.info.Get("is_dir").Bool() }
func (d *fileinfo) Sys() any           { return nil }

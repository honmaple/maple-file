package foxel

import (
	"io/fs"
	"time"

	"github.com/tidwall/gjson"
)

type fileinfo struct {
	info gjson.Result
	name string
}

func (d *fileinfo) Name() string {
	if name := d.info.Get("name").String(); name != "" {
		return name
	}
	return d.name
}
func (d *fileinfo) Size() int64       { return d.info.Get("size").Int() }
func (d *fileinfo) Mode() fs.FileMode { return 0 }
func (d *fileinfo) ModTime() time.Time {
	mtime := d.info.Get("mtime").Int()
	if mtime <= 0 {
		return time.Unix(0, 0)
	}
	return time.Unix(mtime, 0)
}
func (d *fileinfo) IsDir() bool { return d.info.Get("is_dir").Bool() }
func (d *fileinfo) Sys() any    { return nil }

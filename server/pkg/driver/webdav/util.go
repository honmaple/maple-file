package webdav

import (
	"os"
)

type fileinfo struct {
	os.FileInfo
	name string
}

func (d *fileinfo) Name() string { return d.name }


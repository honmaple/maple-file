package alist

import (
	"fmt"
	"io"
	"io/fs"
	"math/rand"
	"net/url"
	"strings"
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

func fromData(data map[string]string) io.Reader {
	form := url.Values{}
	for k, v := range data {
		form.Set(k, v)
	}
	return strings.NewReader(form.Encode())
}

func long2ip(ip int64) string {
	return fmt.Sprintf("%d.%d.%d.%d",
		(ip>>24)&0xFF,
		(ip>>16)&0xFF,
		(ip>>8)&0xFF,
		ip&0xFF)
}

func randomIP() string {
	return long2ip(randRange(1884815360, 1884890111))
}

func randRange(min, max int64) int64 {
	diff := max - min
	move := rand.Int63n(diff)
	randNum := min + move
	return randNum
}

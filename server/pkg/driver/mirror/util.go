package mirror

import (
	"io/fs"
	"strconv"
	"strings"
	"time"

	"github.com/PuerkitoBio/goquery"
	"github.com/honmaple/maple-file/server/pkg/driver"
)

type fileinfo struct {
	size    int64
	name    string
	mode    fs.FileMode
	isDir   bool
	modTime time.Time
}

func (f *fileinfo) Name() string       { return f.name }
func (f *fileinfo) Size() int64        { return f.size }
func (f *fileinfo) Mode() fs.FileMode  { return f.mode }
func (f *fileinfo) IsDir() bool        { return f.isDir }
func (f *fileinfo) ModTime() time.Time { return f.modTime }
func (f *fileinfo) Sys() any           { return nil }

func parseNginx(path string, doc *goquery.Document) []driver.File {
	files := make([]driver.File, 0)

	doc.Find("pre a").Each(func(i int, s *goquery.Selection) {
		if i == 0 {
			return
		}
		name := s.Text()

		info := &fileinfo{
			name:  strings.TrimSuffix(name, "/"),
			isDir: strings.HasSuffix(name, "/"),
		}
		if fields := strings.Fields(strings.TrimSpace(s.Nodes[0].NextSibling.Data)); len(fields) > 0 {
			if size, err := strconv.Atoi(fields[len(fields)-1]); err == nil {
				info.size = int64(size)
			}
			if modTime, err := time.Parse("02-Jan-2006 15:04", strings.Join(fields[0:len(fields)-1], " ")); err == nil {
				info.modTime = modTime
			}
		}
		files = append(files, driver.NewFile(path, info))
	})
	return files
}

func parseAliyun(path string, doc *goquery.Document) []driver.File {
	files := make([]driver.File, 0)

	doc.Find("tbody tr").Each(func(i int, s *goquery.Selection) {
		if i == 0 {
			return
		}
		name := s.Find(".link a").Text()

		info := &fileinfo{
			name:  strings.TrimSuffix(name, "/"),
			isDir: strings.HasSuffix(name, "/"),
		}

		if modTime, err := time.Parse("2006-01-02 15:04", s.Find(".date").Text()); err == nil {
			info.modTime = modTime
		}
		if parts := strings.Split(s.Find(".size").Text(), " "); len(parts) == 2 {
			size, err := strconv.ParseFloat(parts[0], 64)
			if err == nil {
				switch parts[1] {
				case "B":
					info.size = int64(size)
				case "KB":
					info.size = int64(size * 1024)
				case "MB":
					info.size = int64(size * 1024 * 1024)
				case "GB":
					info.size = int64(size * 1024 * 1024 * 1024)
				}
			}
		}
		files = append(files, driver.NewFile(path, info))
	})
	return files
}

func parseTuna(path string, doc *goquery.Document) []driver.File {
	files := make([]driver.File, 0)

	doc.Find("tbody tr").Each(func(i int, s *goquery.Selection) {
		if i == 0 {
			return
		}
		name := s.Find(".link a").Text()

		info := &fileinfo{
			name:  strings.TrimSuffix(name, "/"),
			isDir: strings.HasSuffix(name, "/"),
		}

		if modTime, err := time.Parse("2006-01-02 15:04", s.Find(".date").Text()); err == nil {
			info.modTime = modTime
		}
		if parts := strings.Split(s.Find(".size").Text(), " "); len(parts) == 2 {
			size, err := strconv.ParseFloat(parts[0], 64)
			if err == nil {
				switch parts[1] {
				case "B":
					info.size = int64(size)
				case "KiB":
					info.size = int64(size * 1024)
				case "MiB":
					info.size = int64(size * 1024 * 1024)
				case "GiB":
					info.size = int64(size * 1024 * 1024 * 1024)
				}
			}
		}
		files = append(files, driver.NewFile(path, info))
	})
	return files
}

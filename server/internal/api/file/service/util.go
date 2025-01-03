package service

import (
	"path/filepath"
	"time"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/util"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type readFunc func() (*pb.FileRequest, error)

func (rf readFunc) Read(p []byte) (n int, err error) {
	req, err := rf()
	if err != nil {
		return 0, err
	}
	n = copy(p, req.GetChunk())
	return n, nil
}

type chunkFunc func([]byte) error

func (cf chunkFunc) Write(p []byte) (n int, err error) {
	if err := cf(p); err != nil {
		return 0, err
	}
	return len(p), nil
}

func renameFile(format, filename string) string {
	if format == "" {
		return filename
	}
	ext := filepath.Ext(filename)
	name := filename[:len(filename)-len(ext)]

	now := time.Now()
	return util.StrReplace(format, map[string]string{
		"{extension}":   ext,
		"{filename}":    name,
		"{time:year}":   now.Format("2006"),
		"{time:month}":  now.Format("01"),
		"{time:day}":    now.Format("02"),
		"{time:hour}":   now.Format("15"),
		"{time:minute}": now.Format("04"),
	})
}

func infoToFile(m driver.File) *pb.File {
	file := &pb.File{
		Path:      m.Path(),
		Name:      m.Name(),
		Size:      int32(m.Size()),
		Type:      m.Type(),
		CreatedAt: timestamppb.New(m.ModTime()),
		UpdatedAt: timestamppb.New(m.ModTime()),
	}
	return file
}

func paginator(files []*pb.File, page int, pageSize int) []*pb.File {
	if pageSize <= 0 {
		return files
	}

	if page <= 0 {
		page = 1
	}
	total := len(files)
	start := (page - 1) * pageSize
	if start > total {
		return []*pb.File{}
	}
	end := start + pageSize
	if end > total {
		end = total
	}
	return files[start:end]
}

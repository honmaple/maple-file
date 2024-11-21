package service

import (
	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
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

type previewFunc func(*pb.PreviewFileResponse) error

func (wf previewFunc) Write(p []byte) (n int, err error) {
	if err := wf(&pb.PreviewFileResponse{
		Chunk: p,
	}); err != nil {
		return 0, err
	}
	return len(p), nil
}

func getPage(pageNum int32, pageSize int32) (int32, int32) {
	if pageNum <= 0 {
		pageNum = 1
	}
	if pageSize <= 0 {
		pageSize = 20
	}
	return (pageNum - 1) * pageSize, pageSize
}

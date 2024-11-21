package service

import (
	"context"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/setting"
)

func ptr[T any](x T) *T {
	return &x
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

func (srv *Service) Ping(ctx context.Context, in *pb.PingRequest) (*pb.PingResponse, error) {
	return &pb.PingResponse{Message: "pong"}, nil
}

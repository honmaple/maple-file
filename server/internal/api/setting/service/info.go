package service

import (
	"context"
	"runtime"

	"github.com/honmaple/maple-file/server/internal/app"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/setting"
)

func (srv *Service) Info(ctx context.Context, in *pb.InfoRequest) (*pb.InfoResponse, error) {
	result := &pb.Info{
		Os:          runtime.GOOS,
		Arch:        runtime.GOARCH,
		Runtime:     runtime.Version(),
		Version:     app.VERSION,
		Description: app.DESCRIPTION,
	}
	return &pb.InfoResponse{Result: result}, nil
}

package service

import (
	"context"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"

	"github.com/honmaple/maple-file/server/pkg/server"
	_ "github.com/honmaple/maple-file/server/pkg/server/webdav"
)

func (srv *Service) ServerStatus(ctx context.Context, req *pb.ExternalServer_GetRequest) (*pb.ExternalServer_GetResponse, error) {
	server, ok := srv.servers.Load(req.GetType())

	result := new(pb.ExternalServer)
	if ok {
		status := server.Status()

		result.Addr = status.Addr
		result.Error = status.Error
		result.Running = status.Running
	}
	return &pb.ExternalServer_GetResponse{
		Result: result,
	}, nil
}

func (srv *Service) StartServer(ctx context.Context, req *pb.ExternalServer_StartRequest) (*pb.ExternalServer_StartResponse, error) {
	s, ok := srv.servers.Load(req.GetType())
	if ok {
		s.Stop()
	}

	s, err := server.New(srv.fs, req.GetType(), req.GetOption())
	if err != nil {
		return nil, err
	}
	if err := s.Start(); err != nil {
		return nil, err
	}
	srv.servers.Store(req.GetType(), s)

	status := s.Status()
	return &pb.ExternalServer_StartResponse{
		Result: &pb.ExternalServer{
			Addr:    status.Addr,
			Error:   status.Error,
			Running: status.Running,
		},
	}, nil
}

func (srv *Service) StopServer(ctx context.Context, req *pb.ExternalServer_StopRequest) (*pb.ExternalServer_StopResponse, error) {
	server, ok := srv.servers.Load(req.GetType())
	if ok {
		if err := server.Stop(); err != nil {
			return nil, err
		}
		srv.servers.Delete(req.GetType())
	}
	return &pb.ExternalServer_StopResponse{}, nil
}

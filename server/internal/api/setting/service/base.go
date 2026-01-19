package service

import (
	"context"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"google.golang.org/grpc"

	"github.com/honmaple/maple-file/server/internal/app"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/setting"
)

type Service struct {
	app.BaseService
	pb.UnimplementedSystemServiceServer
	app *app.App
}

func (srv *Service) Register(grpc *grpc.Server) {
	pb.RegisterSystemServiceServer(grpc, srv)
}

func (srv *Service) RegisterGateway(ctx context.Context, mux *runtime.ServeMux) {
	pb.RegisterSystemServiceHandlerServer(ctx, mux, srv)
}

func New(app *app.App) *Service {
	return &Service{app: app}
}

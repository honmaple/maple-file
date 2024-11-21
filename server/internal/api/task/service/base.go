package service

import (
	"context"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"
	"google.golang.org/grpc"

	"github.com/honmaple/maple-file/server/internal/app"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/task"
)

type Service struct {
	pb.UnimplementedTaskServiceServer
	app *app.App
}

func (srv *Service) Register(grpc *grpc.Server) {
	pb.RegisterTaskServiceServer(grpc, srv)
}

func (srv *Service) RegisterGateway(ctx context.Context, mux *runtime.ServeMux, e *echo.Echo) {
	pb.RegisterTaskServiceHandlerServer(ctx, mux, srv)
}

func New(app *app.App) *Service {
	srv := &Service{
		app: app,
	}
	return srv
}

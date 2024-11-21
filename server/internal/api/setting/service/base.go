package service

import (
	"context"
	"encoding/json"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"
	"google.golang.org/grpc"

	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/internal/app/config"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/setting"
)

type Service struct {
	pb.UnimplementedSystemServiceServer
	db   *config.DB
	conf *config.Config
}

func (srv *Service) Register(grpc *grpc.Server) {
	pb.RegisterSystemServiceServer(grpc, srv)
}

func (srv *Service) RegisterGateway(ctx context.Context, mux *runtime.ServeMux, e *echo.Echo) {
	pb.RegisterSystemServiceHandlerServer(ctx, mux, srv)
}

func New(app *app.App) *Service {
	conf := app.Config
	db := app.DB
	settings := make([]*pb.Setting, 0)
	db.Model(pb.Setting{}).Find(&settings)
	for _, set := range settings {
		value := make(map[string]any)
		if err := json.Unmarshal([]byte(set.GetValue()), &value); err != nil {
			continue
		}
		conf.Set(set.GetKey(), value)
	}
	return &Service{conf: conf, db: db}
}

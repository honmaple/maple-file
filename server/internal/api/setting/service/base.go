package service

import (
	"context"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"
	"google.golang.org/grpc"

	"github.com/honmaple/maple-file/server/internal/app"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/setting"
)

type Service struct {
	pb.UnimplementedSystemServiceServer
	app *app.App
}

func (srv *Service) Register(grpc *grpc.Server) {
	pb.RegisterSystemServiceServer(grpc, srv)
}

func (srv *Service) RegisterGateway(ctx context.Context, mux *runtime.ServeMux, e *echo.Echo) {
	pb.RegisterSystemServiceHandlerServer(ctx, mux, srv)
}

func New(app *app.App) *Service {
	// settings := make([]*pb.Setting, 0)
	// db.Model(pb.Setting{}).Find(&settings)
	// for _, set := range settings {
	//	value := make(map[string]any)
	//	if err := json.Unmarshal([]byte(set.GetValue()), &value); err != nil {
	//		continue
	//	}
	//	conf.Set(set.GetKey(), value)
	// }
	return &Service{app: app}
}

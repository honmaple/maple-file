package app

import (
	"context"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"
	"google.golang.org/grpc"
)

type (
	Service interface {
		Register(*grpc.Server)
		RegisterHTTP(*echo.Echo)
		RegisterGateway(context.Context, *runtime.ServeMux)
		Close() error
	}
	Services []Service
)

func (srvs Services) Register(grpc *grpc.Server) {
	for _, srv := range srvs {
		srv.Register(grpc)
	}
}

func (srvs Services) RegisterGateway(ctx context.Context, mux *runtime.ServeMux) {
	for _, srv := range srvs {
		srv.RegisterGateway(ctx, mux)
	}
}

func (srvs Services) RegisterHTTP(e *echo.Echo) {
	for _, srv := range srvs {
		srv.RegisterHTTP(e)
	}
}

func (srvs Services) Close() error {
	for _, srv := range srvs {
		srv.Close()
	}
	return nil
}

type (
	BaseService    struct{}
	ServiceCreator func(*App) (Service, error)
)

func (BaseService) Register(*grpc.Server)                              {}
func (BaseService) RegisterHTTP(*echo.Echo)                            {}
func (BaseService) RegisterGateway(context.Context, *runtime.ServeMux) {}
func (BaseService) Close() error                                       { return nil }

var creators map[string]ServiceCreator

func Register(name string, creator ServiceCreator) {
	creators[name] = creator
}

func init() {
	creators = make(map[string]ServiceCreator)
}

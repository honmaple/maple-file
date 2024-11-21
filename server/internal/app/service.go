package app

import (
	"context"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"
	"google.golang.org/grpc"
)

type Service interface {
	Register(*grpc.Server)
	RegisterGateway(context.Context, *runtime.ServeMux, *echo.Echo)
}

type Creator func(*App) (Service, error)

var creators map[string]Creator

func Register(name string, creator Creator) {
	creators[name] = creator
}

func init() {
	creators = make(map[string]Creator)
}

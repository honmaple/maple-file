package app

import (
	"context"
	// "fmt"
	"net"
	"net/http"
	"os"
	"strings"

	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/grpc"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"

	"github.com/honmaple/maple-file/server/internal/app/config"
	"github.com/honmaple/maple-file/server/pkg/runner"
)

var (
	VERSION     = "dev"
	DESCRIPTION = "Upload or download file, manage cloud file"
)

type App struct {
	ctx    context.Context
	cancel context.CancelFunc

	DB     *config.DB
	Logger *config.Logger
	Config *config.Config
	Runner runner.Runner
}

func Listen(addr string) (net.Listener, error) {
	switch {
	case strings.HasPrefix(addr, "unix://"):
		sock := addr[7:]
		if _, err := os.Stat(sock); err == nil || os.IsExist(err) {
			if err := os.Remove(sock); err != nil {
				return nil, err
			}
		}
		return net.Listen("unix", sock)
	case strings.HasPrefix(addr, "tcp://"):
		return net.Listen("tcp", addr[6:])
	default:
		return net.Listen("tcp", addr)
	}
}

func (app *App) Start(listener net.Listener) error {
	conf := app.Config

	e := echo.New()

	gsrv := grpc.NewServer(
		grpc.UnaryInterceptor(unaryInterceptor),
		grpc.StreamInterceptor(streamInterceptor),
	)
	defer gsrv.Stop()

	mux := runtime.NewServeMux()
	for _, creator := range creators {
		srv, err := creator(app)
		if err != nil {
			return err
		}
		srv.Register(gsrv)
		srv.RegisterGateway(app.ctx, mux, e)
	}

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.ProtoMajor == 2 && strings.Contains(r.Header.Get("Content-Type"), "application/grpc") {
			gsrv.ServeHTTP(w, r)
		} else {
			mux.ServeHTTP(w, r)
		}
	})
	e.Any("/*", echo.WrapHandler(handler))

	e.Listener = listener

	conf.L.Println("http server listen:", listener.Addr().String())
	return http.Serve(listener, h2c.NewHandler(e, &http2.Server{}))
}

func (app *App) Init() error {
	db, err := config.NewDB(app.Config)
	if err != nil {
		return err
	}
	app.DB = db
	app.Runner = runner.New(app.ctx, 10)
	return nil
}

func New() *App {
	ctx, cancel := context.WithCancel(context.Background())
	return &App{
		ctx:    ctx,
		cancel: cancel,
		Config: config.New(),
	}
}

var (
	defaultApp = New()
)

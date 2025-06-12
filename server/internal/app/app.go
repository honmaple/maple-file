package app

import (
	"context"
	"errors"
	"fmt"
	"io/fs"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/grpc"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/improbable-eng/grpc-web/go/grpcweb"
	"github.com/labstack/echo/v4"
	"github.com/spf13/viper"

	"github.com/honmaple/maple-file/server/internal/app/config"
	"github.com/honmaple/maple-file/server/pkg/runner"
)

var (
	PROCESS     = "maple-file"
	VERSION     = "dev"
	DESCRIPTION = "Multi-protocol cloud file upload and management with serverless."
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

func (app *App) NewServer(listener net.Listener) (*Server, error) {
	e := echo.New()

	srv := grpc.NewServer(
		grpc.UnaryInterceptor(app.unaryInterceptor),
		grpc.StreamInterceptor(app.streamInterceptor),
	)

	mux := runtime.NewServeMux()
	for _, creator := range creators {
		s, err := creator(app)
		if err != nil {
			return nil, err
		}
		s.Register(srv)
		s.RegisterGateway(app.ctx, mux, e)
	}

	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.ProtoMajor == 2 && strings.Contains(r.Header.Get("Content-Type"), "application/grpc") {
			srv.ServeHTTP(w, r)
		} else {
			mux.ServeHTTP(w, r)
		}
	})
	e.Any("/*", echo.WrapHandler(handler))

	e.Listener = listener

	return &Server{
		app:      app,
		grpc:     srv,
		server:   &http.Server{Handler: h2c.NewHandler(e, &http2.Server{})},
		listener: listener,
	}, nil
}

func (app *App) NewWebServer(listener net.Listener, webFS fs.FS) (*Server, error) {
	e := echo.New()

	srv := grpc.NewServer(
		grpc.UnaryInterceptor(app.unaryInterceptor),
		grpc.StreamInterceptor(app.streamInterceptor),
	)

	mux := runtime.NewServeMux()
	for _, creator := range creators {
		s, err := creator(app)
		if err != nil {
			return nil, err
		}
		s.Register(srv)
		s.RegisterGateway(app.ctx, mux, e)
	}

	options := []grpcweb.Option{
		grpcweb.WithCorsForRegisteredEndpointsOnly(false),
		grpcweb.WithOriginFunc(func(_ string) bool {
			return true
		}),
	}
	e.Any("/api.*", echo.WrapHandler(grpcweb.WrapServer(srv, options...)))
	e.GET("/*", echo.WrapHandler(http.FileServer(http.FS(webFS))))

	e.Listener = listener

	return &Server{
		app:      app,
		grpc:     srv,
		server:   &http.Server{Handler: h2c.NewHandler(e, &http2.Server{})},
		listener: listener,
	}, nil
}

func (app *App) Init() error {
	db, err := config.NewDB(app.Config)
	if err != nil {
		return err
	}
	app.DB = db
	app.Logger = config.NewLogger(app.Config)
	app.Runner = runner.New(app.ctx, 20)
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

type Server struct {
	app      *App
	grpc     *grpc.Server
	server   *http.Server
	listener net.Listener
}

func (srv *Server) Addr() string {
	return srv.listener.Addr().String()
}

func (srv *Server) Start() error {
	srv.app.Logger.Println("http server listen:", srv.Addr())

	return srv.server.Serve(srv.listener)
}

func (srv *Server) Shutdown() error {
	srv.app.Logger.Println("http server shutdown...")

	defer srv.grpc.Stop()
	return srv.server.Shutdown(context.TODO())
}

func NewServer(cfg string) (*Server, error) {
	cf := viper.New()
	cf.SetConfigType("json")
	if err := cf.ReadConfig(strings.NewReader(cfg)); err != nil {
		return nil, err
	}
	path := cf.GetString("path")
	if path == "" {
		return nil, errors.New("app path is required")
	}

	app := New()
	app.Config.Set(config.ServerAddr, "tcp://127.0.0.1:0")
	app.Config.Set(config.LoggerFile, filepath.Join(path, "server.log"))
	app.Config.Set(config.DatabaseDSN, fmt.Sprintf("sqlite://%s", filepath.Join(path, "server.db")))

	if err := app.Init(); err != nil {
		return nil, err
	}

	listener, err := Listen(app.Config.GetString(config.ServerAddr))
	if err != nil {
		return nil, err
	}
	return app.NewServer(listener)
}

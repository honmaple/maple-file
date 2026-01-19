package app

import (
	"context"
	"net"
	"os"
	"strings"

	"github.com/honmaple/maple-file/server/internal/app/config"
	"github.com/honmaple/maple-file/server/pkg/runner"
)

var (
	PROCESS     = "maple-file"
	VERSION     = "dev"
	DESCRIPTION = "Multi-protocol cloud file upload and management with serverless."
)

type (
	App struct {
		ctx    context.Context
		cancel context.CancelFunc

		DB     *DB
		Logger *Logger
		Config *config.Config
		Runner runner.Runner
	}
	Config = config.Config
)

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

func (app *App) Context() context.Context {
	return app.ctx
}

func (app *App) Init() error {
	db, err := NewDB(app.Config)
	if err != nil {
		return err
	}
	app.DB = db
	app.Logger = NewLogger(app.Config)
	app.Runner = runner.New(app.ctx, 20)
	return nil
}

func (app *App) NewServer() (*Server, error) {
	return NewServer(app)
}

func New() *App {
	ctx, cancel := context.WithCancel(context.Background())
	return &App{
		ctx:    ctx,
		cancel: cancel,
		Config: config.New(),
	}
}
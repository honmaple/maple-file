package server

import (
	"github.com/honmaple/maple-file/server/internal/app"

	_ "github.com/honmaple/maple-file/server/internal/api"
	_ "golang.org/x/mobile/bind"
)

var (
	server *app.Server
)

func Start(cfg string) (string, error) {
	if server != nil {
		return server.Addr(), nil
	}

	var err error

	server, err = app.NewServer(cfg)
	if err != nil {
		return "", err
	}
	go server.Start()

	return server.Addr(), nil
}

func Stop() {
	if server != nil {
		server.Shutdown()
	}
	server = nil
}

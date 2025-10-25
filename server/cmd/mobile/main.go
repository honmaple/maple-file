package server

import (
	"github.com/honmaple/maple-file/server/internal/app"

	_ "github.com/honmaple/maple-file/server/internal/api"
	_ "golang.org/x/mobile/bind"
)

func Start(cfg string) (string, error) {
	return app.Start(cfg)
}

func Stop() {
	app.Stop()
}

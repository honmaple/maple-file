package server

import (
	"fmt"
	"path/filepath"
	"strings"

	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/internal/app/config"
	"github.com/spf13/viper"

	_ "github.com/honmaple/maple-file/server/internal/api"

	_ "golang.org/x/mobile/bind"
)

func Start(cfg string) (string, error) {
	cf := viper.New()
	cf.SetConfigType("json")
	if err := cf.ReadConfig(strings.NewReader(cfg)); err != nil {
		return "", err
	}
	path := cf.GetString("path")

	srv := app.New()
	srv.Config.Set(config.ServerAddr, "tcp://127.0.0.1:0")
	srv.Config.Set(config.LoggerFile, filepath.Join(path, "server.log"))
	srv.Config.Set(config.DatabaseDSN, fmt.Sprintf("sqlite://%s", filepath.Join(path, "server.db")))

	if err := srv.Init(); err != nil {
		return "", err
	}

	listener, err := app.Listen(srv.Config.GetString(config.ServerAddr))
	if err != nil {
		return "", err
	}

	go srv.Start(listener, nil)

	return listener.Addr().String(), nil
}

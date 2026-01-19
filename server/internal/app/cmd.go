package app

import (
	"errors"
	"fmt"
	"net/http"
	"path/filepath"
	"strings"

	"github.com/rs/xid"
	"github.com/spf13/viper"

	"github.com/honmaple/maple-file/server/internal/app/config"
)

var (
	_server *Server
	_result string
)

func Start(cfg string) (string, error) {
	if _server != nil {
		return _result, nil
	}
	cf := viper.New()
	cf.SetConfigType("json")
	if err := cf.ReadConfig(strings.NewReader(cfg)); err != nil {
		return "", err
	}
	path := cf.GetString("path")
	if path == "" {
		return "", errors.New("app path is required")
	}

	app := New()
	app.Config.Set(config.ServerAddr, "tcp://127.0.0.1:0")
	app.Config.Set(config.ServerSecretKey, xid.New().String())
	app.Config.Set(config.LoggerFile, filepath.Join(path, "server.log"))
	// app.Config.Set(config.LoggerOutput, "file")
	app.Config.Set(config.DatabaseDSN, fmt.Sprintf("sqlite://%s", filepath.Join(path, "server.db")))
	app.Config.Set(config.ApplicationPath, path)

	if err := app.Init(); err != nil {
		return "", err
	}

	var err error

	_server, err = NewServer(app)
	if err != nil {
		return "", err
	}
	_result, err = _server.Result()
	if err != nil {
		return "", err
	}

	go func() {
		if err := _server.Start(); err != nil && err != http.ErrServerClosed {
			panic(err)
		}
	}()
	return _result, nil
}

func Stop() {
	if _server != nil {
		_server.Shutdown()
	}
	_server = nil
}
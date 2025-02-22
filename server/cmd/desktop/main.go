package main

import "C"
import (
	// "errors"
	"fmt"
	"path/filepath"
	"strings"

	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/internal/app/config"
	"github.com/spf13/viper"

	_ "github.com/honmaple/maple-file/server/internal/api"
)

func main() {}

//export Start
func Start(cfgPtr *C.char) (*C.char, *C.char) {
	if cfgPtr == nil {
		return nil, C.CString("cfg is required")
	}
	cfg := C.GoString(cfgPtr)

	cf := viper.New()
	cf.SetConfigType("json")
	if err := cf.ReadConfig(strings.NewReader(cfg)); err != nil {
		return nil, C.CString(err.Error())
	}
	path := cf.GetString("path")

	srv := app.New()
	srv.Config.Set(config.ServerAddr, "tcp://127.0.0.1:0")
	srv.Config.Set(config.LoggerFile, filepath.Join(path, "server.log"))
	srv.Config.Set(config.DatabaseDSN, fmt.Sprintf("sqlite://%s", filepath.Join(path, "server.db")))

	if err := srv.Init(); err != nil {
		return nil, C.CString(err.Error())
	}

	listener, err := app.Listen(srv.Config.GetString(config.ServerAddr))
	if err != nil {
		return nil, C.CString(err.Error())
	}

	go srv.Start(listener, nil)
	return C.CString(listener.Addr().String()), nil
}

package main

import "C"
import (
	// "errors"
	"fmt"
	"path/filepath"

	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/internal/app/config"

	_ "github.com/honmaple/maple-file/server/internal/api"
)

func main() {}

//export Start
func Start(pathPtr *C.char) (*C.char, *C.char) {
	// m := make(map[string]any)
	// if err := json.Unmarshal([]byte(C.GoString(conf)), &m); err != nil {
	//	return err
	// }
	if pathPtr == nil {
		return nil, C.CString("path is required")
	}
	path := C.GoString(pathPtr)

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

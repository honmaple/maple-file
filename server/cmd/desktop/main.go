package main

import "C"
import (
	"github.com/honmaple/maple-file/server/internal/app"

	_ "github.com/honmaple/maple-file/server/internal/api"
)

func main() {}

var (
	server *app.Server
)

//export Start
func Start(cfgPtr *C.char) (*C.char, *C.char) {
	if server != nil {
		return C.CString(server.Addr()), nil
	}

	if cfgPtr == nil {
		return nil, C.CString("cfg is required")
	}
	cfg := C.GoString(cfgPtr)

	var err error

	server, err = app.NewServer(cfg)
	if err != nil {
		return nil, C.CString(err.Error())
	}
	go server.Start()

	return C.CString(server.Addr()), nil
}

//export Stop
func Stop() {
	if server != nil {
		server.Shutdown()
	}
	server = nil
}

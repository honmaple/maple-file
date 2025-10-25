package main

import "C"
import (
	"github.com/honmaple/maple-file/server/internal/app"

	_ "github.com/honmaple/maple-file/server/internal/api"
)

func main() {}

//export Start
func Start(cfgPtr *C.char) (*C.char, *C.char) {
	if cfgPtr == nil {
		return nil, C.CString("cfg is required")
	}
	cfg := C.GoString(cfgPtr)

	result, err := app.Start(cfg)
	if err != nil {
		return nil, C.CString(err.Error())
	}
	return C.CString(result), nil
}

//export Stop
func Stop() {
	app.Stop()
}

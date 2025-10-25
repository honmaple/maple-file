package app

import (
	"net/http"
)

var (
	_server *Server
	_result string
)

func Start(cfg string) (string, error) {
	if _server != nil {
		return _result, nil
	}

	var err error

	_server, err = NewServer(cfg)
	if err != nil {
		return "", err
	}
	_result = _server.Addr()

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

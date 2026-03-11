package server

import (
	"encoding/json"
	"fmt"

	"github.com/honmaple/maple-file/server/pkg/driver"
)

type (
	Server interface {
		Start() error
		Stop() error
		Status() ServerStatus
	}
	ServerStatus struct {
		Addr    string `json:"addr"`
		Error   string `json:"error"`
		Running bool   `json:"running"`
	}

	Option interface {
		NewServer(fs driver.FS) (Server, error)
	}
	OptionCreator func() Option
)

func New(fs driver.FS, typ string, option string) (Server, error) {
	creator, ok := allOptions[typ]
	if !ok {
		return nil, fmt.Errorf("unknown server type: %s", typ)
	}
	opt := creator()
	if err := json.Unmarshal([]byte(option), opt); err != nil {
		return nil, err
	}
	return opt.NewServer(fs)
}

var allOptions map[string]OptionCreator

func Register(typ string, creator OptionCreator) {
	allOptions[typ] = creator
}

func init() {
	allOptions = make(map[string]OptionCreator)
}

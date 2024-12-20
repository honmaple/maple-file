package fs

import (
	"encoding/json"
	"fmt"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/runner"
)

type (
	Task interface {
		String() string
		Execute(runner.Task) error
	}
	TaskOption interface {
		NewTask(FS) (Task, error)
	}
	TaskOptionCreator func() TaskOption
)

var allOptions map[string]TaskOptionCreator

func NewTask(fs FS, typ string, option string) (Task, error) {
	creator, ok := allOptions[typ]
	if !ok {
		return nil, fmt.Errorf("The task type %s not found", typ)
	}
	opt := creator()
	if err := json.Unmarshal([]byte(option), opt); err != nil {
		return nil, err
	}
	return opt.NewTask(fs)
}

func VerifyTask(typ string, option string) error {
	creator, ok := allOptions[typ]
	if !ok {
		return fmt.Errorf("The task type %s not found", typ)
	}
	opt := creator()
	if err := json.Unmarshal([]byte(option), opt); err != nil {
		return err
	}
	return driver.VerifyOption(opt)
}

func Register(typ string, creator TaskOptionCreator) {
	allOptions[typ] = creator
}

func init() {
	allOptions = make(map[string]TaskOptionCreator)
}

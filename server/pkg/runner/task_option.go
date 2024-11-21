package runner

import (
	"encoding/json"
	"errors"
)

type FuncOption struct {
	Name string
	Func func(Task) error
}

func (opt *FuncOption) Kind() string {
	return "func"
}

func (opt *FuncOption) String() string {
	return opt.Name
}

func (opt *FuncOption) Execute(e Task) error {
	return opt.Func(e)
}

type (
	Option interface {
		String() string
		Execute(Task) error
	}
	OptionCreator func() Option
)

func GetOption(kind string, option string) (Option, error) {
	c, ok := allOptions[kind]
	if !ok {
		return nil, errors.New("task kind is not exists")
	}
	opt := c()
	if err := json.Unmarshal([]byte(option), opt); err != nil {
		return nil, err
	}
	return opt, nil
}

var allOptions map[string]OptionCreator

func Register(typ string, creator OptionCreator) {
	allOptions[typ] = creator
}

func init() {
	allOptions = make(map[string]OptionCreator)
}

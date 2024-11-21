package driver

import (
	"context"
	"encoding/json"
	"fmt"
)

type (
	FS interface {
		WalkDir(context.Context, string, WalkDirFunc) error
		List(context.Context, string) ([]File, error)
		Move(context.Context, string, string) error
		Copy(context.Context, string, string) error
		Rename(context.Context, string, string) error
		Remove(context.Context, string) error
		MakeDir(context.Context, string) error
		Get(string) (File, error)
		Open(string) (FileReader, error)
		Create(string) (FileWriter, error)
	}
	WalkDirFunc func(File, error) error

	Option interface {
		NewFS() (FS, error)
	}
	OptionCreator func() Option
)

type Base struct{}

func (Base) WalkDir(context.Context, string, WalkDirFunc) error { return ErrNotSupport }
func (Base) List(context.Context, string) ([]File, error)       { return nil, ErrNotSupport }
func (Base) Move(context.Context, string, string) error         { return ErrNotSupport }
func (Base) Copy(context.Context, string, string) error         { return ErrNotSupport }
func (Base) Rename(context.Context, string, string) error       { return ErrNotSupport }
func (Base) Remove(context.Context, string) error               { return ErrNotSupport }
func (Base) MakeDir(context.Context, string) error              { return ErrNotSupport }
func (Base) Get(string) (File, error)                           { return nil, ErrNotSupport }
func (Base) Open(string) (FileReader, error)                    { return nil, ErrNotSupport }
func (Base) Create(string) (FileWriter, error)                  { return nil, ErrNotSupport }

var allOptions map[string]OptionCreator

func VerifyOption(driver string, option string) error {
	creator, ok := allOptions[driver]
	if !ok {
		return fmt.Errorf("The driver %s not found", driver)
	}
	opt := creator()
	return json.Unmarshal([]byte(option), opt)
}

func DriverFS(driver string, option string) (FS, error) {
	creator, ok := allOptions[driver]
	if !ok {
		return nil, fmt.Errorf("The driver %s not found", driver)
	}
	opt := creator()
	if err := json.Unmarshal([]byte(option), opt); err != nil {
		return nil, err
	}
	return opt.NewFS()
}

func Exists(typ string) bool {
	_, ok := allOptions[typ]
	return ok
}

func Register(typ string, creator OptionCreator) {
	allOptions[typ] = creator
}

func init() {
	allOptions = make(map[string]OptionCreator)
}

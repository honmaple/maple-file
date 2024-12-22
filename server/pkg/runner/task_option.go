package runner

import (
	"encoding/json"
	"fmt"

	"github.com/honmaple/maple-file/server/pkg/util"
)

type (
	Option interface {
		NewTask() Task
	}

	FuncOption interface {
		String() string
		Execute(Task) error
	}
	FuncOptionCreator func() FuncOption

	FuncOptionWithArg[T any] interface {
		String() string
		Execute(Task, T) error
	}
)

type funcOptionWithArg[T any] struct {
	// `json:",inline"` 对于任意类型any无效，必须自定义解析
	FuncOptionWithArg[T]
	arg T
}

func (opt *funcOptionWithArg[T]) Execute(task Task) error {
	return opt.FuncOptionWithArg.Execute(task, opt.arg)
}

func (opt *funcOptionWithArg[T]) UnmarshalJSON(data []byte) error {
	return json.Unmarshal(data, opt.FuncOptionWithArg)
}

func (opt funcOptionWithArg[T]) MarshalJSON() ([]byte, error) {
	return json.Marshal(opt.FuncOptionWithArg)
}

func NewFuncOptionWithArg[T any](opt FuncOptionWithArg[T], arg T) *funcOptionWithArg[T] {
	return &funcOptionWithArg[T]{opt, arg}
}

var allFuncOptions map[string]FuncOptionCreator

func NewFuncOption(typ string, option string) (FuncOption, error) {
	creator, ok := allFuncOptions[typ]
	if !ok {
		return nil, fmt.Errorf("The task type %s not found", typ)
	}
	opt := creator()
	if err := json.Unmarshal([]byte(option), opt); err != nil {
		return nil, err
	}
	return opt, nil
}

func Verify(typ string, option string) error {
	creator, ok := allFuncOptions[typ]
	if !ok {
		return fmt.Errorf("The task type %s not found", typ)
	}
	opt := creator()
	if err := json.Unmarshal([]byte(option), opt); err != nil {
		return err
	}
	return util.VerifyOption(opt)
}

func Register(typ string, creator FuncOptionCreator) {
	allFuncOptions[typ] = creator
}

func init() {
	allFuncOptions = make(map[string]FuncOptionCreator)
}

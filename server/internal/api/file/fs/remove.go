package fs

import (
	"fmt"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/runner"
)

type RemoveTaskOption struct {
	Path string `json:"path"`
}

func (opt *RemoveTaskOption) NewTask(fs FS) (Task, error) {
	return NewRemoveTask(fs, opt)
}

type RemoveTask struct {
	fs  FS
	opt *RemoveTaskOption
}

func (t *RemoveTask) String() string {
	return fmt.Sprintf("删除 [%s]", t.opt.Path)
}

func (t *RemoveTask) Execute(task runner.Task) error {
	return t.fs.Remove(task.Context(), t.opt.Path)
}

func NewRemoveTask(fs FS, opt *RemoveTaskOption) (Task, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}
	return &RemoveTask{
		fs:  fs,
		opt: opt,
	}, nil
}

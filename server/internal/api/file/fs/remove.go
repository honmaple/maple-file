package fs

import (
	"fmt"

	"github.com/honmaple/maple-file/server/pkg/runner"
)

type RemoveTask struct {
	FS   FS     `json:"fs"`
	Path string `json:"path"`
}

func (opt *RemoveTask) String() string {
	return fmt.Sprintf("删除 [%s]", opt.Path)
}

func (opt *RemoveTask) Execute(task runner.Task) error {
	return opt.FS.Remove(task.Context(), opt.Path)
}

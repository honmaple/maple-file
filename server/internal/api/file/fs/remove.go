package fs

import (
	"fmt"

	"github.com/honmaple/maple-file/server/pkg/runner"
)

type RemoveTaskOption struct {
	Path string `json:"path"`
}

func (opt *RemoveTaskOption) String() string {
	return fmt.Sprintf("删除 [%s]", opt.Path)
}

func (opt *RemoveTaskOption) Execute(task runner.Task, fs FS) error {
	return fs.Remove(task.Context(), opt.Path)
}

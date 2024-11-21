package fs

import (
	"fmt"

	"github.com/honmaple/maple-file/server/pkg/runner"
	"path/filepath"
)

type RemoveOption struct {
	FS   FS     `json:"fs"`
	Path string `json:"path"`
}

func (opt *RemoveOption) Kind() string {
	return "remove"
}

func (opt *RemoveOption) String() string {
	return fmt.Sprintf("删除 [%s]", filepath.Join(opt.FS.MountPath(), opt.Path))
}

func (opt *RemoveOption) Execute(task runner.Task) error {
	return opt.FS.Remove(task.Context(), opt.Path)
}

package fs

import (
	"fmt"
	"io"
	"path/filepath"

	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type UploadTask struct {
	FS       FS        `json:"fs"`
	Path     string    `json:"path"`
	Size     int64     `json:"size"`
	Filename string    `json:"filename"`
	Reader   io.Reader `json:"reader"`
}

func (opt *UploadTask) String() string {
	return fmt.Sprintf("上传 [%s] 到 [%s]", opt.Filename, opt.Path)
}

func (opt *UploadTask) Execute(task runner.Task) error {
	dst, err := opt.FS.Create(filepath.Join(opt.Path, opt.Filename))
	if err != nil {
		return err
	}
	defer dst.Close()

	fsize := util.PrettyByteSize(int(opt.Size))

	task.SetProgressState(fmt.Sprintf("0/%s", fsize))

	_, err = util.Copy(task.Context(), dst, opt.Reader, func(progress int64) {
		if size := opt.Size; size > 0 {
			task.SetProgress(float64(progress) / float64(size))
		}
		task.SetProgressState(fmt.Sprintf("%s/%s", util.PrettyByteSize(int(progress)), fsize))
	})
	return err
}

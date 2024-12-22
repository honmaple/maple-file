package fs

import (
	"errors"
	"fmt"
	"io"

	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type DownloadTask struct {
	Path   string    `json:"path"`
	Writer io.Writer `json:"file"`
}

func (opt *DownloadTask) String() string {
	return fmt.Sprintf("下载 [%s]", opt.Path)
}

func (opt *DownloadTask) Execute(task runner.Task, fs FS) error {
	info, err := fs.Get(opt.Path)
	if err != nil {
		return err
	}
	if info.IsDir() {
		// TODO 打包后下载
		return errors.New("can't download dir")
	}

	src, err := fs.Open(opt.Path)
	if err != nil {
		return err
	}
	defer src.Close()

	fsize := util.PrettyByteSize(int(info.Size()))

	task.SetProgressState(fmt.Sprintf("0/%s", fsize))

	_, err = util.Copy(task.Context(), opt.Writer, src, func(progress int64) {
		if size := info.Size(); size > 0 {
			task.SetProgress(float64(progress) / float64(size))
		}
		task.SetProgressState(fmt.Sprintf("%s/%s", util.PrettyByteSize(int(progress)), fsize))
	})
	return err
}

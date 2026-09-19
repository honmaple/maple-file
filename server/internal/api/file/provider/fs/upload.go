package fs

import (
	"errors"
	"fmt"
	"io"
	stdpath "path"

	"github.com/honmaple/cloudfs"
	"github.com/honmaple/maple-file/server/internal/platform/runner"
	"github.com/honmaple/maple-file/server/internal/platform/utils/ioutil"
)

type UploadTask struct {
	Path     string    `json:"path"`
	Size     int64     `json:"size"`
	Filename string    `json:"filename"`
	Reader   io.Reader `json:"reader"`
}

func (opt *UploadTask) String() string {
	return fmt.Sprintf("上传 [%s] 到 [%s]", opt.Filename, opt.Path)
}

func (opt *UploadTask) Execute(task runner.Task, fs FS) error {
	dstFS, dstPath, err := fs.GetFS(stdpath.Join(opt.Path, opt.Filename))
	if err != nil {
		return err
	}
	return opt.upload(task, dstFS, dstPath)
}

func (opt *UploadTask) upload(task runner.Task, fs cloudfs.FS, path string) error {
	dst, err := fs.Create(task.Context(), path)
	if err != nil {
		return err
	}

	fsize := ioutil.PrettyByteSize(int(opt.Size))

	task.SetProgressState(fmt.Sprintf("0/%s", fsize))

	written, err := ioutil.Copy(task.Context(), dst, opt.Reader, func(progress int64) {
		if size := opt.Size; size > 0 {
			task.SetProgress(float64(progress) / float64(size))
		}
		task.SetProgressState(fmt.Sprintf("%s/%s", ioutil.PrettyByteSize(int(progress)), fsize))
	})
	if err == nil && written != opt.Size {
		err = fmt.Errorf("上传数据长度不匹配：收到 %d 字节，预期 %d 字节", written, opt.Size)
	}
	return errors.Join(err, dst.Close())
}

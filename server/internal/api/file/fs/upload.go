package fs

import (
	"fmt"
	"mime/multipart"
	"path/filepath"

	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type UploadOption struct {
	FS   FS                   `json:"fs"`
	Path string               `json:"path"`
	File multipart.FileHeader `json:"file"`
}

func (opt *UploadOption) Kind() string {
	return "copy"
}

func (opt *UploadOption) String() string {
	return ""
}

func (opt *UploadOption) Execute(task runner.Task) error {
	src, err := opt.File.Open()
	if err != nil {
		return err
	}
	defer src.Close()

	dst, err := opt.FS.Create(filepath.Join(opt.Path, opt.File.Filename))
	if err != nil {
		return err
	}
	defer dst.Close()

	fsize := util.PrettyByteSize(int(opt.File.Size))

	task.SetProgressState(fmt.Sprintf("0/%s", fsize))

	_, err = util.Copy(task.Context(), dst, src, func(progress int64) {
		if size := opt.File.Size; size > 0 {
			task.SetProgress(float64(progress) / float64(size))
		}
		task.SetProgressState(fmt.Sprintf("%s/%s", util.PrettyByteSize(int(progress)), fsize))
	})
	if err != nil {
		return err
	}
	return nil
}

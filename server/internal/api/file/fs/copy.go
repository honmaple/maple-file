package fs

import (
	"fmt"
	"os"
	filepath "path"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type CopyTaskOption struct {
	SrcPath  string `json:"src_path"`
	DstPath  string `json:"dst_path"`
	Override bool   `json:"override"`
}

func (opt *CopyTaskOption) String() string {
	return fmt.Sprintf("复制 [%s] to [%s]", opt.SrcPath, opt.DstPath)
}

func (opt *CopyTaskOption) Execute(task runner.Task, fs FS) error {
	srcFS, srcPath, err := fs.GetFS(opt.SrcPath)
	if err != nil {
		return err
	}

	dstFS, dstPath, err := fs.GetFS(opt.DstPath)
	if err != nil {
		return err
	}

	if srcFS == dstFS {
		return srcFS.Copy(task.Context(), srcPath, dstPath)
	}
	return _copy(task, srcFS, srcPath, dstFS, dstPath)
}

func _copy(task runner.Task, srcFS driver.FS, srcPath string, dstFS driver.FS, dstPath string) error {
	ctx := task.Context()

	dstFile, err := dstFS.Get(ctx, dstPath)
	if err != nil {
		if !os.IsNotExist(err) {
			return err
		}
		// 目标目录不存在时优先创建
		if err := dstFS.MakeDir(ctx, dstPath); err != nil {
			return err
		}
	} else if !dstFile.IsDir() {
		return fmt.Errorf("无法复制文件")
	}

	srcFile, err := srcFS.Get(ctx, srcPath)
	if err != nil {
		return err
	}

	if !srcFile.IsDir() {
		src, err := srcFS.Open(srcPath)
		if err != nil {
			return err
		}
		defer src.Close()

		dst, err := dstFS.Create(filepath.Join(dstPath, srcFile.Name()))
		if err != nil {
			return err
		}
		defer dst.Close()

		var (
			totalSize = srcFile.Size()
		)

		setProgress := func(progress int64) {
			if totalSize > 0 {
				task.SetProgress(float64(progress) / float64(totalSize))
			}
		}
		_, err = util.Copy(ctx, dst, src, setProgress)
		return err
	}

	files, err := srcFS.List(ctx, srcPath)
	if err != nil {
		return err
	}

	for _, file := range files {
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
			src := filepath.Join(srcPath, file.Name())
			dst := filepath.Join(dstPath, srcFile.Name())
			if err := _copy(task, srcFS, src, dstFS, dst); err != nil {
				return err
			}
		}
	}
	return nil
}

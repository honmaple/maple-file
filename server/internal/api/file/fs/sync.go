package fs

import (
	"fmt"
	"os"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/runner"
)

type SyncOption struct {
	SrcFS   FS
	SrcPath string `json:"src_path"`
	DstFS   FS
	DstPath string `json:"dst_path"`
}

func (opt *SyncOption) Kind() string {
	return "sync"
}

func (opt *SyncOption) String() string {
	return fmt.Sprintf("Sync [%s] to [%s]", opt.SrcPath, opt.DstPath)
}

func (opt *SyncOption) Execute(task runner.Task) error {
	return _sync(task, opt.SrcFS, opt.SrcPath, opt.DstFS, opt.DstPath)
}

func _sync(task runner.Task, srcFS driver.FS, srcPath string, dstFS driver.FS, dstPath string) error {
	ctx := task.Context()

	dstFile, err := dstFS.Get(dstPath)
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

	srcFile, err := srcFS.Get(srcPath)
	if err != nil {
		return err
	}

	if !srcFile.IsDir() {
	}

	var totalSize int64

	srcFiles := make(map[string]driver.File)
	if err := srcFS.WalkDir(ctx, srcPath, func(file driver.File, err error) error {
		if err != nil {
			return err
		}
		if !file.IsDir() {
			totalSize += file.Size()
		}
		srcFiles[strings.TrimPrefix(file.Path(), srcPath)] = file
		return nil
	}); err != nil {
		return err
	}

	dstFiles := make(map[string]driver.File)
	if err := dstFS.WalkDir(ctx, dstPath, func(file driver.File, err error) error {
		if err != nil {
			return err
		}
		dstFiles[strings.TrimPrefix(file.Path(), dstPath)] = file
		return nil
	}); err != nil {
		return err
	}

	addFiles := make(chan driver.File)
	modFiles := make(chan driver.File)
	delFiles := make(chan driver.File)
	for path, srcFile := range srcFiles {
		dstFile, ok := dstFiles[path]
		if !ok {
			addFiles <- srcFile
			continue
		}
		if !driver.Compare(srcFile, dstFile) {
			modFiles <- srcFile
		}
	}

	for path, dstFile := range dstFiles {
		_, ok := srcFiles[path]
		if !ok {
			delFiles <- dstFile
		}
	}

	for {
		select {
		case <-addFiles:
		case <-modFiles:
		case <-delFiles:
		case <-ctx.Done():
			return ctx.Err()
		}
	}
	return nil
}

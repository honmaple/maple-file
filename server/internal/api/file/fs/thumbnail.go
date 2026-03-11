package fs

import (
	"errors"
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/djherbis/times"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/thumbnail"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type ThumbTaskOption struct {
	Path          string `json:"path"`
	ThumbFilePath string `json:"thumb_file_path"`

	Width   int `json:"width"`
	Height  int `json:"height"`
	Quality int `json:"quality"`
}

func (opt *ThumbTaskOption) String() string {
	return fmt.Sprintf("生成缩略图 [%s]", opt.Path)
}

func (opt *ThumbTaskOption) Execute(task runner.Task, fs FS) error {
	info, err := fs.Get(task.Context(), opt.Path)
	if err != nil {
		return err
	}
	return opt.generateThumb(task, fs, info)
}

func (opt *ThumbTaskOption) generateThumb(task runner.Task, fs driver.FS, info driver.File) error {
	ctx := task.Context()

	// 临时限制,只生成图片缩略图
	if info.IsDir() {
		return errors.New("can't generate thumb for dir")
	}
	if !strings.HasPrefix(info.Type(), "image/") {
		return errors.New("can't generate thumb for not image")
	}
	if info.Size() > 1024*1024*100 {
		return errors.New("file is too large")
	}

	thumbPath := opt.ThumbFilePath

	if _, err := os.Stat(filepath.Dir(thumbPath)); err != nil && os.IsNotExist(err) {
		if err := os.MkdirAll(filepath.Dir(thumbPath), 0755); err != nil {
			return err
		}
	}

	file, err := fs.Open(opt.Path)
	if err != nil {
		return err
	}
	defer file.Close()

	img, err := thumbnail.NewImageGenerator(&thumbnail.ImageOption{
		Width:   opt.Width,
		Height:  opt.Height,
		Quality: opt.Quality,
	})
	if err != nil {
		return err
	}

	r, err := img.Generate(ctx, file, info.Size())
	if err != nil {
		return err
	}
	defer r.Close()

	thumbFile, err := os.Create(thumbPath)
	if err != nil {
		return err
	}
	defer func() {
		thumbFile.Close()
		os.Chtimes(thumbPath, time.Now(), info.ModTime())
	}()

	totalSize := info.Size()
	setProgress := func(progress int64) {
		if totalSize > 0 {
			task.SetProgress(float64(progress) / float64(totalSize))
		}
	}
	_, err = util.Copy(ctx, thumbFile, r, setProgress)
	return err
}

type ThumbCleanTaskOption struct {
	ThumbPath  string        `json:"thumb_path"`
	ExpireTime time.Duration `json:"expire_time"`
}

func (opt *ThumbCleanTaskOption) String() string {
	return "清理缩略图"
}

func (opt *ThumbCleanTaskOption) Execute(task runner.Task) error {
	// 过期时间设置为一个月
	if opt.ExpireTime <= 0 {
		opt.ExpireTime = 24 * 30
	}
	expireTime := time.Now().Add(-time.Hour * opt.ExpireTime)

	count := 0
	defer func() {
		task.SetProgressState(fmt.Sprintf("已成功清理%d张缩略图", count))
	}()
	return fs.WalkDir(os.DirFS(opt.ThumbPath), ".", func(path string, entry fs.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if entry.IsDir() {
			return nil
		}

		info, err := entry.Info()
		if err != nil {
			return err
		}

		spec := times.Get(info)

		accessTime := spec.AccessTime()
		if !accessTime.IsZero() && accessTime.Before(expireTime) {
			count++
			task.SetProgressState(fmt.Sprintf("清理缩略图 [%s]", path))
			return os.Remove(filepath.Join(opt.ThumbPath, path))
		}
		return nil
	})
}

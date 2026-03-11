package service

import (
	"context"
	"crypto/md5"
	"errors"
	"fmt"
	"os"
	stdpath "path"
	"path/filepath"
	"strings"

	"github.com/honmaple/maple-file/server/internal/api/file/fs"
	"github.com/honmaple/maple-file/server/internal/app/config"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/spf13/viper"
)

func (srv *Service) thumbHash(path string) string {
	hash := md5.Sum([]byte(path))
	return fmt.Sprintf("%x", hash)
}

func (srv *Service) thumbPath() string {
	return filepath.Join(srv.app.Config.GetString(config.ApplicationPath), "thumbnail")
}

func (srv *Service) thumbFile(ctx context.Context, path string, info driver.File) (string, error) {
	if info.IsDir() {
		return "", errors.New("can't generate thumb for dir")
	}
	if !strings.HasPrefix(info.Type(), "image/") {
		return "", errors.New("can't generate thumb for not image")
	}

	thumbPath := filepath.Join(srv.thumbPath(), "thumb_"+srv.thumbHash(path)+stdpath.Ext(path))

	// 重新生成缩略图
	regenerate := false

	stat, err := os.Stat(thumbPath)
	if err != nil {
		if !os.IsNotExist(err) {
			return "", err
		}
		regenerate = true
	} else if stat.ModTime().Compare(info.ModTime()) != 0 {
		regenerate = true
	}

	if regenerate {
		setting, err := srv.getSetting(ctx, "app.file")
		if err != nil {
			setting = viper.New()
		}
		task := srv.fs.SubmitTask(&fs.ThumbTaskOption{
			Path:          path,
			ThumbFilePath: thumbPath,
			Width:         setting.GetInt("thumb.width"),
			Height:        setting.GetInt("thumb.height"),
			Quality:       setting.GetInt("thumb.quality"),
		})
		<-task.Done()

		if err := task.Err(); err != nil {
			return "", err
		}
	}
	return thumbPath, nil
}

func (srv *Service) cleanThumbFile() {
	ctx := context.TODO()
	setting, err := srv.getSetting(ctx, "app.file")
	if err != nil {
		setting = viper.New()
	}

	if setting.GetBool("thumb.auto_clean") {
		srv.app.Runner.SubmitByOption(&fs.ThumbCleanTaskOption{
			ThumbPath:  srv.thumbPath(),
			ExpireTime: 24 * 30,
		})
	}
}

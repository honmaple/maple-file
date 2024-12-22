package fs

import (
	"fmt"

	"io"
	"path/filepath"
	"strings"
	"time"

	"github.com/elliotchance/orderedmap/v3"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"
)

const (
	// 源目录 -> 目标目录
	METHOD_A2B = "a2b"
	// 目标目录 -> 源目录
	METHOD_B2A = "b2a"
	// 双向同步
	METHOD_B2B = "b2b"
)

const (
	CONFLICT_SKIP     = "skip"
	CONFLICT_NEWEST   = "newest"
	CONFLICT_OVERRIDE = "override"
)

type syncFile struct {
	path    string
	srcFile driver.File
	dstFile driver.File
	makeDir bool
}

type syncInfo struct {
	files *orderedmap.OrderedMap[string, driver.File]
}

type SyncTaskOption struct {
	SrcPath   string   `json:"src_path"    validate:"required,startswith=/,nefield=DstPath"`
	DstPath   string   `json:"dst_path"    validate:"required,startswith=/,nefield=SrcPath"`
	Method    string   `json:"method"      validate:"required,oneof=a2b b2a b2b"`
	Conflict  string   `json:"conflict"    validate:"required,oneof=skip newest override"`
	DeleteSrc bool     `json:"delete_src"`
	DeleteDst bool     `json:"delete_dst"`
	FileTypes []string `json:"file_types"`
	// 保持原有路径，或者按照时间格式重新整理
	CustomPath string `json:"custom_path" validate:"omitempty,startsnotwith=/"`
}

func (opt *SyncTaskOption) String() string {
	return fmt.Sprintf("同步 [%s] to [%s]", opt.SrcPath, opt.DstPath)
}

func (opt *SyncTaskOption) Execute(task runner.Task, fs FS) error {
	t, err := NewSyncTask(task, fs, opt)
	if err != nil {
		return err
	}
	return t.Run()
}

type SyncTask struct {
	fs   FS
	opt  *SyncTaskOption
	task runner.Task

	addFiles chan *syncFile
	modFiles chan *syncFile
	delFiles chan *syncFile
}

func isIncluded(file driver.File, types []string) bool {
	if len(types) == 0 {
		return true
	}
	ext := filepath.Ext(file.Name())
	for _, typ := range types {
		exclude := false
		if strings.HasPrefix(typ, "-") {
			typ = typ[1:]
			exclude = true
		}
		if ext == typ {
			return !exclude
		}

		name := file.Name()
		if strings.Contains(typ, "/") {
			name = strings.TrimPrefix(filepath.Join(file.Path(), name), "/")
		}
		if m, _ := filepath.Match(typ, name); m {
			return !exclude
		}
	}
	return false
}

func (t *SyncTask) lastinfo(root string) (*syncInfo, error) {
	file := filepath.Join(root, ".maplefile")

	r, err := t.fs.Open(file)
	if err != nil {
		return nil, err
	}
	defer r.Close()

	return nil, nil
}

func (t *SyncTask) info(root string) (*syncInfo, error) {
	info := &syncInfo{
		files: orderedmap.NewOrderedMap[string, driver.File](),
	}
	if err := driver.WalkDir(t.task.Context(), t.fs, root, func(_ string, file driver.File, err error) error {
		if err != nil {
			return err
		}
		path := strings.TrimPrefix(filepath.Join(file.Path(), file.Name()), root)
		if file.IsDir() {
			info.files.Set(path, file)
			return nil
		}
		if isIncluded(file, t.opt.FileTypes) {
			info.files.Set(path, file)
		}
		return nil
	}); err != nil {
		return nil, err
	}
	return info, nil
}

func (t *SyncTask) addFile(s *syncFile) error {
	srcPath := filepath.Join(s.srcFile.Path(), s.srcFile.Name())
	dstPath := filepath.Join(t.opt.DstPath, s.path)

	if s.makeDir {
		dstDir := filepath.Dir(dstPath)
		t.task.SetProgressState(fmt.Sprintf("[创建目录] [%s]", dstDir))

		if !t.task.DryRun() {
			if err := t.fs.MakeDir(t.task.Context(), dstDir); err != nil {
				return err
			}
		}
	}
	t.task.SetProgressState(fmt.Sprintf("[新增文件] [%s] 到 [%s]", srcPath, dstPath))
	if t.task.DryRun() {
		return nil
	}

	srcFile, err := t.fs.Open(srcPath)
	if err != nil {
		return err
	}
	defer srcFile.Close()

	dstFile, err := t.fs.Create(dstPath)
	if err != nil {
		return err
	}
	defer dstFile.Close()

	_, err = io.Copy(dstFile, srcFile)
	return err
}

func (t *SyncTask) modFile(s *syncFile) error {
	srcPath := filepath.Join(s.srcFile.Path(), s.srcFile.Name())

	t.task.SetProgressState(fmt.Sprintf("[修改文件] [%s]", srcPath))

	switch t.opt.Conflict {
	case CONFLICT_OVERRIDE:
		return t.addFile(s)
	case CONFLICT_NEWEST:
		if s.srcFile.ModTime().After(s.dstFile.ModTime()) {
			return t.addFile(s)
		}
	case CONFLICT_SKIP:
	}
	return nil
}

func (t *SyncTask) delFile(s *syncFile) error {
	dstPath := filepath.Join(s.dstFile.Path(), s.dstFile.Name())

	t.task.SetProgressState(fmt.Sprintf("[删除文件] [%s]", dstPath))
	if t.task.DryRun() || true {
		return nil
	}

	switch t.opt.Method {
	case METHOD_A2B:
		if t.opt.DeleteDst {
			return t.fs.Remove(t.task.Context(), dstPath)
		}
	case METHOD_B2A:
		if t.opt.DeleteSrc {
			return t.fs.Remove(t.task.Context(), dstPath)
		}
	case METHOD_B2B:
	}
	return nil
}

func (t *SyncTask) a2b(src, dst *syncInfo) {
	dirs := make(map[string]bool)

	for path, srcFile := range src.files.AllFromFront() {
		if srcFile.IsDir() {
			continue
		}
		if t.opt.CustomPath != "" {
			filename := srcFile.Name()
			ext := filepath.Ext(filename)

			now := srcFile.ModTime()
			if now.IsZero() {
				now = time.Now()
			}
			newPath := util.StrReplace(t.opt.CustomPath, map[string]string{
				"{rawpath}":     filepath.Dir(path),
				"{extension}":   ext,
				"{filename}":    filename[:len(filename)-len(ext)],
				"{time:year}":   now.Format("2006"),
				"{time:month}":  now.Format("01"),
				"{time:day}":    now.Format("02"),
				"{time:hour}":   now.Format("15"),
				"{time:minute}": now.Format("04"),
			})
			if newPath != path {
				src.files.ReplaceKey(path, newPath)

				path = newPath
			}
		}

		dstFile, ok := dst.files.Get(path)
		if !ok {
			// 检查目录是否存在, 不存在则创建
			dstDir := filepath.Dir(path)

			_, dirok := dst.files.Get(dstDir)
			if !dirok {
				dirok = dirs[dstDir]
				dirs[dstDir] = true
			}

			t.addFiles <- &syncFile{
				path:    path,
				srcFile: srcFile,
				makeDir: !dirok,
			}
			continue
		}
		if srcFile.Size() != dstFile.Size() || !srcFile.ModTime().Equal(dstFile.ModTime()) {
			t.modFiles <- &syncFile{path: path, srcFile: srcFile, dstFile: dstFile}
		}
	}

	for path, dstFile := range dst.files.AllFromFront() {
		if dstFile.IsDir() {
			continue
		}
		_, ok := src.files.Get(path)
		if !ok {
			t.delFiles <- &syncFile{path: path, dstFile: dstFile}
		}
	}
}

// TODO
func (t *SyncTask) b2b(src, dst *syncInfo) {
}

func (t *SyncTask) Run() error {
	srcInfo, err := t.info(t.opt.SrcPath)
	if err != nil {
		return err
	}

	dstInfo, err := t.info(t.opt.DstPath)
	if err != nil {
		return err
	}

	donec := make(chan struct{})
	go func() {
		switch t.opt.Method {
		case METHOD_A2B:
			t.a2b(srcInfo, dstInfo)
		case METHOD_B2A:
			t.a2b(dstInfo, srcInfo)
		case METHOD_B2B:
			t.b2b(srcInfo, dstInfo)
		}
		close(donec)
	}()

	ctx := t.task.Context()
	for {
		select {
		case file := <-t.addFiles:
			err = t.addFile(file)
		case file := <-t.modFiles:
			err = t.modFile(file)
		case file := <-t.delFiles:
			err = t.delFile(file)
		case <-ctx.Done():
			err = ctx.Err()
		case <-donec:
			return nil
		}
		if err != nil {
			return err
		}
	}
}

func NewSyncTask(task runner.Task, fs FS, opt *SyncTaskOption) (Task, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	t := &SyncTask{
		fs:       fs,
		opt:      opt,
		task:     task,
		addFiles: make(chan *syncFile),
		modFiles: make(chan *syncFile),
		delFiles: make(chan *syncFile),
	}
	return t, nil
}

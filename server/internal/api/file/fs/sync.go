package fs

import (
	"fmt"
	// "io"
	"path/filepath"
	"strings"
	"time"

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
}

type syncInfo struct {
	files map[string]driver.File
}

type SyncTaskOption struct {
	SrcPath    string   `json:"src_path"`
	DstPath    string   `json:"dst_path"`
	Method     string   `json:"method"`
	Conflict   string   `json:"conflict"`
	DeleteSrc  bool     `json:"delete_src"`
	DeleteDst  bool     `json:"delete_dst"`
	CustomPath string   `json:"custom_path"` // 保持原有路径，或者按照时间格式重新整理
	FileTypes  []string `json:"file_types"`
}

func (opt *SyncTaskOption) NewTask(fs FS) (Task, error) {
	return NewSyncTask(fs, opt)
}

// 照片，视频文件同步
type SyncTask struct {
	fs   FS `json:"-"`
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
	_ = r
	return nil, nil
}

func (t *SyncTask) info(root string) (*syncInfo, error) {
	info := &syncInfo{
		files: make(map[string]driver.File),
	}
	if err := driver.WalkDir(t.task.Context(), t.fs, root, func(_ string, file driver.File, err error) error {
		if err != nil {
			return err
		}
		if file.IsDir() {
			return nil
		}
		if isIncluded(file, t.opt.FileTypes) {
			// 格式为空时保持原有路径
			path := strings.TrimPrefix(filepath.Join(file.Path(), file.Name()), root)
			if t.opt.Method == METHOD_A2B && t.opt.CustomPath != "" {
				filename := file.Name()
				ext := filepath.Ext(filename)

				now := file.ModTime()
				if now.IsZero() {
					now = time.Now()
				}
				path = util.StrReplace(t.opt.CustomPath, map[string]string{
					"{extension}":   ext,
					"{filename}":    filename[:len(filename)-len(ext)],
					"{time:year}":   now.Format("2006"),
					"{time:month}":  now.Format("01"),
					"{time:day}":    now.Format("02"),
					"{time:hour}":   now.Format("15"),
					"{time:minute}": now.Format("04"),
				})
			}
			info.files[path] = file
		}
		return nil
	}); err != nil {
		return nil, err
	}
	return info, nil
}

func (t *SyncTask) addFile(task runner.Task, s *syncFile) error {
	srcPath := filepath.Join(s.srcFile.Path(), s.srcFile.Name())
	task.SetProgressState(fmt.Sprintf("正在同步[新增文件] [%s]", srcPath))

	// srcFile, err := t.fs.Open(srcPath)
	// if err != nil {
	//	return err
	// }
	// defer srcFile.Close()

	// // 需要创建目录
	// dstPath := filepath.Join(t.opt.DstPath, s.path)

	// dstFile, err := t.fs.Create(dstPath)
	// if err != nil {
	//	return err
	// }
	// defer dstFile.Close()

	// _, err = io.Copy(dstFile, srcFile)
	// return err
	return nil
}

func (t *SyncTask) modFile(task runner.Task, s *syncFile) error {
	srcPath := filepath.Join(s.srcFile.Path(), s.srcFile.Name())

	task.SetProgressState(fmt.Sprintf("正在同步[修改文件] [%s]", srcPath))

	switch t.opt.Conflict {
	case CONFLICT_OVERRIDE:
		// if t.opt.Method != METHOD_B2B {
		//	return t.addFile(task, s)
		// }
		// fallthrough
	case CONFLICT_NEWEST:
		if s.srcFile.ModTime().After(s.dstFile.ModTime()) {
			return t.addFile(task, s)
		}
	case CONFLICT_SKIP:
	}
	return nil
}

func (t *SyncTask) delFile(task runner.Task, s *syncFile) error {
	dstPath := filepath.Join(s.dstFile.Path(), s.dstFile.Name())

	task.SetProgressState(fmt.Sprintf("正在同步[删除文件] [%s]", dstPath))

	// switch t.opt.Method {
	// case METHOD_A2B:
	//	if t.opt.DeleteDst {
	//		return t.fs.Remove(task.Context(), dstPath)
	//	}
	// case METHOD_B2A:
	//	if t.opt.DeleteSrc {
	//		return t.fs.Remove(task.Context(), dstPath)
	//	}
	// case METHOD_B2B:
	// }
	return nil
}

func (t *SyncTask) a2b(src, dst *syncInfo) {
	for path, srcFile := range src.files {
		dstFile, ok := dst.files[path]
		if !ok {
			t.addFiles <- &syncFile{path, srcFile, nil}
			continue
		}
		if srcFile.Size() != dstFile.Size() || !srcFile.ModTime().Equal(dstFile.ModTime()) {
			t.modFiles <- &syncFile{path, srcFile, dstFile}
		}
	}

	for path, dstFile := range dst.files {
		_, ok := src.files[path]
		if !ok {
			t.delFiles <- &syncFile{path, nil, dstFile}
		}
	}
}

// TODO
func (t *SyncTask) b2b(src, dst *syncInfo) {
}

func (t *SyncTask) Execute(task runner.Task) error {
	srcInfo, err := t.info(t.opt.SrcPath)
	if err != nil {
		return err
	}

	dstInfo, err := t.info(t.opt.DstPath)
	if err != nil {
		return err
	}

	ctx := task.Context()
	errs := make(chan error)
	go func() {
		for {
			select {
			case file := <-t.addFiles:
				err = t.addFile(task, file)
			case file := <-t.modFiles:
				err = t.modFile(task, file)
			case file := <-t.delFiles:
				err = t.delFile(task, file)
			case <-ctx.Done():
				errs <- ctx.Err()
				return
			}
			if err != nil {
				errs <- err
				return
			}
		}
	}()

	switch t.opt.Method {
	case METHOD_A2B:
		t.a2b(srcInfo, dstInfo)
	case METHOD_B2A:
		t.a2b(dstInfo, srcInfo)
	case METHOD_B2B:
		t.b2b(srcInfo, dstInfo)
	}
	return <-errs
}

func (t *SyncTask) String() string {
	return fmt.Sprintf("Sync [%s] to [%s]", t.opt.SrcPath, t.opt.DstPath)
}

func NewSyncTask(fs FS, opt *SyncTaskOption) (*SyncTask, error) {
	return &SyncTask{
		fs:       fs,
		opt:      opt,
		addFiles: make(chan *syncFile),
		modFiles: make(chan *syncFile),
		delFiles: make(chan *syncFile),
	}, nil
}

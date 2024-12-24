package fs

import (
	"encoding/json"
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
	srcFile driver.File
	dstFile driver.File
	dstPath string
	makeDir bool
}

type syncInfo struct {
	addFiles *orderedmap.OrderedMap[string, driver.File]
	modFiles *orderedmap.OrderedMap[string, driver.File]
	delFiles *orderedmap.OrderedMap[string, driver.File]
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

	var result []driver.File

	if err := json.NewDecoder(r).Decode(&result); err != nil {
		return nil, err
	}
	info := &syncInfo{
		addFiles: orderedmap.NewOrderedMap[string, driver.File](),
	}
	for _, file := range result {
		path := strings.TrimPrefix(filepath.Join(file.Path(), file.Name()), root)
		info.addFiles.Set(path, file)
	}
	return info, nil
}

func (t *SyncTask) info(root string) (*syncInfo, error) {
	info := &syncInfo{
		addFiles: orderedmap.NewOrderedMap[string, driver.File](),
	}
	if err := driver.WalkDir(t.task.Context(), t.fs, root, func(_ string, file driver.File, err error) error {
		if err != nil {
			return err
		}
		path := strings.TrimPrefix(filepath.Join(file.Path(), file.Name()), root)
		if file.IsDir() {
			info.addFiles.Set(path, file)
			return nil
		}
		if isIncluded(file, t.opt.FileTypes) {
			info.addFiles.Set(path, file)
		}
		return nil
	}); err != nil {
		return nil, err
	}
	return info, nil
}

func (t *SyncTask) addFile(s *syncFile) error {
	srcPath := filepath.Join(s.srcFile.Path(), s.srcFile.Name())
	dstPath := s.dstPath

	if t.task.DryRun() {
		return nil
	}

	if s.makeDir {
		dstDir := filepath.Dir(dstPath)
		if err := t.fs.MakeDir(t.task.Context(), dstDir); err != nil {
			return err
		}
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

func (t *SyncTask) equal(src, dst driver.File) bool {
	return src.Size() == dst.Size() && src.ModTime().Equal(dst.ModTime())
}

func (t *SyncTask) a2b(srcPath, dstPath string) error {
	t.task.SetProgressState(fmt.Sprintf("SrcPath: %s", srcPath))
	src, err := t.info(srcPath)
	if err != nil {
		return err
	}

	t.task.SetProgressState(fmt.Sprintf("DstPath: %s", dstPath))
	dst, err := t.info(dstPath)
	if err != nil {
		return err
	}

	dirs := make(map[string]bool)
	for path, srcFile := range src.addFiles.AllFromFront() {
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
				src.addFiles.ReplaceKey(path, newPath)

				path = newPath
			}
		}

		dstFile, ok := dst.addFiles.Get(path)
		if !ok {
			// 检查目录是否存在, 不存在则创建
			dstDir := filepath.Dir(path)

			_, dirok := dst.addFiles.Get(dstDir)
			if !dirok {
				dirok = dirs[dstDir]
				dirs[dstDir] = true
			}
			if dstDir == "/" {
				dirok = true
			}

			if !dirok {
				t.task.SetProgressState(fmt.Sprintf("[创建目录] DstPath:%s", dstDir))
			}
			t.task.SetProgressState(fmt.Sprintf("[新增文件] DstPath:%s", path))

			t.addFiles <- &syncFile{
				srcFile: srcFile,
				dstPath: filepath.Join(dstPath, path),
				makeDir: !dirok,
			}
			continue
		}
		if !t.equal(srcFile, dstFile) {
			t.task.SetProgressState(fmt.Sprintf("[修改文件] DstPath:%s", path))

			t.modFiles <- &syncFile{
				srcFile: srcFile,
				dstFile: dstFile,
				dstPath: filepath.Join(dstPath, path),
			}
		}
	}

	for path, dstFile := range dst.addFiles.AllFromFront() {
		if dstFile.IsDir() {
			continue
		}
		_, ok := src.addFiles.Get(path)
		if !ok {
			t.task.SetProgressState(fmt.Sprintf("[删除文件] DstPath:%s", path))

			t.delFiles <- &syncFile{
				dstFile: dstFile,
				dstPath: filepath.Join(dstPath, path),
			}
		}
	}
	return nil
}

func (t *SyncTask) diff(src, dst *syncInfo) *syncInfo {
	info := &syncInfo{
		addFiles: orderedmap.NewOrderedMap[string, driver.File](),
		modFiles: orderedmap.NewOrderedMap[string, driver.File](),
		delFiles: orderedmap.NewOrderedMap[string, driver.File](),
	}
	if dst.addFiles.Len() == 0 {
		info.addFiles = src.addFiles
		return info
	}
	for path, srcFile := range src.addFiles.AllFromFront() {
		if srcFile.IsDir() {
			continue
		}
		dstFile, ok := dst.addFiles.Get(path)
		if !ok {
			info.addFiles.Set(path, srcFile)
			continue
		}
		if !t.equal(srcFile, dstFile) {
			info.modFiles.Set(path, srcFile)
		}
	}

	for path, dstFile := range dst.addFiles.AllFromFront() {
		if dstFile.IsDir() {
			continue
		}
		_, ok := src.addFiles.Get(path)
		if !ok {
			info.delFiles.Set(path, dstFile)
			continue
		}
	}
	return info
}

func (t *SyncTask) check(root string) (*syncInfo, error) {
	t.task.SetProgressState(fmt.Sprintf("Checking and diff %s", root))

	info, err := t.info(root)
	if err != nil {
		return nil, err
	}
	lastinfo, err := t.lastinfo(root)
	if err != nil {
		t.task.SetProgressState(fmt.Sprintf("Get last info of %s err: %s", root, err.Error()))

		lastinfo = &syncInfo{
			addFiles: orderedmap.NewOrderedMap[string, driver.File](),
		}
	}
	diff := t.diff(info, lastinfo)

	t.task.SetProgressState(fmt.Sprintf("Checking result: %d added, %d modified, %d deleted", diff.addFiles.Len(), diff.modFiles.Len(), diff.delFiles.Len()))
	return diff, nil
}

// TODO
func (t *SyncTask) b2b(srcPath, dstPath string) error {
	srcDiff, err := t.check(srcPath)
	if err != nil {
		return err
	}

	dstDiff, err := t.check(dstPath)
	if err != nil {
		return err
	}

	t.task.SetProgressState("Applying changes")

	for path, srcFile := range srcDiff.addFiles.AllFromFront() {
		dstFile, ok := dstDiff.addFiles.Get(path)
		if !ok {
			t.task.SetProgressState(fmt.Sprintf("[新增文件] SrcPath:%s", path))

			t.addFiles <- &syncFile{
				srcFile: srcFile,
				dstPath: filepath.Join(dstPath, path),
			}
		}

		if !t.equal(srcFile, dstFile) {
			t.task.SetProgressState(fmt.Sprintf("[修改文件] SrcPath:%s", path))

			t.modFiles <- &syncFile{
				srcFile: srcFile,
				dstFile: dstFile,
				dstPath: filepath.Join(dstPath, path),
			}
		}
	}

	for path, srcFile := range srcDiff.modFiles.AllFromFront() {
		dstFile, ok := dstDiff.modFiles.Get(path)
		if !ok {
			t.task.SetProgressState(fmt.Sprintf("[新增文件] DstPath:%s", path))

			t.addFiles <- &syncFile{
				srcFile: srcFile,
				dstPath: filepath.Join(dstPath, path),
			}
		}

		if !t.equal(srcFile, dstFile) {
			t.task.SetProgressState(fmt.Sprintf("[修改文件] DstPath:%s", path))

			t.modFiles <- &syncFile{
				srcFile: srcFile,
				dstFile: dstFile,
				dstPath: filepath.Join(dstPath, path),
			}
		}
	}

	for path, srcFile := range srcDiff.delFiles.AllFromFront() {
		if _, ok := dstDiff.delFiles.Get(path); !ok {
			t.task.SetProgressState(fmt.Sprintf("[删除文件] DstPath:%s", path))

			t.delFiles <- &syncFile{
				srcFile: srcFile,
				dstPath: filepath.Join(dstPath, path),
			}
		}
	}

	for path, dstFile := range dstDiff.addFiles.AllFromFront() {
		if _, ok := srcDiff.addFiles.Get(path); !ok {
			t.task.SetProgressState(fmt.Sprintf("[新增文件] SrcPath:%s", path))

			t.addFiles <- &syncFile{
				srcFile: dstFile,
				dstPath: filepath.Join(srcPath, path),
			}
		}
	}

	for path, dstFile := range dstDiff.modFiles.AllFromFront() {
		if _, ok := srcDiff.modFiles.Get(path); !ok {
			t.task.SetProgressState(fmt.Sprintf("[新增文件] SrcPath:%s", path))

			t.addFiles <- &syncFile{
				srcFile: dstFile,
				dstPath: filepath.Join(srcPath, path),
			}
		}
	}

	for path, dstFile := range dstDiff.delFiles.AllFromFront() {
		if _, ok := srcDiff.delFiles.Get(path); !ok {
			t.task.SetProgressState(fmt.Sprintf("[删除文件] SrcPath:%s", path))

			t.delFiles <- &syncFile{
				srcFile: dstFile,
				dstPath: filepath.Join(srcPath, path),
			}
		}
	}
	return nil
}

func (t *SyncTask) Run() error {
	errs := make(chan error)
	go func() {
		defer close(errs)
		switch t.opt.Method {
		case METHOD_A2B:
			errs <- t.a2b(t.opt.SrcPath, t.opt.DstPath)
		case METHOD_B2A:
			errs <- t.a2b(t.opt.DstPath, t.opt.SrcPath)
		case METHOD_B2B:
			errs <- t.b2b(t.opt.SrcPath, t.opt.DstPath)
		}
	}()

	var (
		err error
		ctx = t.task.Context()
	)
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
		case e, ok := <-errs:
			if ok {
				return nil
			}
			err = e
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

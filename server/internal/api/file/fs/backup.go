package fs

import (
	"fmt"

	"github.com/honmaple/maple-file/server/pkg/runner"
)

type BackupTaskOption struct {
	SrcPath    string   `json:"src_path"    validate:"required,nefield=DstPath"`
	DstPath    string   `json:"dst_path"    validate:"required,nefield=SrcPath"`
	Conflict   string   `json:"conflict"    validate:"required"`
	DeleteSrc  bool     `json:"delete_src"`
	DeleteDst  bool     `json:"delete_dst"`
	FileTypes  []string `json:"file_types"`
	CustomPath string   `json:"custom_path" validate:"omitempty,startsnotwith=/"`
}

func (opt *BackupTaskOption) String() string {
	return fmt.Sprintf("Backup [%s] to [%s]", opt.SrcPath, opt.DstPath)
}

func (opt *BackupTaskOption) Execute(task runner.Task, fs FS) error {
	t, err := NewBackupTask(task, fs, opt)
	if err != nil {
		return err
	}
	return t.Run()
}

func NewBackupTask(task runner.Task, fs FS, opt *BackupTaskOption) (Task, error) {
	return NewSyncTask(task, fs, &SyncTaskOption{
		Method:     METHOD_A2B,
		SrcPath:    opt.SrcPath,
		DstPath:    opt.SrcPath,
		Conflict:   opt.Conflict,
		DeleteSrc:  opt.DeleteSrc,
		DeleteDst:  opt.DeleteDst,
		CustomPath: opt.CustomPath,
		FileTypes:  opt.FileTypes,
	})
}

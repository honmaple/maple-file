package fs

import (
	"fmt"
)

type BackupTaskOption struct {
	SrcPath    string   `json:"src_path"`
	DstPath    string   `json:"dst_path"`
	Conflict   string   `json:"conflict"`
	DeleteSrc  bool     `json:"delete_src"`
	DeleteDst  bool     `json:"delete_dst"`
	CustomPath string   `json:"custom_path"` // 保持原有路径，或者按照时间格式重新整理
	FileTypes  []string `json:"file_types"`
}

type BackupTask struct {
	*SyncTask
}

func (t *BackupTask) String() string {
	return fmt.Sprintf("Backup [%s] to [%s]", t.opt.SrcPath, t.opt.DstPath)
}

func NewBackupTask(fs FS, opt *BackupTaskOption) (Task, error) {
	task, err := NewSyncTask(fs, &SyncTaskOption{
		Method:     METHOD_A2B,
		SrcPath:    opt.SrcPath,
		DstPath:    opt.SrcPath,
		Conflict:   opt.Conflict,
		DeleteSrc:  opt.DeleteSrc,
		DeleteDst:  opt.DeleteDst,
		CustomPath: opt.CustomPath,
		FileTypes:  opt.FileTypes,
	})
	if err != nil {
		return nil, err
	}
	return &BackupTask{task}, nil

}

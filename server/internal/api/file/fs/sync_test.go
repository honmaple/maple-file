package fs

import (
	"context"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/local"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/stretchr/testify/assert"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
)

type testFS struct {
	driver.FS
	runner runner.Runner
}

func (d *testFS) GetFS(path string) (driver.FS, string, error) {
	return d.FS, path, nil
}

func (d *testFS) GetRepo(path string) (*pb.Repo, error) {
	return nil, nil
}

func (d *testFS) CreateRepo(repo *pb.Repo) {
}

func (d *testFS) UpdateRepo(oldRepo, repo *pb.Repo) {
}

func (d *testFS) DeleteRepo(repo *pb.Repo) {
}

func (d *testFS) SubmitTask(opt TaskOption) runner.Task {
	return d.runner.SubmitByOption(runner.NewFuncOptionWithArg[FS](opt, d), runner.WithDryRun(true))
}

func TestSyncTask(t *testing.T) {
	assert := assert.New(t)

	root, err := os.Getwd()
	assert.Nil(err)

	lfs, err := local.New(&local.Option{
		Path: root,
	})
	assert.Nil(err)

	ctx := context.Background()

	srcDir := "/testdata/dir1"
	dstDir := "/testdata/dir2"

	assert.Nil(lfs.MakeDir(ctx, srcDir))
	assert.Nil(lfs.MakeDir(ctx, dstDir))

	files := []string{
		"/1.txt",
		"/subdir1/",
		"/subdir1/2.txt",
		"/subdir1/3.txt",
	}
	for _, file := range files {
		path := filepath.Join(srcDir, file)
		if strings.HasSuffix(file, "/") {
			assert.Nil(lfs.MakeDir(ctx, path))
		} else {
			w, err := lfs.Create(path)
			assert.Nil(err)
			w.Write([]byte(file))
			w.Close()
		}
	}

	dstfiles := []string{
		"/1.txt",
		"/subdir2/",
		"/subdir2/4.txt",
	}
	for _, file := range dstfiles {
		path := filepath.Join(dstDir, file)
		if strings.HasSuffix(file, "/") {
			assert.Nil(lfs.MakeDir(ctx, path))
		} else {
			w, err := lfs.Create(path)
			assert.Nil(err)
			w.Write([]byte(file))
			w.Close()
		}
	}

	// err = driver.WalkDir(ctx, lfs, srcDir, func(path string, file driver.File, err error) error {
	//	if err != nil {
	//		return err
	//	}
	//	fmt.Println(path)
	//	return nil
	// })
	// assert.Nil(err)

	// err = driver.WalkDir(ctx, lfs, dstDir, func(path string, file driver.File, err error) error {
	//	if err != nil {
	//		return err
	//	}
	//	fmt.Println(path)
	//	return nil
	// })
	// assert.Nil(err)

	fs := &testFS{lfs, runner.New(context.Background(), 10)}

	task := fs.SubmitTask(&SyncTaskOption{
		SrcPath:  srcDir,
		DstPath:  dstDir,
		Method:   METHOD_A2B,
		Conflict: CONFLICT_SKIP,
		// CustomPath: "{time:year}/{time:month}/{filename}{extension}",
	})
	<-task.Done()

	fmt.Println(task.Log())

	assert.Nil(lfs.Remove(ctx, srcDir))
	assert.Nil(lfs.Remove(ctx, dstDir))
}

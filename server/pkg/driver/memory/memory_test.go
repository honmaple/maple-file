package memory

import (
	"context"
	"fmt"
	"io"
	"path/filepath"
	"strings"
	"testing"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
	"github.com/stretchr/testify/assert"
)

func TestMemory(t *testing.T) {
	assert := assert.New(t)

	lfs, err := New(&Option{})
	assert.Nil(err)

	ctx := context.Background()

	dirs := []string{
		"/testdata",
		"/testdata/dir1/dir2",
	}
	for _, dir := range dirs {
		err = lfs.MakeDir(ctx, dir)
		assert.Nil(err)

		info, err := lfs.Get(ctx, dir)
		assert.Nil(err)
		assert.True(info.IsDir())
		assert.Equal(info.Path(), filepath.Dir(dir))
		assert.Equal(info.Name(), filepath.Base(dir))
	}

	files := []string{
		"/testdata/1.txt",
		"/testdata/dir1/dir2/2.txt",
	}
	for _, file := range files {
		w, err := lfs.Create(file)
		assert.Nil(err)
		w.Write([]byte(file))
		w.Close()

		info, err := lfs.Get(ctx, file)
		assert.Nil(err)
		assert.False(info.IsDir())
		assert.Equal(info.Path(), filepath.Dir(file))
		assert.Equal(info.Name(), filepath.Base(file))

		r, err := lfs.Open(file)
		assert.Nil(err)
		buf, _ := io.ReadAll(r)
		r.Close()

		assert.Equal(string(buf), file)
	}

	errFiles := []string{
		"/testdata/dir/1.txt",
		"/testdata/dir1/dir2/dir3/3.txt",
	}
	for _, file := range errFiles {
		_, err := lfs.Create(file)
		assert.NotNil(err)
	}

	copyFiles := []string{
		"/testdata/1.txt:/testdata/dir1",
		"/testdata/1.txt:/testdata/dir1/dir2",
	}
	for _, file := range copyFiles {
		ps := strings.Split(file, ":")
		src, dst := ps[0], ps[1]

		err := lfs.Copy(ctx, src, dst)
		assert.Nil(err)

		info, err := lfs.Get(ctx, filepath.Join(dst, filepath.Base(src)))
		assert.Nil(err)
		assert.False(info.IsDir())
		assert.Equal(info.Path(), dst)
		assert.Equal(info.Name(), filepath.Base(src))
	}

	// errCopyFiles := []string{
	//	"/testdata/1.txt:/testdata/2.txt",
	//	"/testdata/dir1:/testdata/dir2",
	// }

	// for _, file := range errCopyFiles {
	//	ps := strings.Split(file, ":")
	//	src, dst := ps[0], ps[1]

	//	err := lfs.Copy(ctx, src, dst)
	//	assert.NotNil(err)
	// }

	renameFiles := []string{
		"/testdata/1.txt:2.txt",
		"/testdata/dir1:dir123",
	}

	for _, file := range renameFiles {
		ps := strings.Split(file, ":")
		src, dst := ps[0], ps[1]

		err := lfs.Rename(ctx, src, dst)
		assert.Nil(err)

		_, err = lfs.Get(ctx, src)
		assert.NotNil(err)

		info, err := lfs.Get(ctx, filepath.Join(filepath.Dir(src), dst))
		assert.Nil(err)
		assert.Equal(info.Path(), filepath.Dir(src))
		assert.Equal(info.Name(), dst)
	}

	err = driver.WalkDir(ctx, lfs, "/testdata", func(path string, file driver.File, err error) error {
		if err != nil {
			return err
		}
		fmt.Println(path)
		return nil
	})
	assert.Nil(err)
}

func TestRecycle(t *testing.T) {
	assert := assert.New(t)

	lfs, err := New(&Option{
		Option: base.Option{
			Recycle: true,
			RecycleOption: base.RecycleOption{
				Path: "/testdata/.maplerecycle",
			},
		},
	})
	assert.Nil(err)

	ctx := context.Background()

	dirs := []string{
		"/testdata",
	}
	for _, dir := range dirs {
		err = lfs.MakeDir(ctx, dir)
		assert.Nil(err)
	}

	files := []string{
		"/testdata/1.txt",
	}
	for _, file := range files {
		w, err := lfs.Create(file)
		assert.Nil(err)
		w.Write([]byte(file))
		w.Close()
	}

	err = lfs.Remove(ctx, "/testdata/1.txt")
	assert.Nil(err)

	err = driver.WalkDir(ctx, lfs, "/testdata", func(path string, file driver.File, err error) error {
		if err != nil {
			return err
		}
		fmt.Println(path, file.Name(), file.Type())
		return nil
	})
	assert.Nil(err)
}

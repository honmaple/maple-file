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

func initFS(ctx context.Context, lfs driver.FS, files []string) error {
	for _, file := range files {
		if file == "/" {
			continue
		}
		if strings.HasSuffix(file, "/") {
			err := lfs.MakeDir(ctx, strings.TrimSuffix(file, "/"))
			if err != nil {
				return err
			}
		} else {
			w, err := lfs.Create(file)
			if err != nil {
				return err
			}
			w.Write([]byte(file))
			w.Close()
		}
	}
	return nil
}

func readFile(lfs driver.FS, path string) ([]byte, error) {
	r, err := lfs.Open(path)
	if err != nil {
		return nil, err
	}
	defer r.Close()
	return io.ReadAll(r)
}

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

	recyclePath := "/testdata/.maplerecycle"

	lfs, err := New(&Option{
		Option: base.Option{
			Recycle: true,
			RecycleOption: base.RecycleOption{
				Path: recyclePath,
			},
		},
	})
	assert.Nil(err)

	ctx := context.Background()

	err = initFS(ctx, lfs, []string{
		"/testdata/",
		"/testdata/1.txt",
		"/testdata/2.txt",
		"/testdata/dir/",
		"/testdata/dir/3.txt",
	})
	assert.Nil(err)

	for i, file := range []string{
		"/testdata/1.txt",
		"/testdata/2.txt",
	} {
		err = lfs.Remove(ctx, file)
		assert.Nil(err)

		files, err := lfs.List(ctx, recyclePath)
		assert.Nil(err)
		assert.Equal(i+1, len(files))

		content, err := readFile(lfs, filepath.Join(files[i].Path(), files[i].Name()))
		assert.Nil(err)
		assert.Equal(string(content), file)
	}

	err = lfs.Remove(ctx, "/testdata/dir")
	assert.Nil(err)
	files, err := lfs.List(ctx, recyclePath)
	assert.Nil(err)
	assert.Equal(3, len(files))

	content, err := readFile(lfs, filepath.Join(recyclePath, files[2].Name(), "3.txt"))
	assert.Nil(err)
	assert.Equal(string(content), "/testdata/dir/3.txt")
}

package fs

import (
	"context"
	"errors"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/util"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
)

type FS interface {
	driver.FS
	Repo() *pb.Repo
	MountPath() string
}

type repoFS struct {
	driver.FS
	repo *pb.Repo
}

func (d *repoFS) Repo() *pb.Repo {
	return d.repo
}

func (d *repoFS) MountPath() string {
	return filepath.Join(d.repo.GetPath(), d.repo.GetName())
}

type rootFS struct {
	driver.FS
	app   *app.App
	repos util.Cache[string, *pb.Repo]

	mu       sync.RWMutex
	lastTime time.Time
}

func (d *rootFS) Copy(ctx context.Context, src string, dst string) error {
	srcFS, srcPath, err := d.fn(src)
	if err != nil {
		return err
	}
	dstFS, dstPath, err := d.fn(dst)
	if err != nil {
		return err
	}
	d.app.Runner.SubmitByOption(&CopyOption{
		SrcFS:   srcFS,
		SrcPath: srcPath,
		DstFS:   dstFS,
		DstPath: dstPath,
	})
	return nil
}

func (d *rootFS) Move(ctx context.Context, src string, dst string) error {
	srcFS, srcPath, err := d.fn(src)
	if err != nil {
		return err
	}
	dstFS, dstPath, err := d.fn(dst)
	if err != nil {
		return err
	}
	if srcFS.Repo().GetId() != dstFS.Repo().GetId() {
		return driver.ErrNotSupport
	}
	d.app.Runner.SubmitByOption(&MoveOption{
		SrcFS:   srcFS,
		SrcPath: srcPath,
		DstFS:   dstFS,
		DstPath: dstPath,
	})
	return nil
}

func (d *rootFS) Remove(ctx context.Context, path string) error {
	srcFS, srcPath, err := d.fn(path)
	if err != nil {
		return err
	}
	d.app.Runner.SubmitByOption(&RemoveOption{FS: srcFS, Path: srcPath})
	return nil
}

func (d *rootFS) fn(path string) (FS, string, error) {
	path = util.CleanPath(path)

	var (
		repo    *pb.Repo
		pathstr = path
	)

	d.mu.RLock()
	lastTime := d.lastTime
	d.mu.RUnlock()

	if lastTime.Add(time.Second * 30).Before(time.Now()) {
		d.loadRepos()
	}

	for {
		if v, ok := d.repos.Load(pathstr); ok {
			repo = v
			break
		}
		index := strings.LastIndex(pathstr, "/")
		if index <= 0 {
			break
		}
		pathstr = pathstr[:index]
	}
	if repo == nil {
		return nil, "", errors.New("错误的路径")
	}

	realPath := strings.TrimPrefix(path, filepath.Join(repo.GetPath(), repo.GetName()))
	if !strings.HasPrefix(realPath, "/") {
		realPath = "/" + realPath
	}

	fs, err := driver.DriverFS(repo.Driver, repo.Option)
	if err != nil {
		return nil, "", err
	}
	return &repoFS{FS: fs, repo: repo}, realPath, nil
}

func (d *rootFS) driverFn(path string) (driver.FS, string, error) {
	return d.fn(path)
}

func (d *rootFS) loadRepos() error {
	d.mu.Lock()
	defer d.mu.Unlock()

	repos := make([]*pb.Repo, 0)
	d.app.DB.Model(pb.Repo{}).Find(&repos)

	d.repos.Reset()
	for _, repo := range repos {
		d.repos.Store(filepath.Join(repo.GetPath(), repo.GetName()), repo)
	}
	d.lastTime = time.Now()
	return nil
}

func New(app *app.App) driver.FS {
	d := &rootFS{
		app:   app,
		repos: util.NewCache[string, *pb.Repo](),
	}
	d.FS = driver.NewFS(d.driverFn, nil)

	d.loadRepos()
	return d
}

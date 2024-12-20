package fs

import (
	"errors"
	"path/filepath"
	"strings"

	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
)

type FS interface {
	driver.FS
	GetFS(string) (driver.FS, string, error)
	GetRepo(string) (*pb.Repo, error)
	CreateRepo(*pb.Repo)
	UpdateRepo(*pb.Repo, *pb.Repo)
	DeleteRepo(*pb.Repo)
	SubmitTask(Task) runner.Task
	SubmitTaskByOption(TaskOption) (runner.Task, error)
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

type defaultFS struct {
	driver.FS
	app   *app.App
	cache util.Cache[string, driver.FS]
	repos util.Cache[string, *pb.Repo]
}

func (d *defaultFS) GetFS(path string) (driver.FS, string, error) {
	repo, err := d.GetRepo(path)
	if err != nil {
		return nil, "", err
	}
	if !repo.Status {
		return nil, "", errors.New("存储未激活")
	}

	rootPath := filepath.Join(repo.GetPath(), repo.GetName())

	realPath := strings.TrimPrefix(path, rootPath)
	if !strings.HasPrefix(realPath, "/") {
		realPath = "/" + realPath
	}
	if v, ok := d.cache.Load(rootPath); ok {
		return v, realPath, nil
	}

	fs, err := driver.DriverFS(repo.Driver, repo.Option)
	if err != nil {
		return nil, "", err
	}
	d.cache.Store(rootPath, fs)
	return fs, realPath, nil
}

func (d *defaultFS) GetRepo(path string) (*pb.Repo, error) {
	path = util.CleanPath(path)

	var (
		repo    *pb.Repo
		pathstr = path
	)

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
		return nil, errors.New("错误的路径")
	}
	return repo, nil
}

func (d *defaultFS) CreateRepo(repo *pb.Repo) {
	d.repos.Store(filepath.Join(repo.GetPath(), repo.GetName()), repo)
}

func (d *defaultFS) UpdateRepo(oldRepo, repo *pb.Repo) {
	d.DeleteRepo(oldRepo)
	d.CreateRepo(repo)
}

func (d *defaultFS) DeleteRepo(repo *pb.Repo) {
	rootPath := filepath.Join(repo.GetPath(), repo.GetName())

	fs, ok := d.cache.Load(rootPath)
	if ok {
		_ = fs.Close()
	}

	d.repos.Delete(rootPath)
	d.cache.Delete(rootPath)
}

func (d *defaultFS) SubmitTask(task Task) runner.Task {
	return d.app.Runner.Submit(task.String(), task.Execute)
}

func (d *defaultFS) SubmitTaskByOption(opt TaskOption) (runner.Task, error) {
	t, err := opt.NewTask(d)
	if err != nil {
		return nil, err
	}
	return d.app.Runner.Submit(t.String(), t.Execute), nil
}

func (d *defaultFS) loadRepos() error {
	repos := make([]*pb.Repo, 0)
	d.app.DB.Model(pb.Repo{}).Find(&repos)

	for _, repo := range repos {
		d.repos.Store(filepath.Join(repo.GetPath(), repo.GetName()), repo)
	}
	return nil
}

func New(app *app.App) FS {
	d := &defaultFS{
		app:   app,
		cache: util.NewCache[string, driver.FS](),
		repos: util.NewCache[string, *pb.Repo](),
	}
	d.FS = driver.NewFS(d.GetFS, nil)

	d.loadRepos()
	return d
}

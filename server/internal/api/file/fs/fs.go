package fs

import (
	"context"
	"os"
	filepath "path"
	"strings"
	"time"

	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
)

type (
	Task interface {
		Run() error
	}
	TaskOption interface {
		String() string
		Execute(runner.Task, FS) error
	}

	FS interface {
		driver.FS
		GetFS(string) (driver.FS, string, error)
		GetRepo(string) *pb.Repo
		CreateRepo(*pb.Repo)
		UpdateRepo(*pb.Repo, *pb.Repo)
		DeleteRepo(*pb.Repo)
		SubmitTask(TaskOption) runner.Task
	}
)

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

func (d *defaultFS) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	results := make([]driver.File, 0)
	repoMap := make(map[string]bool)
	if path != "/" && d.GetRepo(path) != nil {
		files, err := d.FS.List(ctx, path, metas...)
		if err != nil {
			return nil, err
		}
		for _, file := range files {
			if file.IsDir() {
				repoMap[file.Name()] = true
			}
			results = append(results, file)
		}
	}

	for _, repo := range d.repos.Iter() {
		if !repo.GetStatus() {
			continue
		}
		if path == repo.GetPath() {
			if name := repo.GetName(); !repoMap[name] {
				info := &driver.FileInfo{
					Path:    path,
					Name:    name,
					IsDir:   true,
					ModTime: repo.UpdatedAt.AsTime(),
				}
				results = append(results, info.File())
				repoMap[name] = true
			}
		} else if util.IsSubPath(path, repo.GetPath()) {
			relPath := ""
			if strings.HasSuffix(path, "/") {
				relPath = strings.TrimPrefix(repo.GetPath(), path)
			} else {
				relPath = strings.TrimPrefix(repo.GetPath(), path+"/")
			}
			if root := strings.SplitN(relPath, "/", 2); len(root) > 0 && !repoMap[root[0]] {
				info := &driver.FileInfo{
					Path:    path,
					Name:    root[0],
					IsDir:   true,
					ModTime: repo.UpdatedAt.AsTime(),
				}
				results = append(results, info.File())
				repoMap[root[0]] = true
			}
		}
	}
	return results, nil
}

func (d *defaultFS) Get(ctx context.Context, path string) (driver.File, error) {
	// webdav server必须先获取目录信息，所以这里需要特殊处理一下
	if path == "/" {
		info := &driver.FileInfo{
			Path:    "/",
			Name:    "/",
			IsDir:   true,
			ModTime: time.Now(),
		}
		return info.File(), nil
	}

	repo := d.GetRepo(path)
	if repo == nil {
		// 获取虚拟路径
		for _, repo := range d.repos.Iter() {
			if !repo.GetStatus() {
				continue
			}
			// /a/b:/a/b/c
			if util.IsSubPath(path, repo.Path) {
				info := &driver.FileInfo{
					Path:    filepath.Dir(path),
					Name:    filepath.Base(path),
					IsDir:   true,
					ModTime: repo.UpdatedAt.AsTime(),
				}
				return info.File(), nil
			}
		}
		return nil, os.ErrNotExist
	}
	if path == filepath.Join(repo.Path, repo.Name) {
		info := &driver.FileInfo{
			Path:    repo.Path,
			Name:    repo.Name,
			IsDir:   true,
			ModTime: repo.UpdatedAt.AsTime(),
		}
		return info.File(), nil
	}
	return d.FS.Get(ctx, path)
}

func (d *defaultFS) GetFS(path string) (driver.FS, string, error) {
	repo := d.GetRepo(path)
	if repo == nil {
		return nil, "", os.ErrNotExist
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

func (d *defaultFS) GetRepo(path string) *pb.Repo {
	path = util.CleanPath(path)

	var (
		repo    *pb.Repo
		pathstr = path
	)

	for {
		if v, ok := d.repos.Load(pathstr); ok && v.Status {
			repo = v
			break
		}
		index := strings.LastIndex(pathstr, "/")
		if index <= 0 {
			break
		}
		pathstr = pathstr[:index]
	}
	return repo
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

func (d *defaultFS) SubmitTask(opt TaskOption) runner.Task {
	return d.app.Runner.SubmitByOption(runner.NewFuncOptionWithArg[FS](opt, d))
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

package fs

import (
	"context"
	"os"
	filepath "path"
	"strings"
	"time"

	"github.com/honmaple/cloudfs"
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
		cloudfs.FS
		GetFS(string) (cloudfs.FS, string, error)
		GetRepo(string) *pb.Repo
		CreateRepo(*pb.Repo)
		UpdateRepo(*pb.Repo, *pb.Repo)
		DeleteRepo(*pb.Repo)
		SubmitTask(TaskOption) runner.Task
	}
)

type defaultFS struct {
	cloudfs.FS
	app   *app.App
	cache util.Cache[string, cloudfs.FS]
	repos util.Cache[string, *pb.Repo]
}

func (d *defaultFS) List(ctx context.Context, path string, opts ...cloudfs.ListOption) ([]cloudfs.FileInfo, error) {
	results := make([]cloudfs.FileInfo, 0)
	repoMap := make(map[string]bool)
	if path != "/" && d.GetRepo(path) != nil {
		files, err := d.FS.List(ctx, path, opts...)
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
				results = append(results, driver.NewDir(path, name, func(entry *cloudfs.Entry) {
					entry.ModTime = repo.UpdatedAt.AsTime()
				}))
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
				results = append(results, driver.NewDir(path, root[0], func(entry *cloudfs.Entry) {
					entry.ModTime = repo.UpdatedAt.AsTime()
				}))
				repoMap[root[0]] = true
			}
		}
	}
	return results, nil
}

func (d *defaultFS) Stat(ctx context.Context, path string) (cloudfs.FileInfo, error) {
	// webdav server必须先获取目录信息，所以这里需要特殊处理一下
	if path == "/" {
		return driver.NewDir("/", "/", func(entry *cloudfs.Entry) {
			entry.ModTime = time.Now()
		}), nil
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
				return driver.NewDir(filepath.Dir(path), filepath.Base(path), func(entry *cloudfs.Entry) {
					entry.ModTime = repo.UpdatedAt.AsTime()
				}), nil
			}
		}
		return nil, os.ErrNotExist
	}
	if path == filepath.Join(repo.Path, repo.Name) {
		return driver.NewDir(repo.Path, repo.Name, func(entry *cloudfs.Entry) {
			entry.ModTime = repo.UpdatedAt.AsTime()
		}), nil
	}
	return d.FS.Stat(ctx, path)
}

func (d *defaultFS) GetFS(path string) (cloudfs.FS, string, error) {
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

	fs, err := driver.NewCloudFS(repo.Driver, repo.Option)
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
		cache: util.NewCache[string, cloudfs.FS](),
		repos: util.NewCache[string, *pb.Repo](),
	}
	d.FS = driver.NewFS(d.GetFS, nil)

	d.loadRepos()
	return d
}

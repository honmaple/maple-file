package github

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"

	filepath "path"

	"github.com/google/go-github/v70/github"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
	httputil "github.com/honmaple/maple-file/server/pkg/util/http"
)

type Option struct {
	base.Option
	Ref        string `json:"ref"`
	Repo       string `json:"repo"`
	Owner      string `json:"owner"  validate:"required"`
	Token      string `json:"token"`
	ShowTag    bool   `json:"show_tag"`
	ShowBranch bool   `json:"show_branch"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type Github struct {
	driver.Base
	opt        *Option
	client     *github.Client
	httpClient *httputil.Client
}

var _ driver.FS = (*Github)(nil)

func (d *Github) request(ctx context.Context, method, url string, opts ...httputil.Option) (io.ReadCloser, error) {
	if opts == nil {
		opts = make([]httputil.Option, 0)
	}

	opts = append(opts, httputil.WithContext(ctx))

	resp, err := d.httpClient.Request(method, url, opts...)
	if err != nil {
		return nil, err
	}

	if code := resp.StatusCode; code == http.StatusPartialContent || code == http.StatusOK {
		return resp.Body, nil
	}
	resp.Body.Close()
	return nil, fmt.Errorf("bad status: %d", resp.StatusCode)
}

func (d *Github) download(url string, size int64) (driver.FileReader, error) {
	if url == "" {
		return nil, errors.New("no download url")
	}
	rangeFunc := func(offset, length int64) (io.ReadCloser, error) {
		return d.request(context.Background(), http.MethodGet, url, httputil.WithNeverTimeout(), httputil.WithRequest(func(req *http.Request) {
			if length > 0 {
				req.Header.Add("Range", fmt.Sprintf("bytes=%d-%d", offset, offset+length-1))
			} else {
				req.Header.Add("Range", fmt.Sprintf("bytes=%d-", offset))
			}
		}))
	}
	return driver.NewFileReader(size, rangeFunc)
}

func (d *Github) splitPath(path string) (string, string) {
	path = path[1:]
	i := strings.IndexByte(path, '/')
	if i == -1 {
		return path, "/"
	}
	return path[:i], path[i:]
}

// /{user}/{repo}/{ref}/readme.md
func (d *Github) getActualPath(path string) (string, string, string) {
	if path == "/" {
		return d.opt.Repo, d.opt.Ref, path
	}

	repo := d.opt.Repo
	if repo == "" {
		repo, path = d.splitPath(path)
	}

	ref := d.opt.Ref
	if ref == "" && (d.opt.ShowTag || d.opt.ShowBranch) {
		ref, path = d.splitPath(path)
		if b, err := url.PathUnescape(ref); err == nil {
			ref = b
		}
	}
	return repo, ref, path
}

func (d *Github) Get(ctx context.Context, path string) (driver.File, error) {
	repo, ref, actualPath := d.getActualPath(path)
	if repo == "" {
		return nil, fmt.Errorf("can't stat %s", path)
	}

	// 获取仓库信息
	if ref == "" && actualPath == "/" {
		result, _, err := d.client.Repositories.Get(ctx, d.opt.Owner, repo)
		if err != nil {
			return nil, err
		}

		info := &driver.FileInfo{
			Path:    path,
			Name:    result.GetName(),
			Size:    int64(result.GetSize()),
			IsDir:   true,
			ModTime: result.GetUpdatedAt().Time,
		}
		return info.File(), nil
	}

	// 获取分支信息
	if actualPath == "/" {
		info := &driver.FileInfo{
			Path:    path,
			Name:    ref,
			IsDir:   true,
			ModTime: time.Now(),
		}
		return info.File(), nil
	}

	dir, filename := filepath.Dir(actualPath), filepath.Base(actualPath)
	_, dc, _, err := d.client.Repositories.GetContents(context.Background(), d.opt.Owner, repo, dir, &github.RepositoryContentGetOptions{
		Ref: ref,
	})
	if err != nil {
		return nil, err
	}

	for _, result := range dc {
		if result.GetName() != filename {
			continue
		}
		info := &driver.FileInfo{
			Path:    path,
			Name:    result.GetName(),
			Size:    int64(result.GetSize()),
			IsDir:   result.GetType() == "dir",
			ModTime: time.Now(),
		}
		return info.File(), nil
	}
	return nil, fmt.Errorf("no file named %s found in %s", filename, dir)
}

func (d *Github) Open(path string) (driver.FileReader, error) {
	repo, ref, actualPath := d.getActualPath(path)
	if repo == "" || actualPath == "/" {
		return nil, fmt.Errorf("can't open %s", path)
	}

	dir, filename := filepath.Dir(actualPath), filepath.Base(actualPath)
	_, dc, _, err := d.client.Repositories.GetContents(context.Background(), d.opt.Owner, repo, dir, &github.RepositoryContentGetOptions{
		Ref: ref,
	})
	if err != nil {
		return nil, err
	}

	for _, result := range dc {
		if result.GetName() != filename {
			continue
		}
		return d.download(result.GetDownloadURL(), int64(result.GetSize()))
	}
	return nil, fmt.Errorf("no file named %s found in %s", filename, dir)
}

func (d *Github) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	repo, ref, actualPath := d.getActualPath(path)

	if repo == "" {
		files := make([]driver.File, 0)
		for i := 1; ; i++ {
			opts := &github.RepositoryListByUserOptions{
				ListOptions: github.ListOptions{
					Page:    i,
					PerPage: 100,
				},
			}
			results, _, err := d.client.Repositories.ListByUser(ctx, d.opt.Owner, opts)
			if err != nil {
				return nil, err
			}
			for _, result := range results {
				info := &driver.FileInfo{
					Path:    path,
					Name:    result.GetName(),
					Size:    int64(result.GetSize()),
					IsDir:   true,
					ModTime: result.GetUpdatedAt().Time,
				}
				files = append(files, info.File())
			}
			if len(results) < 100 {
				break
			}
		}
		return files, nil
	}

	if ref == "" && (d.opt.ShowBranch || d.opt.ShowTag) {
		files := make([]driver.File, 0)

		if d.opt.ShowBranch {
			for i := 1; ; i++ {
				opts := &github.BranchListOptions{
					ListOptions: github.ListOptions{
						Page:    i,
						PerPage: 100,
					},
				}
				results, _, err := d.client.Repositories.ListBranches(ctx, d.opt.Owner, repo, opts)
				if err != nil {
					return nil, err
				}
				for _, result := range results {
					// 分支名称可能包括路径分隔符
					info := &driver.FileInfo{
						Path:    path,
						Name:    url.PathEscape(result.GetName()),
						IsDir:   true,
						ModTime: time.Now(),
					}
					files = append(files, info.File())
				}
				if len(results) < 100 {
					break
				}
			}
		}

		if d.opt.ShowTag {
			for i := 1; ; i++ {
				opts := &github.ListOptions{
					Page:    i,
					PerPage: 100,
				}
				results, _, err := d.client.Repositories.ListTags(ctx, d.opt.Owner, repo, opts)
				if err != nil {
					return nil, err
				}
				for _, result := range results {
					info := &driver.FileInfo{
						Path:    path,
						Name:    url.PathEscape(result.GetName()),
						IsDir:   true,
						ModTime: time.Now(),
					}
					files = append(files, info.File())
				}
				if len(results) < 100 {
					break
				}
			}
		}
		return files, nil
	}

	opts := &github.RepositoryContentGetOptions{
		Ref: ref,
	}

	fc, dc, _, err := d.client.Repositories.GetContents(ctx, d.opt.Owner, repo, actualPath, opts)
	if err != nil {
		return nil, err
	}
	if fc != nil {
		info := &driver.FileInfo{
			Path:    path,
			Name:    fc.GetName(),
			Size:    int64(fc.GetSize()),
			IsDir:   fc.GetType() == "dir",
			ModTime: time.Now(),
		}
		return []driver.File{info.File()}, nil
	}

	files := make([]driver.File, len(dc))
	for i, result := range dc {
		info := &driver.FileInfo{
			Path:    path,
			Name:    result.GetName(),
			Size:    int64(result.GetSize()),
			IsDir:   result.GetType() == "dir",
			ModTime: time.Now(),
		}
		files[i] = info.File()
	}
	return files, nil
}

func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	client := github.NewClient(nil)
	if opt.Token != "" {
		client = client.WithAuthToken(opt.Token)
	}

	d := &Github{
		opt:        opt,
		client:     client,
		httpClient: httputil.New(),
	}
	return opt.Option.NewFS(d)
}

func init() {
	driver.Register("github", func() driver.Option {
		return &Option{}
	})
}

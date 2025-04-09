package github

import (
	"context"
	"errors"
	"fmt"
	"io"
	"io/fs"
	"net/http"
	"net/url"
	"strings"

	"github.com/google/go-github/v70/github"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/driver/base"
	httputil "github.com/honmaple/maple-file/server/pkg/util/http"
)

type ReleaseOption struct {
	base.Option
	Repo    string `json:"repo"`
	Owner   string `json:"owner"  validate:"required"`
	Release string `json:"release"`
	Token   string `json:"token"`
}

func (opt *ReleaseOption) NewFS() (driver.FS, error) {
	return NewRelease(opt)
}

type GithubRelease struct {
	driver.Base
	opt        *ReleaseOption
	client     *github.Client
	httpClient *httputil.Client
}

var _ driver.FS = (*GithubRelease)(nil)

func (d *GithubRelease) request(ctx context.Context, method, url string, opts ...httputil.Option) (io.ReadCloser, error) {
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

func (d *GithubRelease) download(url string, size int64) (driver.FileReader, error) {
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

func (d *GithubRelease) splitPath(path string) (string, string) {
	path = path[1:]
	i := strings.IndexByte(path, '/')
	if i == -1 {
		return path, "/"
	}
	return path[:i], path[i:]
}

// /{user}/{repo}/{branch}/readme.md
func (d *GithubRelease) getActualPath(path string) (string, string, string) {
	if path == "/" {
		return d.opt.Repo, d.opt.Release, path
	}

	repo := d.opt.Repo
	if repo == "" {
		repo, path = d.splitPath(path)
	}

	release := d.opt.Release
	if release == "" {
		release, path = d.splitPath(path)
		if b, err := url.PathUnescape(release); err == nil {
			release = b
		}
	}
	return repo, release, path
}

func (d *GithubRelease) getRelease(ctx context.Context, repo, name string) (*github.RepositoryRelease, error) {
	results, _, err := d.client.Repositories.ListReleases(ctx, d.opt.Owner, repo, nil)
	if err != nil {
		return nil, err
	}
	for _, result := range results {
		if result.GetName() != name {
			continue
		}
		return result, nil
	}
	return nil, fmt.Errorf("no release named %s found in %s", name, repo)
}

func (d *GithubRelease) getReleaseAsset(ctx context.Context, repo, releaseName, name string) (*github.ReleaseAsset, error) {
	release, err := d.getRelease(ctx, repo, releaseName)
	if err != nil {
		return nil, err
	}
	for _, asset := range release.Assets {
		if asset.GetName() != name {
			continue
		}
		return asset, nil
	}
	return nil, fmt.Errorf("no asset named %s found in %s", name, releaseName)
}

func (d *GithubRelease) Get(ctx context.Context, path string) (driver.File, error) {
	repo, release, actualPath := d.getActualPath(path)
	if repo == "" {
		return nil, fmt.Errorf("can't stat %s", path)
	}

	if release == "" {
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

	if actualPath == "/" {
		result, err := d.getRelease(ctx, repo, release)
		if err != nil {
			return nil, err
		}

		info := &driver.FileInfo{
			Path:    path,
			Name:    url.PathEscape(result.GetName()),
			ModTime: result.GetPublishedAt().Time,
			IsDir:   true,
		}
		return info.File(), nil
	}

	assetName, actualPath := d.splitPath(actualPath)
	if actualPath == "/" {
		result, err := d.getReleaseAsset(ctx, repo, release, assetName)
		if err != nil {
			return nil, err
		}
		info := &driver.FileInfo{
			Path:    path,
			Name:    result.GetName(),
			Size:    int64(result.GetSize()),
			ModTime: result.GetUpdatedAt().Time,
		}
		return info.File(), nil
	}
	return nil, &fs.PathError{Op: "list", Path: path, Err: fs.ErrNotExist}
}

func (d *GithubRelease) Open(path string) (driver.FileReader, error) {
	repo, release, actualPath := d.getActualPath(path)
	if repo == "" || release == "" || actualPath == "/" {
		return nil, &fs.PathError{Op: "open", Path: path, Err: fs.ErrInvalid}
	}

	assetName := strings.TrimPrefix(actualPath, "/")
	result, err := d.getReleaseAsset(context.Background(), repo, release, assetName)
	if err != nil {
		return nil, err
	}
	return d.download(result.GetBrowserDownloadURL(), int64(result.GetSize()))
}

func (d *GithubRelease) List(ctx context.Context, path string, metas ...driver.Meta) ([]driver.File, error) {
	repo, release, actualPath := d.getActualPath(path)

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

	if release == "" {
		results, _, err := d.client.Repositories.ListReleases(ctx, d.opt.Owner, repo, nil)
		if err != nil {
			return nil, err
		}
		files := make([]driver.File, len(results))
		for i, result := range results {
			info := &driver.FileInfo{
				Path:    path,
				Name:    url.PathEscape(result.GetName()),
				ModTime: result.GetPublishedAt().Time,
				IsDir:   true,
			}
			files[i] = info.File()
		}
		return files, nil
	}

	if actualPath == "/" {
		release, err := d.getRelease(ctx, repo, release)
		if err != nil {
			return nil, err
		}
		files := make([]driver.File, len(release.Assets))
		for i, asset := range release.Assets {
			info := &driver.FileInfo{
				Path:    path,
				Name:    asset.GetName(),
				Size:    int64(asset.GetSize()),
				ModTime: asset.GetUpdatedAt().Time,
			}
			files[i] = info.File()
		}
		return files, nil
	}
	return nil, &fs.PathError{Op: "list", Path: path, Err: fs.ErrNotExist}
}

func NewRelease(opt *ReleaseOption) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}

	client := github.NewClient(nil)
	if opt.Token != "" {
		client = client.WithAuthToken(opt.Token)
	}

	d := &GithubRelease{
		opt:        opt,
		client:     client,
		httpClient: httputil.New(),
	}
	return opt.Option.NewFS(d)
}

func init() {
	driver.Register("githubRelease", func() driver.Option {
		return &ReleaseOption{}
	})
}

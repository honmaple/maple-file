package driver

import (
	"context"
	"encoding/json"

	"github.com/honmaple/cloudfs"
	cloudfsdriver "github.com/honmaple/cloudfs/driver"
)

type (
	FS interface {
		List(context.Context, string, ...Meta) ([]File, error)
		Move(context.Context, string, string) error
		Copy(context.Context, string, string) error
		Rename(context.Context, string, string) error
		Remove(context.Context, string) error
		MakeDir(context.Context, string) error
		Get(context.Context, string) (File, error)
		Open(string) (FileReader, error)
		Create(string) (FileWriter, error)
		Close() error
	}

	Option interface {
		NewFS() (FS, error)
	}
	OptionCreator func() Option
)

type Base struct{}

func (Base) List(context.Context, string, ...Meta) ([]File, error) { return nil, ErrNotSupport }
func (Base) Move(context.Context, string, string) error            { return ErrNotSupport }
func (Base) Copy(context.Context, string, string) error            { return ErrNotSupport }
func (Base) Rename(context.Context, string, string) error          { return ErrNotSupport }
func (Base) Remove(context.Context, string) error                  { return ErrNotSupport }
func (Base) MakeDir(context.Context, string) error                 { return ErrNotSupport }
func (Base) Get(context.Context, string) (File, error)             { return nil, ErrNotSupport }
func (Base) Open(string) (FileReader, error)                       { return nil, ErrNotSupport }
func (Base) Create(string) (FileWriter, error)                     { return nil, ErrNotSupport }
func (Base) Close() error                                          { return nil }

type cloudFS struct {
	raw cloudfs.FS
}

func (d *cloudFS) List(ctx context.Context, path string, metas ...Meta) ([]File, error) {
	files, err := d.raw.List(ctx, path, newMeta(metas...).listOptions()...)
	if err != nil {
		return nil, err
	}
	results := make([]File, len(files))
	for i, file := range files {
		results[i] = file
	}
	return results, nil
}

func (d *cloudFS) Move(ctx context.Context, src, dst string) error { return d.raw.Move(ctx, src, dst) }
func (d *cloudFS) Copy(ctx context.Context, src, dst string) error { return d.raw.Copy(ctx, src, dst) }
func (d *cloudFS) Rename(ctx context.Context, path, newName string) error {
	return d.raw.Rename(ctx, path, newName)
}
func (d *cloudFS) Remove(ctx context.Context, path string) error { return d.raw.Remove(ctx, path) }
func (d *cloudFS) MakeDir(ctx context.Context, path string) error { return d.raw.MakeDir(ctx, path) }

func (d *cloudFS) Get(ctx context.Context, path string) (File, error) {
	return d.raw.Stat(ctx, path)
}

func (d *cloudFS) Open(path string) (FileReader, error) {
	return d.raw.Open(context.Background(), path)
}

func (d *cloudFS) Create(path string) (FileWriter, error) {
	return d.raw.Create(context.Background(), path)
}

func (d *cloudFS) Close() error { return d.raw.Close() }

var allOptions map[string]OptionCreator

func wrapCloudFS(fs cloudfs.FS) FS {
	return &cloudFS{raw: fs}
}

func normalizeDriverName(name string) string {
	switch name {
	case "alist":
		return "openlist"
	case "githubRelease":
		return "github-release"
	default:
		return name
	}
}

func driverFromCloudFS(name, option string) (FS, error) {
	raw, err := NewCloudFS(name, option)
	if err != nil {
		return nil, err
	}
	return wrapCloudFS(raw), nil
}

func NewCloudFS(name, option string) (cloudfs.FS, error) {
	if creator, ok := allOptions[name]; ok {
		opt := creator()
		if err := json.Unmarshal([]byte(option), opt); err != nil {
			return nil, err
		}
		fs, err := opt.NewFS()
		if err != nil {
			return nil, err
		}
		return AsCloudFS(fs), nil
	}

	raw, err := cloudfsdriver.NewFromString(normalizeDriverName(name), option)
	if err != nil {
		return nil, err
	}

	wraps, err := wrapFuncsFromJSON(option)
	if err != nil {
		_ = raw.Close()
		return nil, err
	}
	if len(wraps) > 0 {
		raw, err = cloudfs.New(raw, wraps...)
		if err != nil {
			return nil, err
		}
	}
	return raw, nil
}

func DriverFS(name string, option string) (FS, error) {
	if creator, ok := allOptions[name]; ok {
		opt := creator()
		if err := json.Unmarshal([]byte(option), opt); err != nil {
			return nil, err
		}
		return opt.NewFS()
	}
	return driverFromCloudFS(name, option)
}

func Verify(name string, option string) error {
	if creator, ok := allOptions[name]; ok {
		opt := creator()
		if err := json.Unmarshal([]byte(option), opt); err != nil {
			return err
		}
		return VerifyOption(opt)
	}

	if err := cloudfsdriver.VerifyOption(normalizeDriverName(name), option); err != nil {
		return err
	}
	return verifyWrapOptionJSON(option)
}

func Exists(name string) bool {
	if _, ok := allOptions[name]; ok {
		return true
	}
	return cloudfsdriver.Exists(normalizeDriverName(name))
}

func Register(typ string, creator OptionCreator) {
	allOptions[typ] = creator
}

func init() {
	allOptions = make(map[string]OptionCreator)
}

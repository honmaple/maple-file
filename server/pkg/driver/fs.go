package driver

import (
	"context"
	"encoding/json"
	"fmt"
	"io/fs"
	"path/filepath"
)

type (
	FS interface {
		List(context.Context, string) ([]File, error)
		Move(context.Context, string, string) error
		Copy(context.Context, string, string) error
		Rename(context.Context, string, string) error
		Remove(context.Context, string) error
		MakeDir(context.Context, string) error
		Get(string) (File, error)
		Open(string) (FileReader, error)
		Create(string) (FileWriter, error)
		Close() error
	}
	WalkDirFunc func(string, File, error) error

	Option interface {
		NewFS() (FS, error)
	}
	OptionCreator func() Option
)

type (
	Base       struct{}
	BaseOption struct {
		RootPath    string   `json:"root_path" validate:"omitempty,startswith=/"`
		HiddenFiles []string `json:"hidden_files"`
	}
)

func (Base) List(context.Context, string) ([]File, error) { return nil, ErrNotSupport }
func (Base) Move(context.Context, string, string) error   { return ErrNotSupport }
func (Base) Copy(context.Context, string, string) error   { return ErrNotSupport }
func (Base) Rename(context.Context, string, string) error { return ErrNotSupport }
func (Base) Remove(context.Context, string) error         { return ErrNotSupport }
func (Base) MakeDir(context.Context, string) error        { return ErrNotSupport }
func (Base) Get(string) (File, error)                     { return nil, ErrNotSupport }
func (Base) Open(string) (FileReader, error)              { return nil, ErrNotSupport }
func (Base) Create(string) (FileWriter, error)            { return nil, ErrNotSupport }
func (Base) Close() error                                 { return nil }

var allOptions map[string]OptionCreator

func walkDir(ctx context.Context, srcFS FS, root string, d File, walkDirFn WalkDirFunc) error {
	if err := walkDirFn(root, d, nil); err != nil || !d.IsDir() {
		if err == fs.SkipDir && d.IsDir() {
			err = nil
		}
		return err
	}

	files, err := srcFS.List(ctx, filepath.Join(d.Path(), d.Name()))
	if err != nil {
		err = walkDirFn(root, d, err)
		if err != nil {
			if err == fs.SkipDir && d.IsDir() {
				err = nil
			}
			return err
		}
		return err
	}
	for _, file := range files {
		name := filepath.Join(root, file.Name())
		if err := walkDir(ctx, srcFS, name, file, walkDirFn); err != nil {
			if err == fs.SkipDir {
				break
			}
			return err
		}
	}
	return nil
}

func WalkDir(ctx context.Context, srcFS FS, root string, walkDirFn WalkDirFunc) error {
	info, err := srcFS.Get(root)
	if err != nil {
		err = walkDirFn(root, nil, err)
	} else {
		err = walkDir(ctx, srcFS, root, info, walkDirFn)
	}
	if err == fs.SkipDir || err == fs.SkipAll {
		return nil
	}
	return err
}

func DriverFS(driver string, option string) (FS, error) {
	creator, ok := allOptions[driver]
	if !ok {
		return nil, fmt.Errorf("The driver %s not found", driver)
	}
	opt := creator()
	if err := json.Unmarshal([]byte(option), opt); err != nil {
		return nil, err
	}
	return opt.NewFS()
}

func Verify(driver string, option string) error {
	creator, ok := allOptions[driver]
	if !ok {
		return fmt.Errorf("The driver %s not found", driver)
	}
	opt := creator()
	if err := json.Unmarshal([]byte(option), opt); err != nil {
		return err
	}
	return VerifyOption(opt)
}

func Exists(driver string) bool {
	_, ok := allOptions[driver]
	return ok
}

func Register(typ string, creator OptionCreator) {
	allOptions[typ] = creator
}

func init() {
	allOptions = make(map[string]OptionCreator)
}

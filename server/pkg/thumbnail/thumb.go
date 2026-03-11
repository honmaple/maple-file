package thumbnail

import (
	"context"
	"io"
)

type (
	Option interface {
		New() (Generator, error)
		Match(string) bool
	}
	Generator interface {
		Generate(context.Context, io.ReadSeeker, int64) (io.ReadCloser, error)
	}
	GeneratorFactory = func() Option
)

var generatorFactories []GeneratorFactory

func Register(name string, factory GeneratorFactory) {
	generatorFactories = append(generatorFactories, factory)
}

func init() {
	generatorFactories = make([]GeneratorFactory, 0)

	Register("image", func() Option {
		return &ImageOption{}
	})
}

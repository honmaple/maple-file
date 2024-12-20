package runner

import (
	"io"

	"github.com/sirupsen/logrus"
)

type Logger interface {
	Info(...interface{})
	Infof(string, ...interface{})
	Error(...interface{})
	Errorf(string, ...interface{})
}

func NewLogger(out io.Writer) Logger {
	return &logrus.Logger{
		Out: out,
		Formatter: &logrus.TextFormatter{
			DisableTimestamp: false,
			FullTimestamp:    true,
		},
		Level: logrus.InfoLevel,
	}
}

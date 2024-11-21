package runner

import (
	"bytes"
	"io"

	"github.com/sirupsen/logrus"
)

type Logger interface {
	Info(...interface{})
	Infof(string, ...interface{})
	Error(...interface{})
	Errorf(string, ...interface{})
	// String() string
}

type tasklog struct {
	*logrus.Logger
	buf *bytes.Buffer
}

func (t *tasklog) String() string {
	return t.buf.String()
}

func NewLogger(out io.Writer) Logger {
	return &tasklog{
		Logger: &logrus.Logger{
			Out: out,
			Formatter: &logrus.TextFormatter{
				DisableTimestamp: false,
				FullTimestamp:    true,
			},
			Level: logrus.InfoLevel,
		},
	}
}

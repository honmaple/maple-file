package runner

import (
	"fmt"
	"io"
	"strings"

	"github.com/sirupsen/logrus"
)

type Logger interface {
	Info(...any)
	Infof(string, ...any)
	Error(...any)
	Errorf(string, ...any)
}

type LoggerFormatter struct {
}

func (f *LoggerFormatter) Format(entry *logrus.Entry) ([]byte, error) {
	s := fmt.Sprintf("[%s] %s - %s\n",
		strings.ToUpper(entry.Level.String()),
		entry.Time.Format("2006-01-02 15:04:05"),
		entry.Message,
	)
	return []byte(s), nil
}

func NewLogger(out io.Writer) Logger {
	return &logrus.Logger{
		Out:       out,
		Formatter: &LoggerFormatter{},
		Level:     logrus.InfoLevel,
	}
}

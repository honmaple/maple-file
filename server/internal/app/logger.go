package app

import (
	"io"
	"os"
	"strings"

	"github.com/sirupsen/logrus"
	"gopkg.in/natefinch/lumberjack.v2"

	"github.com/honmaple/maple-file/server/internal/app/config"
)

var levels = map[string]logrus.Level{
	"debug": logrus.DebugLevel,
	"info":  logrus.InfoLevel,
	"warn":  logrus.WarnLevel,
	"error": logrus.ErrorLevel,
}

type Logger struct {
	*logrus.Logger
	lu *lumberjack.Logger
}

func (log *Logger) Close() error {
	if log.lu == nil {
		return nil
	}
	return log.lu.Close()
}

func NewLogger(conf *Config) *Logger {
	log := &Logger{}

	level, ok := levels[conf.GetString(config.LoggerLevel)]
	if !ok {
		level = logrus.InfoLevel
	}

	outs := make(map[string]bool)
	for _, i := range strings.Split(conf.GetString(config.LoggerOutput), "|") {
		outs[strings.TrimSpace(i)] = true
	}

	outWriters := make([]io.Writer, 0)
	for k := range outs {
		switch k {
		case "file":
			out := &lumberjack.Logger{
				// Filename:   conf.GetDocumentsPath(conf.GetString(config.LoggerFile)),
				MaxAge:     conf.GetInt(config.LoggerFileMaxAge),
				MaxSize:    conf.GetInt(config.LoggerFileMaxSize),
				MaxBackups: conf.GetInt(config.LoggerFileMaxBackup),
			}
			log.lu = out

			outWriters = append(outWriters, out)
		case "stdout":
			outWriters = append(outWriters, os.Stdout)
		case "stderr":
			outWriters = append(outWriters, os.Stderr)
		}
	}
	if len(outWriters) == 0 {
		outWriters = append(outWriters, os.Stdout)
	}
	timestamp := conf.GetBool(config.LoggerTimestamp)

	log.Logger = &logrus.Logger{
		Out: io.MultiWriter(outWriters...),
		Formatter: &logrus.TextFormatter{
			DisableTimestamp: !timestamp,
			FullTimestamp:    timestamp,
		},
		Level: level,
	}
	return log
}

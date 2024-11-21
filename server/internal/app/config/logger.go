package config

import (
	"io"
	"os"
	"strings"

	"github.com/sirupsen/logrus"
	"gopkg.in/natefinch/lumberjack.v2"
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

	level, ok := levels[conf.GetString(LoggerLevel)]
	if !ok {
		level = logrus.InfoLevel
	}

	outs := make(map[string]bool)
	for _, i := range strings.Split(conf.GetString(LoggerOutput), "|") {
		outs[strings.TrimSpace(i)] = true
	}

	outWriters := make([]io.Writer, 0)
	for k := range outs {
		switch k {
		case "file":
			out := &lumberjack.Logger{
				Filename:   conf.GetString(LoggerFile),
				MaxAge:     conf.GetInt(LoggerFileMaxAge),
				MaxSize:    conf.GetInt(LoggerFileMaxSize),
				MaxBackups: conf.GetInt(LoggerFileMaxBackup),
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
	timestamp := conf.GetBool(LoggerTimestamp)

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

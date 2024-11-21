package util

import (
	"path/filepath"
	"strings"
)

func CleanPath(path string) string {
	path = filepath.Clean(path)
	if !strings.HasPrefix(path, "/") {
		path = "/" + path
	}
	return path
}

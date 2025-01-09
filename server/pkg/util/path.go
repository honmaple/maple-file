package util

import (
	filepath "path"
	"strings"
)

func CleanPath(path string) string {
	// path = filepath.FromSlash(path)
	if !strings.HasPrefix(path, "/") {
		path = "/" + path
	}
	return filepath.Clean(path)
}

func IsSubPath(path string, subPath string) bool {
	path, subPath = CleanPath(path), CleanPath(subPath)
	return path == subPath || strings.HasPrefix(subPath, path+"/")
}

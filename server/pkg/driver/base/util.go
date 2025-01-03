package base

import (
	"path/filepath"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/driver"
)

func Included(file driver.File, types []string) bool {
	if len(types) == 0 {
		return false
	}
	ext := filepath.Ext(file.Name())
	for _, typ := range types {
		exclude := false
		if strings.HasPrefix(typ, "-") {
			typ = typ[1:]
			exclude = true
		}
		if ext == typ {
			return !exclude
		}

		name := file.Name()
		if strings.Contains(typ, "/") {
			name = strings.TrimPrefix(filepath.Join(file.Path(), name), "/")
		}
		if m, _ := filepath.Match(typ, name); m {
			return !exclude
		}
	}
	return false
}

package util

import (
	"strings"
)

func Ptr[T any](x T) *T {
	return &x
}

func StrReplace(s string, vars map[string]string) string {
	if vars == nil || s == "" {
		return s
	}
	args := make([]string, 0)
	for k, v := range vars {
		args = append(args, k)
		args = append(args, v)
	}
	r := strings.NewReplacer(args...)
	return r.Replace(s)
}

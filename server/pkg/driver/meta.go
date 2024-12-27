package driver

import (
	"github.com/spf13/viper"
)

type (
	meta struct {
		*viper.Viper
	}
	Meta func(*meta)
)

func NewMeta(metas ...Meta) *meta {
	m := &meta{viper.New()}
	for _, meta := range metas {
		meta(m)
	}
	return m
}

func WithMeta(m map[string]any) Meta {
	return func(meta *meta) {
		for k, v := range m {
			meta.Set(k, v)
		}
	}
}

func WithPassword(pw string) Meta {
	return func(meta *meta) {
		meta.Set("password", pw)
	}
}

func WithForce(force bool) Meta {
	return func(meta *meta) {
		meta.Set("force", force)
	}
}

func WithOverride(pw string) Meta {
	return func(meta *meta) {
		meta.Set("override", pw)
	}
}

func WithPagination(page int, pageSize int) Meta {
	if page < 1 {
		page = 1
	}
	if pageSize < 0 {
		pageSize = 0
	}
	offset := (page - 1) * pageSize
	if offset < 0 {
		offset = 0
	}
	return func(meta *meta) {
		meta.Set("page", page)
		meta.Set("offset", offset)
		meta.Set("page_size", pageSize)
	}
}

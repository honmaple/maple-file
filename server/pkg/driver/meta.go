package driver

import (
	"github.com/spf13/viper"
	"sort"
)

type (
	meta struct {
		*viper.Viper
	}
	Meta func(*meta)
)

func (m *meta) Sort(files []File) []File {
	desc := m.GetBool("desc")
	switch m.GetString("order") {
	case "name":
		sort.SliceStable(files, func(i, j int) bool {
			if desc {
				return files[i].Name() > files[j].Name()
			}
			return files[i].Name() < files[j].Name()
		})
	case "type":
		sort.SliceStable(files, func(i, j int) bool {
			if desc {
				return files[i].Type() > files[j].Type()
			}
			return files[i].Type() < files[j].Type()
		})
	case "size":
		sort.SliceStable(files, func(i, j int) bool {
			if desc {
				return files[i].Size() > files[j].Size()
			}
			return files[i].Size() < files[j].Size()
		})
	case "time":
		sort.SliceStable(files, func(i, j int) bool {
			if desc {
				return files[i].ModTime().After(files[j].ModTime())
			}
			return files[i].ModTime().Before(files[j].ModTime())
		})
	}
	return files
}

func (m *meta) Paginator(files []File) []File {
	page, pageSize := m.GetInt("page"), m.GetInt("page_size")
	if pageSize <= 0 {
		return files
	}

	if page <= 0 {
		page = 1
	}
	total := len(files)
	start := (page - 1) * pageSize
	if start > total {
		return []File{}
	}
	end := start + pageSize
	if end > total {
		end = total
	}
	return files[start:end]
}

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

func WithAutoRename(rename bool) Meta {
	return func(meta *meta) {
		meta.Set("auto_rename", rename)
	}
}

func WithOverride(pw string) Meta {
	return func(meta *meta) {
		meta.Set("override", pw)
	}
}

func WithOrder(order string, desc bool) Meta {
	return func(meta *meta) {
		meta.Set("desc", desc)
		meta.Set("order", order)
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

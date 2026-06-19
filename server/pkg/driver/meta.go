package driver

import "github.com/honmaple/cloudfs"

type Meta = cloudfs.ListOption

func WithMeta(m map[string]any) Meta {
	return cloudfs.ListOption(m)
}

func WithPassword(pw string) Meta {
	return cloudfs.ListOption{"password": pw}
}

func WithForce(force bool) Meta {
	return cloudfs.ListOption{"force": force}
}

func WithAutoRename(rename bool) Meta {
	return cloudfs.ListOption{"auto_rename": rename}
}

func WithOverride(pw string) Meta {
	return cloudfs.ListOption{"override": pw}
}

func WithOrder(order string, desc bool) Meta {
	return cloudfs.ListOption{
		"desc":  desc,
		"order": order,
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

	return cloudfs.ListOption{
		"page":      page,
		"offset":    offset,
		"page_size": pageSize,
	}
}

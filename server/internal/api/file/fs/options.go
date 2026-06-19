package fs

import (
	"github.com/honmaple/cloudfs"
	"github.com/honmaple/maple-file/server/pkg/driver"
)

func WithOrder(order string, desc bool) cloudfs.ListOption {
	return driver.WithOrder(order, desc)
}

func WithPagination(page int, pageSize int) cloudfs.ListOption {
	return driver.WithPagination(page, pageSize)
}

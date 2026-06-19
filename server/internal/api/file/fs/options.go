package fs

import "github.com/honmaple/maple-file/server/pkg/driver"

func WithOrder(order string, desc bool) driver.Meta {
	return driver.WithOrder(order, desc)
}

func WithPagination(page int, pageSize int) driver.Meta {
	return driver.WithPagination(page, pageSize)
}

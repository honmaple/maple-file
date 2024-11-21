package driver

import (
	"errors"
)

var (
	ErrNotSupport     = errors.New("operate not support")
	ErrSrcNotExist    = errors.New("src is not exists")
	ErrDstIsExist     = errors.New("dst already exists")
	ErrDriverNotExist = errors.New("driver is not exists")
)

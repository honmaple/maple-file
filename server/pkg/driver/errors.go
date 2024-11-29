package driver

import (
	"errors"
)

var (
	ErrOption         = errors.New("driver's option err")
	ErrNotSupport     = errors.New("operate not support")
	ErrSrcNotExist    = errors.New("src is not exists")
	ErrDstIsExist     = errors.New("dst already exists")
	ErrDriverNotExist = errors.New("driver is not exists")
)

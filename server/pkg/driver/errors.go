package driver

import (
	"errors"

	"github.com/honmaple/maple-file/server/pkg/util"
)

var (
	ErrOption         = errors.New("driver's option err")
	ErrNotSupport     = errors.New("operate not support")
	ErrSrcNotExist    = errors.New("src is not exists")
	ErrDstIsExist     = errors.New("dst already exists")
	ErrDriverNotExist = errors.New("driver is not exists")
	ErrOpenDirectory  = errors.New("can't open a directory")

	VerifyOption = util.VerifyOption
)

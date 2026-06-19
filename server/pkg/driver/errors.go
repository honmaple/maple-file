package driver

import (
	"github.com/honmaple/cloudfs"
	"github.com/honmaple/maple-file/server/pkg/util"
)

var (
	ErrOption         = cloudfs.ErrOption
	ErrNotSupport     = cloudfs.ErrNotSupport
	ErrSrcNotExist    = cloudfs.ErrSrcNotExist
	ErrDstNotExist    = cloudfs.ErrDstNotExist
	ErrDstIsExist     = cloudfs.ErrDstIsExist
	ErrDriverNotExist = cloudfs.ErrDriverNotExist
	ErrOpenDirectory  = cloudfs.ErrOpenDirectory

	VerifyOption = util.VerifyOption
)

func UnderlyingError(err error) error {
	return cloudfs.UnderlyingError(err)
}

package driver

import (
	"errors"
	"os"

	"github.com/honmaple/maple-file/server/pkg/util"
)

var (
	ErrOption         = errors.New("driver's option err")
	ErrNotSupport     = errors.New("operate not support")
	ErrSrcNotExist    = errors.New("src is not exists")
	ErrDstNotExist    = errors.New("dst is not exists")
	ErrDstIsExist     = errors.New("dst already exists")
	ErrDriverNotExist = errors.New("driver is not exists")
	ErrOpenDirectory  = errors.New("can't open a directory")

	VerifyOption = util.VerifyOption
)

func UnderlyingError(err error) error {
	for err != nil {
		switch e := err.(type) {
		case *os.PathError:
			err = e.Err
		case *os.LinkError:
			err = e.Err
		case *os.SyscallError:
			err = e.Err
		default:
			return err
		}
	}
	return err
}

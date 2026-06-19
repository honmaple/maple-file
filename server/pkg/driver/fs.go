package driver

import (
	"github.com/honmaple/cloudfs"
	cloudfsdriver "github.com/honmaple/cloudfs/driver"
)

type FS = cloudfs.FS

func normalizeDriverName(name string) string {
	switch name {
	case "alist":
		return "openlist"
	case "githubRelease":
		return "github-release"
	default:
		return name
	}
}

func NewCloudFS(name, option string) (cloudfs.FS, error) {
	raw, err := cloudfsdriver.NewFromString(normalizeDriverName(name), option)
	if err != nil {
		return nil, err
	}

	wraps, err := wrapFuncsFromJSON(option)
	if err != nil {
		_ = raw.Close()
		return nil, err
	}
	if len(wraps) > 0 {
		raw, err = cloudfs.New(raw, wraps...)
		if err != nil {
			return nil, err
		}
	}
	return raw, nil
}

func Verify(name string, option string) error {
	if err := cloudfsdriver.VerifyOption(normalizeDriverName(name), option); err != nil {
		return err
	}
	return verifyWrapOptionJSON(option)
}

func Exists(name string) bool {
	return cloudfsdriver.Exists(normalizeDriverName(name))
}

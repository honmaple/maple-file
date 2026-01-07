package file

import (
	"github.com/honmaple/maple-file/server/internal/api/file/service"
	"github.com/honmaple/maple-file/server/internal/app"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"

	_ "github.com/honmaple/maple-file/server/pkg/driver/115"
	_ "github.com/honmaple/maple-file/server/pkg/driver/alist"
	_ "github.com/honmaple/maple-file/server/pkg/driver/foxel"
	_ "github.com/honmaple/maple-file/server/pkg/driver/ftp"
	_ "github.com/honmaple/maple-file/server/pkg/driver/github"
	_ "github.com/honmaple/maple-file/server/pkg/driver/local"
	_ "github.com/honmaple/maple-file/server/pkg/driver/mirror"
	_ "github.com/honmaple/maple-file/server/pkg/driver/quark"
	_ "github.com/honmaple/maple-file/server/pkg/driver/s3"
	_ "github.com/honmaple/maple-file/server/pkg/driver/sftp"
	_ "github.com/honmaple/maple-file/server/pkg/driver/smb"
	_ "github.com/honmaple/maple-file/server/pkg/driver/upyun"
	_ "github.com/honmaple/maple-file/server/pkg/driver/webdav"
)

func init() {
	app.Register("file", func(app *app.App) (app.Service, error) {
		if err := app.DB.AutoMigrate(
			new(pb.Repo),
		); err != nil {
			return nil, err
		}
		return service.New(app), nil
	})
}

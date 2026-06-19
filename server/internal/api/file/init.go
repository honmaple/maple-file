package file

import (
	"github.com/honmaple/maple-file/server/internal/api/file/service"
	"github.com/honmaple/maple-file/server/internal/app"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"

	_ "github.com/honmaple/cloudfs/driver/all"
	_ "github.com/honmaple/maple-file/server/pkg/driver/mirror"
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

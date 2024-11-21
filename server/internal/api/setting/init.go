package base

import (
	"github.com/honmaple/maple-file/server/internal/api/setting/service"
	"github.com/honmaple/maple-file/server/internal/app"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/setting"
)

func init() {
	app.Register("setting", func(app *app.App) (app.Service, error) {
		if err := app.DB.AutoMigrate(
			new(pb.Setting),
		); err != nil {
			return nil, err
		}
		return service.New(app), nil
	})
}

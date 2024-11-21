package task

import (
	"github.com/honmaple/maple-file/server/internal/api/task/service"
	"github.com/honmaple/maple-file/server/internal/app"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/task"
)

func init() {
	app.Register("task", func(app *app.App) (app.Service, error) {
		if err := app.DB.AutoMigrate(
			new(pb.Task),
		); err != nil {
			return nil, err
		}
		return service.New(app), nil
	})
}

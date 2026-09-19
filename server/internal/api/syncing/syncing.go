package syncing

import (
	"github.com/honmaple/maple-file/server/internal/api/syncing/repository"
	"github.com/honmaple/maple-file/server/internal/api/syncing/service"
	"github.com/honmaple/maple-file/server/internal/api/syncing/types"
	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/samber/do/v2"
)

type Context = types.Context
type Service = service.Service
type Repository = repository.Repository

func Provide(i do.Injector) {
	do.Provide(i, func(i do.Injector) (*Context, error) {
		ctx, err := do.Invoke[*app.Context](i)
		if err != nil {
			return nil, err
		}
		return types.NewContext(ctx), nil
	})
	do.Provide(i, func(i do.Injector) (Repository, error) {
		ctx, err := do.Invoke[*Context](i)
		if err != nil {
			return nil, err
		}
		return repository.New(ctx), nil
	})
	do.Provide(i, func(i do.Injector) (Service, error) {
		ctx, err := do.Invoke[*Context](i)
		if err != nil {
			return nil, err
		}
		repo, err := do.Invoke[Repository](i)
		if err != nil {
			return nil, err
		}
		return service.New(ctx, repo)
	})
}

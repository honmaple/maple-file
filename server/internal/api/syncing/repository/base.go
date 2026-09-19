package repository

import "github.com/honmaple/maple-file/server/internal/api/syncing/types"

type (
	Repository interface {
		ProfileRepository
		RecordRepository
		HistoryRepository
	}
	repository struct {
		ctx *types.Context
	}
)

var _ Repository = (*repository)(nil)

func New(ctx *types.Context) Repository {
	return &repository{ctx: ctx}
}

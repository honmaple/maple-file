package service

import (
	"context"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/honmaple/maple-file/server/internal/api/shared"
	"github.com/honmaple/maple-file/server/internal/api/syncing/repository"
	"github.com/honmaple/maple-file/server/internal/api/syncing/types"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/syncing"
	"google.golang.org/grpc"
)

type (
	Service interface {
		shared.Service
		pb.SyncServiceServer
	}
	serviceImpl struct {
		shared.ServiceImpl
		pb.UnimplementedSyncServiceServer
		repo repository.Repository
	}
)

func New(ctx *types.Context, repo repository.Repository) (Service, error) {
	if err := ctx.DB.AutoMigrate(
		new(pb.SyncProfile),
		new(pb.SyncRecord),
		new(pb.SyncHistory),
		new(pb.SyncHistoryIssue),
	); err != nil {
		return nil, err
	}
	if err := repo.InterruptHistories(context.Background()); err != nil {
		return nil, err
	}
	return &serviceImpl{repo: repo}, nil
}

func (srv *serviceImpl) Register(server *grpc.Server) {
	pb.RegisterSyncServiceServer(server, srv)
}

func (srv *serviceImpl) RegisterGateway(ctx context.Context, mux *runtime.ServeMux) {
	pb.RegisterSyncServiceHandlerServer(ctx, mux, srv)
}

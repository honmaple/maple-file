package service

import (
	"context"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/syncing"
)

func (srv *serviceImpl) ListProfiles(ctx context.Context, _ *pb.SyncProfile_ListRequest) (*pb.SyncProfile_ListResponse, error) {
	results, err := srv.repo.ListProfiles(ctx)
	return &pb.SyncProfile_ListResponse{Results: results}, err
}

func (srv *serviceImpl) CreateProfile(ctx context.Context, req *pb.SyncProfile_CreateRequest) (*pb.SyncProfile_CreateResponse, error) {
	result, err := srv.repo.CreateProfile(ctx, req.GetPayload())
	if err != nil {
		return nil, err
	}
	return &pb.SyncProfile_CreateResponse{Result: result}, nil
}

func (srv *serviceImpl) UpdateProfile(ctx context.Context, req *pb.SyncProfile_UpdateRequest) (*pb.SyncProfile_UpdateResponse, error) {
	result, err := srv.repo.UpdateProfile(ctx, req.GetPayload())
	return &pb.SyncProfile_UpdateResponse{Result: result}, err
}

func (srv *serviceImpl) DeleteProfile(ctx context.Context, req *pb.SyncProfile_DeleteRequest) (*pb.SyncProfile_DeleteResponse, error) {
	if err := srv.repo.DeleteProfile(ctx, req.GetId()); err != nil {
		return nil, err
	}
	return &pb.SyncProfile_DeleteResponse{}, nil
}

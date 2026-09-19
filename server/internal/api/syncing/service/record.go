package service

import (
	"context"
	"errors"

	"github.com/honmaple/maple-file/server/internal/api/syncing/repository"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/syncing"
)

func (srv *serviceImpl) ListRecords(ctx context.Context, req *pb.SyncRecord_ListRequest) (*pb.SyncRecord_ListResponse, error) {
	profile, err := srv.repo.GetProfile(ctx, req.GetProfileId())
	if err != nil {
		return nil, err
	}
	keys, err := repository.AlbumSourceKeys(profile)
	if err != nil {
		return nil, err
	}
	if _, ok := keys[req.GetSourcePath()]; !ok {
		return nil, errors.New("同步来源不存在")
	}
	results, err := srv.repo.ListRecords(ctx, req.GetProfileId(), req.GetSourcePath(), req.GetSourceKeys())
	return &pb.SyncRecord_ListResponse{Results: results}, err
}

func (srv *serviceImpl) UpsertRecords(ctx context.Context, req *pb.SyncRecord_UpsertRequest) (*pb.SyncRecord_UpsertResponse, error) {
	for _, item := range req.GetResults() {
		if item == nil {
			return nil, errors.New("同步记录参数错误")
		}
		profile, err := srv.repo.GetProfile(ctx, item.GetProfileId())
		if err != nil {
			return nil, err
		}
		keys, err := repository.AlbumSourceKeys(profile)
		if err != nil {
			return nil, err
		}
		_, sourceConfigured := keys[item.GetSourcePath()]
		if !sourceConfigured || item.GetSourceKey() == "" || item.GetTargetPath() == "" ||
			item.GetState() != pb.SyncRecord_STATE_ACTIVE || item.GetConfigVersion() != profile.GetConfigVersion() ||
			(item.SourceSize != nil && item.GetSourceSize() < 0) || (item.TargetSize != nil && item.GetTargetSize() < 0) {
			return nil, errors.New("同步记录参数错误")
		}
		item.Id = 0
	}
	if err := srv.repo.UpsertRecords(ctx, req.GetResults()); err != nil {
		return nil, err
	}
	return &pb.SyncRecord_UpsertResponse{}, nil
}

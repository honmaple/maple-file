package service

import (
	"context"
	"errors"
	"strings"
	"time"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/syncing"
)

func (srv *serviceImpl) ListHistories(ctx context.Context, req *pb.SyncHistory_ListRequest) (*pb.SyncHistory_ListResponse, error) {
	if req.GetProfileId() == 0 {
		return nil, errors.New("同步配置不存在")
	}
	results, err := srv.repo.ListHistories(ctx, req.GetProfileId(), req.GetBeforeId(), historyLimit(req.GetLimit()))
	return &pb.SyncHistory_ListResponse{Results: results}, err
}

func historyLimit(value int32) int {
	if value <= 0 {
		return 20
	}
	if value > 100 {
		return 100
	}
	return int(value)
}

func validHistoryIssues(issues []*pb.SyncHistoryIssue) bool {
	for _, issue := range issues {
		if issue == nil || issue.GetErrorMessage() == "" || (issue.GetKind() != pb.SyncHistoryIssue_KIND_ERROR && issue.GetKind() != pb.SyncHistoryIssue_KIND_CONFLICT) {
			return false
		}
	}
	return true
}

func (srv *serviceImpl) CreateHistory(ctx context.Context, req *pb.SyncHistory_CreateRequest) (*pb.SyncHistory_CreateResponse, error) {
	value := req.GetPayload()
	if value == nil || value.GetProfileId() == 0 || strings.TrimSpace(value.GetRunId()) == "" || value.GetStartedAt() == nil || value.GetFinishedAt() == nil || value.GetFinishedAt().AsTime().Before(value.GetStartedAt().AsTime()) || value.GetStatus() == pb.SyncHistory_STATUS_RUNNING || value.GetStatus() == pb.SyncHistory_STATUS_UNSPECIFIED || !validHistoryIssues(value.GetIssues()) {
		return nil, errors.New("运行记录参数错误")
	}
	result, err := srv.repo.CreateHistory(ctx, value)
	return &pb.SyncHistory_CreateResponse{Result: result}, err
}

func (srv *serviceImpl) StartHistory(ctx context.Context, req *pb.SyncHistory_StartRequest) (*pb.SyncHistory_StartResponse, error) {
	value := req.GetPayload()
	if value == nil || value.GetProfileId() == 0 || strings.TrimSpace(value.GetRunId()) == "" || value.GetStartedAt() == nil || value.GetTrigger() == pb.SyncHistory_TRIGGER_UNSPECIFIED {
		return nil, errors.New("运行记录参数错误")
	}
	if value.GetStartedAt().AsTime().After(time.Now().Add(time.Minute)) {
		return nil, errors.New("开始时间无效")
	}
	profile, err := srv.repo.GetProfile(ctx, value.GetProfileId())
	if err != nil {
		return nil, err
	}
	value.ConfigVersion = profile.GetConfigVersion()
	result, err := srv.repo.StartHistory(ctx, value)
	return &pb.SyncHistory_StartResponse{Result: result}, err
}

func (srv *serviceImpl) FinishHistory(ctx context.Context, req *pb.SyncHistory_FinishRequest) (*pb.SyncHistory_FinishResponse, error) {
	value := req.GetPayload()
	if value == nil || value.GetProfileId() == 0 || value.GetRunId() == "" || value.GetFinishedAt() == nil || value.GetStatus() == pb.SyncHistory_STATUS_RUNNING || value.GetStatus() == pb.SyncHistory_STATUS_UNSPECIFIED || value.GetScanned() < 0 || value.GetSynced() < 0 || value.GetSkipped() < 0 || value.GetFailed() < 0 || value.GetConflicted() < 0 || !validHistoryIssues(value.GetIssues()) {
		return nil, errors.New("运行结果参数错误")
	}
	result, err := srv.repo.FinishHistory(ctx, value)
	return &pb.SyncHistory_FinishResponse{Result: result}, err
}

func (srv *serviceImpl) ListHistoryIssues(ctx context.Context, req *pb.SyncHistoryIssue_ListRequest) (*pb.SyncHistoryIssue_ListResponse, error) {
	if req.GetHistoryId() == 0 {
		return nil, errors.New("运行记录不存在")
	}
	results, err := srv.repo.ListHistoryIssues(ctx, req)
	return &pb.SyncHistoryIssue_ListResponse{Results: results}, err
}

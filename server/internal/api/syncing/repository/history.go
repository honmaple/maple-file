package repository

import (
	"context"
	"errors"
	"time"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/syncing"
	"gorm.io/gorm"
)

type HistoryRepository interface {
	ListHistories(context.Context, int32, int64, int) ([]*pb.SyncHistory, error)
	ListHistoryIssues(context.Context, *pb.SyncHistoryIssue_ListRequest) ([]*pb.SyncHistoryIssue, error)
	CreateHistory(context.Context, *pb.SyncHistory) (*pb.SyncHistory, error)
	StartHistory(context.Context, *pb.SyncHistory) (*pb.SyncHistory, error)
	FinishHistory(context.Context, *pb.SyncHistory) (*pb.SyncHistory, error)
	InterruptHistories(context.Context) error
}

var _ HistoryRepository = (*repository)(nil)

func historyLimit(value int32) int {
	if value <= 0 {
		return 20
	}
	if value > 100 {
		return 100
	}
	return int(value)
}

func (repo *repository) ListHistories(ctx context.Context, profileID int32, beforeID int64, limit int) ([]*pb.SyncHistory, error) {
	results := make([]*pb.SyncHistory, 0)
	query := repo.ctx.DB.WithContext(ctx).Where("profile_id = ?", profileID)
	if beforeID > 0 {
		query = query.Where("id < ?", beforeID)
	}
	if err := query.Order("id DESC").Limit(limit).Find(&results).Error; err != nil {
		return nil, err
	}
	if len(results) == 0 {
		return results, nil
	}
	ids := make([]int64, 0, len(results))
	byID := make(map[int64]*pb.SyncHistory, len(results))
	for _, result := range results {
		ids = append(ids, result.Id)
		byID[result.Id] = result
	}
	var issues []*pb.SyncHistoryIssue
	if err := repo.ctx.DB.WithContext(ctx).Where("history_id IN ?", ids).Order("id ASC").Find(&issues).Error; err != nil {
		return nil, err
	}
	for _, issue := range issues {
		byID[issue.HistoryId].Issues = append(byID[issue.HistoryId].Issues, issue)
	}
	return results, nil
}

func (repo *repository) ListHistoryIssues(ctx context.Context, req *pb.SyncHistoryIssue_ListRequest) ([]*pb.SyncHistoryIssue, error) {
	results := make([]*pb.SyncHistoryIssue, 0)
	query := repo.ctx.DB.WithContext(ctx).Where("history_id = ?", req.GetHistoryId())
	if req.GetKind() != pb.SyncHistoryIssue_KIND_UNSPECIFIED {
		query = query.Where("kind = ?", req.GetKind())
	}
	if req.GetErrorOperation() != pb.SyncHistoryIssue_OPERATION_UNSPECIFIED {
		query = query.Where("error_operation = ?", req.GetErrorOperation())
	}
	if req.GetSourceKey() != "" {
		query = query.Where("source_key = ?", req.GetSourceKey())
	}
	if req.GetErrorCode() != "" {
		query = query.Where("error_code = ?", req.GetErrorCode())
	}
	if req.GetBeforeId() > 0 {
		query = query.Where("id < ?", req.GetBeforeId())
	}
	err := query.Order("id DESC").Limit(historyLimit(req.GetLimit())).Find(&results).Error
	return results, err
}

func (repo *repository) CreateHistory(ctx context.Context, value *pb.SyncHistory) (*pb.SyncHistory, error) {
	if _, err := repo.GetProfile(ctx, value.GetProfileId()); err != nil {
		return nil, err
	}
	return repo.createHistory(ctx, value)
}

func (repo *repository) createHistory(ctx context.Context, value *pb.SyncHistory) (*pb.SyncHistory, error) {
	value.Id = 0
	issues := value.Issues
	value.Issues = nil
	err := repo.ctx.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(value).Error; err != nil {
			return err
		}
		return createIssues(tx, value.Id, issues)
	})
	value.Issues = issues
	return value, err
}

func createIssues(tx *gorm.DB, historyID int64, issues []*pb.SyncHistoryIssue) error {
	for _, issue := range issues {
		issue.Id = 0
		issue.HistoryId = historyID
	}
	if len(issues) == 0 {
		return nil
	}
	return tx.Create(&issues).Error
}

func (repo *repository) StartHistory(ctx context.Context, value *pb.SyncHistory) (*pb.SyncHistory, error) {
	if _, err := repo.GetProfile(ctx, value.GetProfileId()); err != nil {
		return nil, err
	}
	var existing pb.SyncHistory
	err := repo.ctx.DB.WithContext(ctx).Where("run_id = ?", value.RunId).First(&existing).Error
	if err == nil {
		if existing.ProfileId != value.ProfileId {
			return nil, errors.New("运行标识与配置不匹配")
		}
		return &existing, nil
	}
	if !errors.Is(err, gorm.ErrRecordNotFound) {
		return nil, err
	}
	var active int64
	if err := repo.ctx.DB.WithContext(ctx).Model(&pb.SyncHistory{}).Where("profile_id = ? AND status = ?", value.ProfileId, pb.SyncHistory_STATUS_RUNNING).Count(&active).Error; err != nil {
		return nil, err
	}
	if active > 0 {
		return nil, errors.New("此同步配置正在运行")
	}
	value.Status = pb.SyncHistory_STATUS_RUNNING
	return repo.createHistory(ctx, value)
}

func (repo *repository) FinishHistory(ctx context.Context, value *pb.SyncHistory) (*pb.SyncHistory, error) {
	var existing pb.SyncHistory
	if err := repo.ctx.DB.WithContext(ctx).Where("run_id = ? AND profile_id = ?", value.RunId, value.ProfileId).First(&existing).Error; err != nil {
		return nil, err
	}
	if existing.Status != pb.SyncHistory_STATUS_RUNNING {
		return repo.getHistory(ctx, existing.Id)
	}
	err := repo.ctx.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		updates := map[string]any{
			"status": value.Status, "finished_at": value.FinishedAt.AsTime(), "scanned": value.Scanned,
			"synced":  value.Synced,
			"skipped": value.Skipped, "failed": value.Failed, "conflicted": value.Conflicted,
			"error_summary": value.ErrorSummary,
		}
		res := tx.Model(&pb.SyncHistory{}).Where("id = ? AND status = ?", existing.Id, pb.SyncHistory_STATUS_RUNNING).Updates(updates)
		if res.Error != nil {
			return res.Error
		}
		if res.RowsAffected != 1 {
			return errors.New("运行记录已结束")
		}
		return createIssues(tx, existing.Id, value.Issues)
	})
	if err != nil {
		return nil, err
	}
	return repo.getHistory(ctx, existing.Id)
}

func (repo *repository) getHistory(ctx context.Context, id int64) (*pb.SyncHistory, error) {
	var result pb.SyncHistory
	if err := repo.ctx.DB.WithContext(ctx).First(&result, id).Error; err != nil {
		return nil, err
	}
	if err := repo.ctx.DB.WithContext(ctx).Where("history_id = ?", id).Order("id ASC").Find(&result.Issues).Error; err != nil {
		return nil, err
	}
	return &result, nil
}

func (repo *repository) InterruptHistories(ctx context.Context) error {
	return repo.ctx.DB.WithContext(ctx).Model(&pb.SyncHistory{}).
		Where("status = ?", pb.SyncHistory_STATUS_RUNNING).
		Updates(map[string]any{"status": pb.SyncHistory_STATUS_INTERRUPTED,
			"finished_at": time.Now(), "error_summary": "上次运行意外中断"}).Error
}

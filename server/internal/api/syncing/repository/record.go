package repository

import (
	"context"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/syncing"
	"gorm.io/gorm/clause"
)

type RecordRepository interface {
	ListRecords(context.Context, int32, string, []string) ([]*pb.SyncRecord, error)
	UpsertRecords(context.Context, []*pb.SyncRecord) error
}

var _ RecordRepository = (*repository)(nil)

func (repo *repository) ListRecords(ctx context.Context, profileID int32, sourcePath string, sourceKeys []string) ([]*pb.SyncRecord, error) {
	results := make([]*pb.SyncRecord, 0)
	if len(sourceKeys) == 0 {
		return results, nil
	}
	err := repo.ctx.DB.WithContext(ctx).Where("profile_id = ? AND source_path = ? AND source_key IN ?", profileID, sourcePath, sourceKeys).Find(&results).Error
	return results, err
}

func (repo *repository) UpsertRecords(ctx context.Context, values []*pb.SyncRecord) error {
	if len(values) == 0 {
		return nil
	}
	return repo.ctx.DB.WithContext(ctx).Clauses(clause.OnConflict{
		Columns:   []clause.Column{{Name: "profile_id"}, {Name: "source_path"}, {Name: "source_key"}},
		DoUpdates: clause.AssignmentColumns([]string{"target_path", "config_version", "source_size", "target_size", "source_modified_at", "target_modified_at", "source_revision", "target_revision", "source_hash_algorithm", "source_hash", "target_hash_algorithm", "target_hash", "state", "tombstone_at", "synced_at"}),
	}).Create(&values).Error
}

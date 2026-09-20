package repository

import (
	"context"
	"encoding/json"
	"errors"
	"path/filepath"
	"reflect"
	"strings"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/syncing"
	"gorm.io/gorm"
)

type ProfileRepository interface {
	ListProfiles(context.Context) ([]*pb.SyncProfile, error)
	GetProfile(context.Context, int32) (*pb.SyncProfile, error)
	CreateProfile(context.Context, *pb.SyncProfile) (*pb.SyncProfile, error)
	UpdateProfile(context.Context, *pb.SyncProfile) (*pb.SyncProfile, error)
	DeleteProfile(context.Context, int32) error
}

var _ ProfileRepository = (*repository)(nil)

// AlbumSourceKeys validates the current album selection and returns stable keys.
func AlbumSourceKeys(value *pb.SyncProfile) (map[string]struct{}, error) {
	if value == nil || value.GetSourceType() != "album" || !validJSONObject(value.GetSourceConfig()) {
		return nil, errors.New("同步来源配置无效")
	}
	var source struct {
		AlbumIDs []string `json:"album_ids"`
	}
	if err := json.Unmarshal([]byte(value.GetSourceConfig()), &source); err != nil || len(source.AlbumIDs) == 0 {
		return nil, errors.New("请选择备份相册")
	}
	keys := make(map[string]struct{}, len(source.AlbumIDs))
	for _, id := range source.AlbumIDs {
		if id == "" {
			return nil, errors.New("相册标识不能为空")
		}
		if _, exists := keys[id]; exists {
			return nil, errors.New("不能重复添加相册")
		}
		keys[id] = struct{}{}
	}
	return keys, nil
}

type localDirectorySource struct {
	Path     string `json:"path"`
	Bookmark string `json:"bookmark"`
}

func localDirectoryConfig(value *pb.SyncProfile) (*localDirectorySource, error) {
	if value == nil || value.GetSourceType() != "local_directory" || !validJSONObject(value.GetSourceConfig()) {
		return nil, errors.New("同步来源配置无效")
	}
	var source localDirectorySource
	if err := json.Unmarshal([]byte(value.GetSourceConfig()), &source); err != nil || source.Path == "" || !filepath.IsAbs(source.Path) || filepath.Clean(source.Path) != source.Path {
		return nil, errors.New("本地目录配置无效")
	}
	return &source, nil
}

func emptyPolicy(value *pb.SyncProfile) bool {
	var policy map[string]json.RawMessage
	return json.Unmarshal([]byte(value.GetPolicyConfig()), &policy) == nil && len(policy) == 0
}

func repoTargetPath(value *pb.SyncProfile) (string, error) {
	if value.GetTargetType() != "repo_directory" {
		return "", errors.New("同步目标类型无效")
	}
	var target struct {
		Path string `json:"path"`
	}
	if json.Unmarshal([]byte(value.GetTargetConfig()), &target) != nil || target.Path == "" {
		return "", errors.New("同步目标配置无效")
	}
	return target.Path, nil
}

// ValidateSourceEntry verifies that a record belongs to its configured source.
func ValidateSourceEntry(value *pb.SyncProfile, sourcePath, sourceKey string) error {
	if sourcePath == "" {
		return errors.New("同步来源不存在")
	}
	switch value.GetSourceType() {
	case "album":
		keys, err := AlbumSourceKeys(value)
		if err != nil {
			return err
		}
		if _, ok := keys[sourcePath]; !ok {
			return errors.New("同步来源不存在")
		}
	case "local_directory":
		source, err := localDirectoryConfig(value)
		if err != nil {
			return err
		}
		cleanPath := filepath.Clean(sourcePath)
		rel, err := filepath.Rel(source.Path, cleanPath)
		if err != nil || cleanPath != sourcePath || rel == ".." || strings.HasPrefix(rel, ".."+string(filepath.Separator)) {
			return errors.New("同步来源路径越界")
		}
	default:
		return errors.New("同步来源类型无效")
	}
	if sourceKey != "" && (sourceKey == "." || sourceKey == ".." || filepath.Base(sourceKey) != sourceKey || strings.ContainsAny(sourceKey, `/\`)) {
		return errors.New("同步来源文件名无效")
	}
	return nil
}

func verifyProfile(value *pb.SyncProfile) error {
	if value == nil || value.GetName() == "" || value.GetTargetType() == "" || !validJSONObject(value.GetTargetConfig()) || !validJSONObject(value.GetPolicyConfig()) {
		return errors.New("同步配置参数不完整")
	}
	if value.GetMode() == pb.SyncProfile_MODE_UNSPECIFIED {
		return errors.New("请选择同步模式")
	}
	switch value.GetSourceType() {
	case "album":
		if _, err := AlbumSourceKeys(value); err != nil {
			return err
		}
		if value.GetMode() != pb.SyncProfile_MODE_BACKUP {
			return errors.New("相册仅支持备份模式")
		}
		if !emptyPolicy(value) {
			return errors.New("相册备份暂不支持自定义策略")
		}
		var target struct {
			Path   string `json:"path"`
			Layout string `json:"layout"`
		}
		if value.GetTargetType() != "repo_directory" || json.Unmarshal([]byte(value.GetTargetConfig()), &target) != nil || target.Path == "" || (target.Layout != "year_month_day" && target.Layout != "year_month" && target.Layout != "filename_asset_id") {
			return errors.New("相册备份目标配置无效")
		}
	case "local_directory":
		if _, err := localDirectoryConfig(value); err != nil {
			return err
		}
		if value.GetMode() != pb.SyncProfile_MODE_ONE_WAY {
			return errors.New("本地目录仅支持单向同步")
		}
		if !emptyPolicy(value) {
			return errors.New("本地目录同步暂不支持自定义策略")
		}
		if _, err := repoTargetPath(value); err != nil {
			return err
		}
	default:
		return errors.New("同步来源类型无效")
	}
	return nil
}

func (repo *repository) ListProfiles(ctx context.Context) ([]*pb.SyncProfile, error) {
	results := make([]*pb.SyncProfile, 0)
	err := repo.ctx.DB.WithContext(ctx).Order("id DESC").Find(&results).Error
	return results, err
}

func (repo *repository) GetProfile(ctx context.Context, id int32) (*pb.SyncProfile, error) {
	result := new(pb.SyncProfile)
	if err := repo.ctx.DB.WithContext(ctx).First(result, id).Error; err != nil {
		return nil, err
	}
	return result, nil
}

func (repo *repository) CreateProfile(ctx context.Context, value *pb.SyncProfile) (*pb.SyncProfile, error) {
	if value != nil && value.GetPolicyConfig() == "" {
		value.PolicyConfig = "{}"
	}
	if err := verifyProfile(value); err != nil {
		return nil, err
	}
	value.Id = 0
	value.ConfigVersion = 1
	if err := repo.ctx.DB.WithContext(ctx).Create(value).Error; err != nil {
		return nil, err
	}
	return value, nil
}

func (repo *repository) UpdateProfile(ctx context.Context, value *pb.SyncProfile) (*pb.SyncProfile, error) {
	if value == nil || value.GetId() == 0 {
		return nil, errors.New("同步配置不存在")
	}
	if err := verifyProfile(value); err != nil {
		return nil, err
	}
	current, err := repo.GetProfile(ctx, value.GetId())
	if err != nil {
		return nil, err
	}
	if value.GetSourceType() != current.GetSourceType() {
		return nil, errors.New("不能修改同步来源类型")
	}
	var oldConfig, newConfig any
	_ = json.Unmarshal([]byte(current.TargetConfig), &oldConfig)
	_ = json.Unmarshal([]byte(value.TargetConfig), &newConfig)
	version := current.ConfigVersion
	if current.TargetType != value.TargetType || !reflect.DeepEqual(oldConfig, newConfig) {
		version++
	}
	removedAlbumKeys := make([]string, 0)
	localSourceChanged := false
	switch value.GetSourceType() {
	case "album":
		oldKeys, err := AlbumSourceKeys(current)
		if err != nil {
			return nil, err
		}
		newKeys, err := AlbumSourceKeys(value)
		if err != nil {
			return nil, err
		}
		for key := range oldKeys {
			if _, retained := newKeys[key]; !retained {
				removedAlbumKeys = append(removedAlbumKeys, key)
			}
		}
	case "local_directory":
		oldSource, err := localDirectoryConfig(current)
		if err != nil {
			return nil, err
		}
		newSource, err := localDirectoryConfig(value)
		if err != nil {
			return nil, err
		}
		localSourceChanged = oldSource.Path != newSource.Path
	}
	if err := repo.ctx.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Model(current).Updates(map[string]any{
			"name": value.GetName(), "enabled": value.GetEnabled(), "mode": value.GetMode(),
			"source_type": value.GetSourceType(), "source_config": value.GetSourceConfig(),
			"target_type": value.GetTargetType(), "target_config": value.GetTargetConfig(),
			"policy_config": value.GetPolicyConfig(), "config_version": version,
		}).Error; err != nil {
			return err
		}
		for _, key := range removedAlbumKeys {
			if err := tx.Delete(&pb.SyncRecord{}, "profile_id = ? AND source_path = ?", value.GetId(), key).Error; err != nil {
				return err
			}
		}
		if localSourceChanged {
			if err := tx.Delete(&pb.SyncRecord{}, "profile_id = ?", value.GetId()).Error; err != nil {
				return err
			}
		}
		return nil
	}); err != nil {
		return nil, err
	}
	return repo.GetProfile(ctx, value.GetId())
}

func (repo *repository) DeleteProfile(ctx context.Context, id int32) error {
	return repo.ctx.DB.WithContext(ctx).Transaction(func(tx *gorm.DB) error {
		if err := tx.Delete(&pb.SyncHistoryIssue{}, "history_id IN (SELECT id FROM sync_histories WHERE profile_id = ?)", id).Error; err != nil {
			return err
		}
		if err := tx.Delete(&pb.SyncHistory{}, "profile_id = ?", id).Error; err != nil {
			return err
		}
		if err := tx.Delete(&pb.SyncRecord{}, "profile_id = ?", id).Error; err != nil {
			return err
		}
		return tx.Delete(&pb.SyncProfile{}, id).Error
	})
}

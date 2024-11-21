package service

import (
	"context"
	"encoding/json"
	"errors"
	"strings"

	// "github.com/honmaple/maple-file/server/internal/app/config"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/setting"
)

func (srv *Service) ListSettings(ctx context.Context, in *pb.ListSettingsRequest) (*pb.ListSettingsResponse, error) {
	keys := []string{}
	results := make([]*pb.Setting, 0)
	for _, key := range keys {
		cf := srv.conf.Sub(key)

		value := make(map[string]any)
		for _, k := range cf.AllKeys() {
			value[k] = cf.Get(k)
		}
		b, err := json.Marshal(value)
		if err != nil {
			return nil, err
		}
		result := &pb.Setting{
			Key:   key,
			Value: string(b),
		}
		results = append(results, result)
	}
	return &pb.ListSettingsResponse{Results: results}, nil
}

func (srv *Service) GetSetting(ctx context.Context, in *pb.GetSettingRequest) (*pb.GetSettingResponse, error) {
	key := in.GetKey()

	if !strings.HasPrefix(key, "app.") {
		return nil, errors.New("未知的设置")
	}

	cf := srv.conf.Sub(key)
	if cf == nil {
		return nil, errors.New("未知的设置")
	}

	value := make(map[string]any)
	for _, k := range cf.AllKeys() {
		value[k] = cf.Get(k)
	}

	b, err := json.Marshal(value)
	if err != nil {
		return nil, err
	}
	result := &pb.Setting{
		Key:   in.GetKey(),
		Value: string(b),
	}
	return &pb.GetSettingResponse{Result: result}, nil
}

func (srv *Service) ResetSetting(ctx context.Context, in *pb.ResetSettingRequest) (*pb.ResetSettingResponse, error) {
	return &pb.ResetSettingResponse{}, nil
}

func (srv *Service) UpdateSetting(ctx context.Context, in *pb.UpdateSettingRequest) (*pb.UpdateSettingResponse, error) {
	key := in.GetKey()

	if !strings.HasPrefix(key, "app.") {
		return nil, errors.New("未知的设置")
	}

	setting := new(pb.Setting)

	result := srv.db.WithContext(ctx).First(&setting, "key = ?", key)
	if err := result.Error; err != nil {
		if result.RowsAffected > 0 {
			return nil, err
		}
		pre := &pb.Setting{
			Key:   in.GetKey(),
			Value: in.GetValue(),
		}

		result := srv.db.WithContext(ctx).Create(pre)
		if err := result.Error; err != nil {
			return nil, err
		}
		setting = pre
	} else {
		if value := in.GetValue(); value != setting.GetValue() {
			result := srv.db.WithContext(ctx).Model(&setting).Update("value", value)
			if err := result.Error; err != nil {
				return nil, err
			}
		}
	}

	value := make(map[string]any)
	if err := json.Unmarshal([]byte(in.GetValue()), &value); err != nil {
		return nil, err
	}
	srv.conf.Set(in.GetKey(), value)
	return &pb.UpdateSettingResponse{}, nil
}

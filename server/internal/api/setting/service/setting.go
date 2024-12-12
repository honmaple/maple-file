package service

import (
	"context"
	"errors"
	"strings"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/setting"
)

func (srv *Service) GetSetting(ctx context.Context, req *pb.GetSettingRequest) (*pb.GetSettingResponse, error) {
	key := req.GetKey()

	if !strings.HasPrefix(key, "app.") {
		return nil, errors.New("未知的设置")
	}

	result := new(pb.Setting)

	q := srv.app.DB.WithContext(ctx).First(&result, "key = ?", key)
	if err := q.Error; err != nil {
		return nil, err
	}
	return &pb.GetSettingResponse{Result: result}, nil
}

func (srv *Service) UpdateSetting(ctx context.Context, req *pb.UpdateSettingRequest) (*pb.UpdateSettingResponse, error) {
	key := req.GetKey()

	if !strings.HasPrefix(key, "app.") {
		return nil, errors.New("未知的设置")
	}

	result := new(pb.Setting)

	q := srv.app.DB.WithContext(ctx).First(&result, "key = ?", key)
	if err := q.Error; err != nil {
		if q.RowsAffected > 0 {
			return nil, err
		}
		pre := &pb.Setting{
			Key:   req.GetKey(),
			Value: req.GetValue(),
		}

		if err := srv.app.DB.WithContext(ctx).Create(pre).Error; err != nil {
			return nil, err
		}
		result = pre
	} else {
		if value := req.GetValue(); value != result.GetValue() {
			result := srv.app.DB.WithContext(ctx).Model(&result).Update("value", value)
			if err := result.Error; err != nil {
				return nil, err
			}
		}
	}
	return &pb.UpdateSettingResponse{Result: result}, nil
}

func (srv *Service) ResetSetting(ctx context.Context, req *pb.ResetSettingRequest) (*pb.ResetSettingResponse, error) {
	return &pb.ResetSettingResponse{}, nil
}

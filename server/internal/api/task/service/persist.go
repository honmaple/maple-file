package service

import (
	"context"
	"errors"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/task"
)

var (
	errBadRequest = errors.New("错误的参数")
)

func (srv *Service) verifyPersistTask(task *pb.PersistTask) error {
	if task.GetName() == "" {
		return errors.New("任务名称不能为空")
	}
	if task.GetType() == "" {
		return errors.New("任务类型不能为空")
	}
	if task.GetOption() == "" {
		return errors.New("任务选项不能为空")
	}
	return nil
}

func (srv *Service) ListPersistTasks(ctx context.Context, req *pb.ListPersistTasksRequest) (*pb.ListPersistTasksResponse, error) {
	q := srv.app.DB.WithContext(ctx).Model(pb.PersistTask{})

	q = q.Order("id DESC")

	results := make([]*pb.PersistTask, 0)
	if err := q.Find(&results).Error; err != nil {
		return nil, err
	}
	return &pb.ListPersistTasksResponse{Results: results}, nil
}

func (srv *Service) CreatePersistTask(ctx context.Context, req *pb.CreatePersistTaskRequest) (*pb.CreatePersistTaskResponse, error) {
	opt := req.GetPayload()
	if opt == nil {
		return nil, errBadRequest
	}
	if err := srv.verifyPersistTask(opt); err != nil {
		return nil, err
	}

	result := srv.app.DB.WithContext(ctx).Model(pb.PersistTask{}).Create(opt)
	if err := result.Error; err != nil {
		return nil, err
	}
	return &pb.CreatePersistTaskResponse{Result: opt}, nil
}

func (srv *Service) UpdatePersistTask(ctx context.Context, req *pb.UpdatePersistTaskRequest) (*pb.UpdatePersistTaskResponse, error) {
	opt := req.GetPayload()
	if opt == nil {
		return nil, errBadRequest
	}

	if err := srv.verifyPersistTask(opt); err != nil {
		return nil, err
	}

	ins := new(pb.PersistTask)
	q := srv.app.DB.WithContext(ctx).First(&ins, "id = ?", opt.GetId())
	if err := q.Error; err != nil {
		return nil, err
	}

	diff := make(map[string]any)
	if typ := opt.GetType(); typ != ins.GetType() {
		diff["type"] = typ
	}
	if name := opt.GetName(); name != "" && name != ins.GetName() {
		diff["name"] = name
	}
	if status := opt.GetStatus(); status != ins.GetStatus() {
		diff["status"] = status
	}
	if option := opt.GetOption(); option != ins.GetOption() {
		diff["option"] = option
	}
	if option := opt.GetCronOption(); option != ins.GetCronOption() {
		diff["cron_option"] = option
	}
	if len(diff) == 0 {
		return nil, errors.New("无修改")
	}

	result := srv.app.DB.WithContext(ctx).Model(pb.PersistTask{}).Where("id = ?", ins.GetId()).Updates(diff)
	if err := result.Error; err != nil {
		return nil, err
	}
	return &pb.UpdatePersistTaskResponse{Result: ins}, nil
}

func (srv *Service) DeletePersistTask(ctx context.Context, req *pb.DeletePersistTaskRequest) (*pb.DeletePersistTaskResponse, error) {
	ins := new(pb.PersistTask)
	err := srv.app.DB.WithContext(ctx).Delete(ins, "id = ?", req.GetId()).Error
	if err != nil {
		return nil, err
	}
	return &pb.DeletePersistTaskResponse{}, nil
}

func (srv *Service) ExecutePersistTask(ctx context.Context, req *pb.ExecutePersistTaskRequest) (*pb.ExecutePersistTaskResponse, error) {
	ins := new(pb.PersistTask)
	err := srv.app.DB.WithContext(ctx).First(ins, "id = ?", req.GetId()).Error
	if err != nil {
		return nil, err
	}
	return &pb.ExecutePersistTaskResponse{}, nil
}

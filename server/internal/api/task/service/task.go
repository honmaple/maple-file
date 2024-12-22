package service

import (
	"context"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/task"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	taskStates = map[runner.State]pb.TaskState{
		runner.STATE_PENDING:   pb.TaskState_TASK_STATE_PENDING,
		runner.STATE_RUNNING:   pb.TaskState_TASK_STATE_RUNNING,
		runner.STATE_SUCCEEDED: pb.TaskState_TASK_STATE_SUCCEEDED,
		runner.STATE_CANCELING: pb.TaskState_TASK_STATE_CANCELING,
		runner.STATE_CANCELED:  pb.TaskState_TASK_STATE_CANCELED,
		runner.STATE_FAILED:    pb.TaskState_TASK_STATE_FAILED,
	}
)

// TODO: 持久化任务信息
func (srv *Service) ListTasks(ctx context.Context, in *pb.ListTasksRequest) (*pb.ListTasksResponse, error) {
	results := make([]*pb.Task, 0)
	for _, m := range srv.app.Runner.GetAll() {
		result := &pb.Task{
			Id:            m.Id(),
			Log:           m.Log(),
			Name:          m.Name(),
			State:         taskStates[m.State()],
			Progress:      m.Progress(),
			ProgressState: m.ProgressState(),
			StartTime:     timestamppb.New(m.StartTime()),
			EndTime:       timestamppb.New(m.EndTime()),
		}
		if err := m.Err(); err != nil {
			result.Err = err.Error()
		}
		results = append(results, result)
	}
	return &pb.ListTasksResponse{Results: results}, nil
}

func (srv *Service) RetryTask(ctx context.Context, in *pb.RetryTaskRequest) (*pb.RetryTaskResponse, error) {
	for _, id := range in.GetTasks() {
		if err := srv.app.Runner.Retry(id); err != nil {
			return nil, err
		}
	}
	return &pb.RetryTaskResponse{}, nil
}

func (srv *Service) CancelTask(ctx context.Context, in *pb.CancelTaskRequest) (*pb.CancelTaskResponse, error) {
	for _, id := range in.GetTasks() {
		if err := srv.app.Runner.Cancel(id); err != nil {
			return nil, err
		}
	}
	return &pb.CancelTaskResponse{}, nil
}

func (srv *Service) RemoveTask(ctx context.Context, in *pb.RemoveTaskRequest) (*pb.RemoveTaskResponse, error) {
	for _, id := range in.GetTasks() {
		if err := srv.app.Runner.Remove(id); err != nil {
			return nil, err
		}
	}
	return &pb.RemoveTaskResponse{}, nil
}

package service

import (
	"context"
	"errors"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/util"
)

var (
	errBadRequest = errors.New("错误的参数")
)

func (srv *Service) verifyRepo(repo *pb.Repo) error {
	if repo.GetName() == "" {
		return errors.New("存储名称不能为空")
	}
	if repo.GetDriver() == "" {
		return errors.New("存储类型不能为空")
	}
	if repo.GetOption() == "" {
		return errors.New("存储选项不能为空")
	}
	if repo.GetPath() == "" {
		repo.Path = "/"
	}
	if path := util.CleanPath(repo.GetPath()); path != repo.GetPath() {
		return errors.New("挂载目录格式错误")
	}

	oldRepo := new(pb.Repo)
	result := srv.app.DB.Model(pb.Repo{}).First(oldRepo, "path = ? AND name = ?", repo.GetPath(), repo.GetName())
	if result.RowsAffected > 0 && oldRepo.Id != repo.Id {
		return errors.New("重复挂载")
	}
	// TODO: 禁止挂载到不存在的目录
	return driver.VerifyOption(repo.GetDriver(), repo.GetOption())
}

func (srv *Service) ListRepos(ctx context.Context, req *pb.ListReposRequest) (*pb.ListReposResponse, error) {
	q := srv.app.DB.WithContext(ctx).Model(pb.Repo{})

	q = q.Order("id DESC")

	results := make([]*pb.Repo, 0)
	if err := q.Find(&results).Error; err != nil {
		return nil, err
	}
	return &pb.ListReposResponse{Results: results}, nil
}

func (srv *Service) CreateRepo(ctx context.Context, req *pb.CreateRepoRequest) (*pb.CreateRepoResponse, error) {
	opt := req.GetPayload()
	if opt == nil {
		return nil, errBadRequest
	}
	if err := srv.verifyRepo(opt); err != nil {
		return nil, err
	}

	result := srv.app.DB.WithContext(ctx).Model(pb.Repo{}).Create(opt)
	if err := result.Error; err != nil {
		return nil, err
	}
	srv.fs.CreateRepo(opt)
	return &pb.CreateRepoResponse{Result: opt}, nil
}

func (srv *Service) UpdateRepo(ctx context.Context, req *pb.UpdateRepoRequest) (*pb.UpdateRepoResponse, error) {
	opt := req.GetPayload()
	if opt == nil {
		return nil, errBadRequest
	}

	if err := srv.verifyRepo(opt); err != nil {
		return nil, err
	}

	ins := new(pb.Repo)
	q := srv.app.DB.WithContext(ctx).First(&ins, "id = ?", opt.GetId())
	if err := q.Error; err != nil {
		return nil, err
	}

	diff := make(map[string]any)
	if name := opt.GetName(); name != "" && name != ins.GetName() {
		diff["name"] = name
	}
	if path := opt.GetPath(); path != ins.GetPath() {
		diff["path"] = path
	}
	if status := opt.GetStatus(); status != ins.GetStatus() {
		diff["status"] = status
	}
	if option := opt.GetOption(); option != ins.GetOption() {
		diff["option"] = option
	}
	if driver := opt.GetDriver(); driver != ins.GetDriver() {
		diff["driver"] = driver
	}
	if len(diff) == 0 {
		return nil, errors.New("无修改")
	}

	result := srv.app.DB.WithContext(ctx).Model(pb.Repo{}).Where("id = ?", ins.GetId()).Updates(diff)
	if err := result.Error; err != nil {
		return nil, err
	}
	srv.fs.UpdateRepo(ins, opt)
	return &pb.UpdateRepoResponse{Result: ins}, nil
}

func (srv *Service) DeleteRepo(ctx context.Context, req *pb.DeleteRepoRequest) (*pb.DeleteRepoResponse, error) {
	ins := new(pb.Repo)
	err := srv.app.DB.WithContext(ctx).Delete(ins, "id = ?", req.GetId()).Error
	if err != nil {
		return nil, err
	}

	srv.fs.DeleteRepo(ins)
	return &pb.DeleteRepoResponse{}, nil
}

func (srv *Service) TestRepo(ctx context.Context, req *pb.TestRepoRequest) (*pb.TestRepoResponse, error) {
	opt := req.GetPayload()
	if opt == nil {
		return nil, errBadRequest
	}

	if err := srv.verifyRepo(opt); err != nil {
		return nil, err
	}

	fs, err := driver.DriverFS(opt.Driver, opt.Option)
	if err != nil {
		return nil, err
	}
	defer fs.Close()

	if _, err := fs.List(ctx, "/"); err != nil {
		return nil, err
	}
	return &pb.TestRepoResponse{Success: true}, nil
}

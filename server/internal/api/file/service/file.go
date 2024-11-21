package service

import (
	"context"
	"errors"
	"fmt"
	"path/filepath"
	"sort"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func (srv *Service) List(ctx context.Context, req *pb.ListFilesRequest) (*pb.ListFilesResponse, error) {
	path := util.CleanPath(req.GetPath())

	repos := make([]*pb.Repo, 0)

	q := srv.app.DB.WithContext(ctx).Model(pb.Repo{}).Where("path = ?", path)
	if err := q.Find(&repos).Error; err != nil {
		return nil, err
	}
	sort.SliceStable(repos, func(i, j int) bool {
		return repos[i].GetName() > repos[j].GetName()
	})

	results := make([]*pb.File, len(repos))
	for i, m := range repos {
		result := &pb.File{
			Path:      "/",
			Name:      m.Name,
			Type:      "DIR",
			CreatedAt: m.CreatedAt,
			UpdatedAt: m.UpdatedAt,
		}
		results[i] = result
	}

	if path == "/" {
		return &pb.ListFilesResponse{Results: results}, nil
	}

	files, err := srv.fs.List(ctx, path)
	if err != nil {
		return nil, err
	}

	for _, m := range files {
		result := &pb.File{
			Path:      m.Path(),
			Name:      m.Name(),
			Size:      int32(m.Size()),
			Type:      m.Type(),
			CreatedAt: timestamppb.New(m.ModTime()),
			UpdatedAt: timestamppb.New(m.ModTime()),
		}
		if m.IsDir() {
			result.Type = "DIR"
		}
		results = append(results, result)
	}
	return &pb.ListFilesResponse{Results: results}, nil
}

func (srv *Service) Rename(ctx context.Context, req *pb.RenameFileRequest) (*pb.RenameFileResponse, error) {
	oldPath := filepath.Join(req.GetPath(), req.GetName())
	newPath := filepath.Join(req.GetPath(), req.GetNewName())

	fmt.Println("rename", oldPath, newPath)
	if err := srv.fs.Rename(ctx, oldPath, newPath); err != nil {
		return nil, err
	}
	return &pb.RenameFileResponse{}, nil
}

func (srv *Service) Mkdir(ctx context.Context, req *pb.MkdirFileRequest) (*pb.MkdirFileResponse, error) {
	fmt.Println("mkdir", filepath.Join(req.GetPath(), req.GetName()))
	if err := srv.fs.MakeDir(ctx, filepath.Join(req.GetPath(), req.GetName())); err != nil {
		return nil, err
	}
	return &pb.MkdirFileResponse{}, nil
}

func (srv *Service) Move(ctx context.Context, req *pb.MoveFileRequest) (*pb.MoveFileResponse, error) {
	newPath := req.GetNewPath()
	for _, name := range req.GetNames() {
		oldPath := filepath.Join(req.GetPath(), name)

		fmt.Println("move", oldPath, newPath)
		if err := srv.fs.Move(ctx, oldPath, newPath); err != nil {
			return nil, err
		}
	}
	return &pb.MoveFileResponse{}, nil
}

func (srv *Service) Copy(ctx context.Context, req *pb.CopyFileRequest) (*pb.CopyFileResponse, error) {
	newPath := req.GetNewPath()
	for _, name := range req.GetNames() {
		oldPath := filepath.Join(req.GetPath(), name)

		fmt.Println("copy", oldPath, newPath)
		if err := srv.fs.Copy(ctx, oldPath, newPath); err != nil {
			return nil, err
		}
	}
	return &pb.CopyFileResponse{}, nil
}

func (srv *Service) Remove(ctx context.Context, req *pb.RemoveFileRequest) (*pb.RemoveFileResponse, error) {
	for _, name := range req.GetNames() {
		fmt.Println("remove", filepath.Join(req.GetPath(), name))
		if err := srv.fs.Remove(ctx, filepath.Join(req.GetPath(), name)); err != nil {
			return nil, err
		}
	}
	return &pb.RemoveFileResponse{}, nil
}

func (srv *Service) Upload(stream pb.FileService_UploadServer) error {
	// 接收第0片数据，只包括文件名等信息，不包括数据
	req, err := stream.Recv()
	if err != nil {
		return err
	}

	task := srv.app.Runner.Submit(fmt.Sprintf("上传文件 %s", req.GetFilename()), func(task runner.Task) error {
		file, err := srv.fs.Create(filepath.Join(req.GetPath(), req.GetFilename()))
		if err != nil {
			return err
		}
		defer file.Close()

		fsize := util.PrettyByteSize(int(req.GetSize()))

		task.SetProgressState(fmt.Sprintf("0/%s", fsize))

		_, err = util.Copy(task.Context(), file, readFunc(stream.Recv), func(progress int64) {
			if size := req.GetSize(); size > 0 {
				task.SetProgress(float64(progress) / float64(size))
			}
			task.SetProgressState(fmt.Sprintf("%s/%s", util.PrettyByteSize(int(progress)), fsize))
		})
		if err != nil {
			return err
		}
		return nil
	})
	<-task.Done()

	if err := task.Err(); err != nil {
		return stream.SendAndClose(&pb.FileResponse{Message: err.Error()})
	}

	info, err := srv.fs.Get(filepath.Join(filepath.Join(req.GetPath(), req.GetFilename())))
	if err != nil {
		return err
	}
	result := &pb.File{
		Path:      info.Path(),
		Name:      info.Name(),
		Size:      int32(info.Size()),
		Type:      info.Type(),
		CreatedAt: timestamppb.New(info.ModTime()),
		UpdatedAt: timestamppb.New(info.ModTime()),
	}
	return stream.SendAndClose(&pb.FileResponse{Result: result})
}

func (srv *Service) Preview(req *pb.PreviewFileRequest, stream pb.FileService_PreviewServer) error {
	info, err := srv.fs.Get(req.GetPath())
	if err != nil {
		return err
	}
	if info.IsDir() {
		return errors.New("can't preview dir")
	}

	file, err := srv.fs.Open(req.GetPath())
	if err != nil {
		return err
	}
	defer file.Close()

	_, err = util.Copy(stream.Context(), previewFunc(stream.Send), file, nil)
	return err
}

func (srv *Service) Download(ctx context.Context, req *pb.DownloadFileRequest) (*pb.DownloadFileResponse, error) {
	info, err := srv.fs.Get(req.GetPath())
	if err != nil {
		return nil, err
	}
	if info.IsDir() {

	}
	return nil, nil
}

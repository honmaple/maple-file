package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"path/filepath"
	"strings"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
	settingpb "github.com/honmaple/maple-file/server/internal/proto/api/setting"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"
	"github.com/spf13/viper"
)

func (srv *Service) getSetting(ctx context.Context, key string) (*viper.Viper, error) {
	ins := new(settingpb.Setting)

	if err := srv.app.DB.WithContext(ctx).First(&ins, "key = ?", key).Error; err != nil {
		return nil, err
	}

	allSettings := make([]*settingpb.Setting, 0)
	srv.app.DB.WithContext(ctx).Find(&allSettings)
	for _, set := range allSettings {
		fmt.Println(set.Key, set.Value)
	}

	setting := make(map[string]any)
	if err := json.Unmarshal([]byte(ins.GetValue()), &setting); err != nil {
		return nil, err
	}

	cf := viper.New()
	for k, v := range setting {
		cf.Set(k, v)
	}
	return cf, nil
}

func (srv *Service) List(ctx context.Context, req *pb.ListFilesRequest) (*pb.ListFilesResponse, error) {
	filter := util.NewFilter(req.GetFilter())

	path := util.CleanPath(filter.GetString("path"))

	q := srv.app.DB.WithContext(ctx).Model(pb.Repo{}).Where("path = ?", path).Order("name DESC")

	repos := make([]*pb.Repo, 0)
	if err := q.Find(&repos).Error; err != nil {
		return nil, err
	}

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
	if path != "/" {
		files, err := srv.fs.List(ctx, path)
		if err != nil {
			return nil, err
		}
		for _, m := range files {
			results = append(results, infoToFile(m))
		}
	}

	results = paginator(results, filter.GetInt("page"), filter.GetInt("page_size"))
	return &pb.ListFilesResponse{Results: results}, nil
}

func (srv *Service) Rename(ctx context.Context, req *pb.RenameFileRequest) (*pb.RenameFileResponse, error) {
	oldPath := filepath.Join(req.GetPath(), req.GetName())

	fmt.Println("rename", oldPath, filepath.Join(req.GetPath(), req.GetNewName()))
	if err := srv.fs.Rename(ctx, oldPath, req.GetNewName()); err != nil {
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

func (srv *Service) upload(ctx context.Context, req *pb.FileRequest, reader io.Reader) (*pb.File, error) {
	filename := req.GetFilename()

	cf, err := srv.getSetting(ctx, "app.file")
	if err != nil {
		return nil, err
	}

	if limitSize := cf.GetInt32("upload.limit_size"); limitSize > 0 && req.GetSize() > limitSize*1024*1024 {
		return nil, errors.New("上传限制大小")
	}

	if limitType := cf.GetString("upload.limit_type"); limitType != "" {
		fileExt := filepath.Ext(filename)

		limit := true
		for _, t := range strings.Split(limitType, ",") {
			if fileExt == t {
				limit = false
				break
			}
		}
		if limit {
			return nil, errors.New("上传限制类型")
		}
	}

	// 自动重命名
	if cf.GetBool("upload.rename") {
		filename = renameFile(cf.GetString("upload.format"), filename)
	}

	path := filepath.Join(req.GetPath(), filename)

	task := srv.app.Runner.Submit(fmt.Sprintf("上传文件 %s", filename), func(task runner.Task) error {
		file, err := srv.fs.Create(path)
		if err != nil {
			return err
		}
		defer file.Close()

		fsize := util.PrettyByteSize(int(req.GetSize()))

		task.SetProgressState(fmt.Sprintf("0/%s", fsize))

		_, err = util.Copy(task.Context(), file, reader, func(progress int64) {
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
		return nil, err
	}

	info, err := srv.fs.Get(path)
	if err != nil {
		return nil, err
	}
	return infoToFile(info), nil
}

func (srv *Service) Upload(stream pb.FileService_UploadServer) error {
	ctx := stream.Context()

	// 接收第0片数据，只包括文件名等信息，不包括数据
	firstReq, err := stream.Recv()
	if err != nil {
		return err
	}

	result, err := srv.upload(ctx, firstReq, readFunc(stream.Recv))
	if err != nil {
		return err
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

	dst := chunkFunc(func(chunk []byte) error {
		return stream.Send(&pb.PreviewFileResponse{
			Chunk: chunk,
		})
	})
	_, err = util.Copy(stream.Context(), dst, file, nil)
	return err
}

func (srv *Service) Download(req *pb.DownloadFileRequest, stream pb.FileService_DownloadServer) error {
	info, err := srv.fs.Get(req.GetPath())
	if err != nil {
		return err
	}
	if info.IsDir() {
		// TODO 打包后下载
		return errors.New("can't download dir")
	}

	src, err := srv.fs.Open(req.GetPath())
	if err != nil {
		return err
	}
	defer src.Close()

	dst := chunkFunc(func(chunk []byte) error {
		return stream.Send(&pb.DownloadFileResponse{
			Chunk: chunk,
		})
	})

	task := srv.app.Runner.Submit(fmt.Sprintf("下载 [%s]", req.GetPath()), func(task runner.Task) error {
		fsize := util.PrettyByteSize(int(info.Size()))

		task.SetProgressState(fmt.Sprintf("0/%s", fsize))

		_, err := util.Copy(stream.Context(), dst, src, func(progress int64) {
			if size := info.Size(); size > 0 {
				task.SetProgress(float64(progress) / float64(size))
			}
			task.SetProgressState(fmt.Sprintf("%s/%s", util.PrettyByteSize(int(progress)), fsize))
		})
		return err
	})
	<-task.Done()
	return task.Err()
}

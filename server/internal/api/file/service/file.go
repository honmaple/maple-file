package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"io"
	stdpath "path"
	"slices"
	"strings"

	"github.com/honmaple/cloudfs"
	"github.com/honmaple/maple-file/server/internal/api/file/provider/fs"
	"github.com/honmaple/maple-file/server/internal/api/shared"
	"github.com/honmaple/maple-file/server/internal/platform/utils/ioutil"
	"github.com/honmaple/maple-file/server/internal/platform/utils/pathutil"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
)

func (srv *serviceImpl) List(ctx context.Context, req *pb.File_ListRequest) (*pb.File_ListResponse, error) {
	filter := shared.NewFilter(req.GetFilter())

	path := cloudfs.PathWithValues(pathutil.CleanPath(filter.GetString("path")), shared.WithQueryParams(
		shared.WithOrder(filter.GetString("order"), filter.GetBool("desc")),
		shared.WithPagination(filter.GetInt("page"), filter.GetInt("page_size")),
	))
	files, err := srv.fs.List(ctx, path)
	if err != nil {
		return nil, err
	}
	results := make([]*pb.File, len(files))
	for i, m := range files {
		results[i] = infoToFile(m)
	}
	return &pb.File_ListResponse{Results: results}, nil
}

func (srv *serviceImpl) Rename(ctx context.Context, req *pb.File_RenameRequest) (*pb.File_RenameResponse, error) {
	oldPath := stdpath.Join(req.GetPath(), req.GetName())

	fmt.Println("rename", oldPath, stdpath.Join(req.GetPath(), req.GetNewName()))
	if err := srv.fs.Rename(ctx, oldPath, req.GetNewName()); err != nil {
		return nil, err
	}
	return &pb.File_RenameResponse{}, nil
}

func (srv *serviceImpl) Mkdir(ctx context.Context, req *pb.File_MkdirRequest) (*pb.File_MkdirResponse, error) {
	fmt.Println("mkdir", stdpath.Join(req.GetPath(), req.GetName()))
	if err := srv.fs.MakeDir(ctx, stdpath.Join(req.GetPath(), req.GetName())); err != nil {
		return nil, err
	}
	return &pb.File_MkdirResponse{}, nil
}

func (srv *serviceImpl) Move(ctx context.Context, req *pb.File_MoveRequest) (*pb.File_MoveResponse, error) {
	newPath := req.GetNewPath()
	for _, name := range req.GetNames() {
		oldPath := stdpath.Join(req.GetPath(), name)

		fmt.Println("move", oldPath, newPath)

		srv.fs.SubmitTask(&fs.MoveTask{
			SrcPath: oldPath,
			DstPath: newPath,
		})
	}
	return &pb.File_MoveResponse{}, nil
}

func (srv *serviceImpl) Copy(ctx context.Context, req *pb.File_CopyRequest) (*pb.File_CopyResponse, error) {
	newPath := req.GetNewPath()
	for _, name := range req.GetNames() {
		oldPath := stdpath.Join(req.GetPath(), name)

		fmt.Println("copy", oldPath, newPath)

		srv.fs.SubmitTask(&fs.CopyTask{
			SrcPath: oldPath,
			DstPath: newPath,
		})
	}
	return &pb.File_CopyResponse{}, nil
}

func (srv *serviceImpl) Remove(ctx context.Context, req *pb.File_RemoveRequest) (*pb.File_RemoveResponse, error) {
	for _, name := range req.GetNames() {
		fmt.Println("remove", stdpath.Join(req.GetPath(), name))

		srv.fs.SubmitTask(&fs.RemoveTask{
			Path: stdpath.Join(req.GetPath(), name),
		})
	}
	return &pb.File_RemoveResponse{}, nil
}

func (srv *serviceImpl) upload(ctx context.Context, req *pb.File_UploadRequest, reader io.Reader) (*pb.File, string, error) {
	filename := req.GetFilename()

	setting := srv.getFileSetting(ctx)

	if limitSize := setting.UploadLimitSize; limitSize > 0 && req.GetSize() > limitSize*1024*1024 {
		return nil, "", errors.New("上传限制大小")
	}

	if limitType := setting.UploadLimitType; limitType != "" {
		fileExt := stdpath.Ext(filename)

		if slices.Contains(strings.Split(limitType, ","), fileExt) {
			return nil, "", errors.New("上传限制类型")
		}
	}

	// 自动重命名
	if setting.UploadRename && !req.GetPreserveFilename() {
		filename = renameFile(setting.UploadFormat, filename)
	}
	hash := sha256.New()

	task := srv.fs.SubmitTask(&fs.UploadTask{
		Path:     req.GetPath(),
		Size:     int64(req.GetSize()),
		Filename: filename,
		Reader:   io.TeeReader(reader, hash),
	})
	<-task.Done()

	if err := task.Err(); err != nil {
		return nil, "", err
	}

	info, err := srv.fs.Stat(ctx, stdpath.Join(req.GetPath(), filename))
	if err != nil {
		return nil, "", err
	}
	if info.Size() != int64(req.GetSize()) {
		return nil, "", errors.New("上传后文件大小不匹配")
	}
	return infoToFile(info), hex.EncodeToString(hash.Sum(nil)), nil
}

func (srv *serviceImpl) Upload(stream pb.FileService_UploadServer) error {
	ctx := stream.Context()

	// 接收第0片数据，只包括文件名等信息，不包括数据
	firstReq, err := stream.Recv()
	if err != nil {
		return err
	}

	result, sourceHash, err := srv.upload(ctx, firstReq, readFunc(stream.Recv))
	if err != nil {
		return err
	}
	return stream.SendAndClose(&pb.File_UploadResponse{Result: result, SourceHashAlgorithm: "sha256", SourceHash: sourceHash})
}

func (srv *serviceImpl) Preview(req *pb.File_PreviewRequest, stream pb.FileService_PreviewServer) error {
	info, err := srv.fs.Stat(stream.Context(), req.GetPath())
	if err != nil {
		return err
	}
	if info.IsDir() {
		return errors.New("can't preview dir")
	}

	file, err := srv.fs.Open(stream.Context(), req.GetPath())
	if err != nil {
		return err
	}
	defer file.Close()

	dst := chunkFunc(func(chunk []byte) error {
		return stream.Send(&pb.File_PreviewResponse{
			Chunk: chunk,
		})
	})
	_, err = ioutil.Copy(stream.Context(), dst, file, nil)
	return err
}

func (srv *serviceImpl) Download(req *pb.File_DownloadRequest, stream pb.FileService_DownloadServer) error {
	dst := chunkFunc(func(chunk []byte) error {
		return stream.Send(&pb.File_DownloadResponse{
			Chunk: chunk,
		})
	})
	task := srv.fs.SubmitTask(&fs.DownloadTask{
		Path:   req.GetPath(),
		Writer: dst,
	})
	<-task.Done()
	return task.Err()
}

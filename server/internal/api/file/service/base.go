package service

import (
	"context"
	"fmt"
	"path/filepath"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"
	"google.golang.org/grpc"
	"google.golang.org/protobuf/types/known/timestamppb"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/runner"
	"github.com/honmaple/maple-file/server/pkg/util"

	"github.com/honmaple/maple-file/server/internal/api/file/fs"
	"github.com/honmaple/maple-file/server/internal/app"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
)

type Service struct {
	pb.UnimplementedFileServiceServer
	fs  driver.FS
	app *app.App
}

func (srv *Service) Register(grpc *grpc.Server) {
	pb.RegisterFileServiceServer(grpc, srv)
}

func (srv *Service) RegisterGateway(ctx context.Context, mux *runtime.ServeMux, e *echo.Echo) {
	pb.RegisterFileServiceHandlerServer(ctx, mux, srv)

	g := e.Group("/api/file")

	g.POST("/upload/blob", func(c echo.Context) error {
		path := c.FormValue("path")
		if path == "" {
			return c.JSON(400, "path is required")
		}

		results := make([]*pb.FileResponse, 0)

		form, err := c.MultipartForm()
		if err != nil {
			return err
		}
		files := form.File["files"]
		for _, file := range files {
			task := srv.app.Runner.Submit(fmt.Sprintf("上传文件 %s", file.Filename), func(task runner.Task) error {
				src, err := file.Open()
				if err != nil {
					return err
				}
				defer src.Close()

				dst, err := srv.fs.Create(filepath.Join(path, file.Filename))
				if err != nil {
					return err
				}
				defer dst.Close()

				fsize := util.PrettyByteSize(int(file.Size))

				task.SetProgressState(fmt.Sprintf("0/%s", fsize))

				_, err = util.Copy(task.Context(), dst, src, func(progress int64) {
					if size := file.Size; size > 0 {
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
				return c.JSON(400, &pb.FileResponse{Message: err.Error()})
			}

			info, err := srv.fs.Get(filepath.Join(filepath.Join(path, file.Filename)))
			if err != nil {
				return err
			}
			results = append(results, &pb.FileResponse{Result: &pb.File{
				Path:      info.Path(),
				Name:      info.Name(),
				Size:      int32(info.Size()),
				Type:      info.Type(),
				CreatedAt: timestamppb.New(info.ModTime()),
				UpdatedAt: timestamppb.New(info.ModTime()),
			}})
		}
		return c.JSON(200, results)
	})

	g.GET("/preview/blob", func(c echo.Context) error {
		// Bind 必须增加query的tag
		req := pb.PreviewFileRequest{
			Path: c.QueryParams().Get("path"),
		}

		info, err := srv.fs.Get(req.GetPath())
		if err != nil {
			return err
		}

		file, err := srv.fs.Open(req.GetPath())
		if err != nil {
			return err
		}
		defer file.Close()

		return c.Stream(200, info.Type(), file)
	})

	g.POST("/download/blob", func(c echo.Context) error {
		// Bind 必须增加query的tag
		req := pb.PreviewFileRequest{
			Path: c.QueryParams().Get("path"),
		}

		info, err := srv.fs.Get(req.GetPath())
		if err != nil {
			return err
		}

		file, err := srv.fs.Open(req.GetPath())
		if err != nil {
			return err
		}
		defer file.Close()

		return c.Stream(200, info.Type(), file)
	})
}

func New(app *app.App) *Service {
	srv := &Service{
		app: app,
	}
	srv.fs = fs.New(app)
	return srv
}

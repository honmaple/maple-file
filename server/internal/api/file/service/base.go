package service

import (
	"context"
	"errors"
	"net/http"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"
	"google.golang.org/grpc"

	"github.com/honmaple/maple-file/server/internal/api/file/fs"
	"github.com/honmaple/maple-file/server/internal/app"

	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
)

type Service struct {
	pb.UnimplementedFileServiceServer
	fs  fs.FS
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

		form, err := c.MultipartForm()
		if err != nil {
			return err
		}
		results := make([]*pb.FileResponse, 0)
		for _, file := range form.File["files"] {
			src, err := file.Open()
			if err != nil {
				return err
			}

			result, err := srv.upload(ctx, &pb.FileRequest{
				Path:     path,
				Size:     int32(file.Size),
				Filename: file.Filename,
			}, src)
			if err != nil {
				src.Close()
				return c.JSON(400, &pb.FileResponse{Message: err.Error()})
			}
			src.Close()
			results = append(results, &pb.FileResponse{Result: result})
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
		if info.IsDir() {
			return errors.New("can't preview dir")
		}

		file, err := srv.fs.Open(req.GetPath())
		if err != nil {
			return err
		}
		defer file.Close()

		http.ServeContent(c.Response(), c.Request(), info.Name(), info.ModTime(), file)
		return nil
	})

	g.GET("/download/blob", func(c echo.Context) error {
		// Bind 必须增加query的tag
		req := pb.PreviewFileRequest{
			Path: c.QueryParams().Get("path"),
		}

		info, err := srv.fs.Get(req.GetPath())
		if err != nil {
			return err
		}
		if info.IsDir() {
			return errors.New("can't download dir")
		}

		file, err := srv.fs.Open(req.GetPath())
		if err != nil {
			return err
		}
		defer file.Close()

		if typ := info.Type(); typ != "" {
			c.Response().Header().Set("Content-Type", info.Type())
		}

		http.ServeContent(c.Response(), c.Request(), info.Name(), info.ModTime(), file)
		return nil
	})
}

func New(app *app.App) *Service {
	srv := &Service{
		app: app,
	}
	srv.fs = fs.New(app)
	return srv
}

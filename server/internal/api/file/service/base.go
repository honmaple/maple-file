package service

import (
	"context"
	"errors"
	"net/http"
	"os"
	"slices"
	"time"

	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"
	"google.golang.org/grpc"

	"github.com/honmaple/maple-file/server/internal/api/file/fs"
	"github.com/honmaple/maple-file/server/internal/app"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
	"github.com/honmaple/maple-file/server/pkg/server"
	"github.com/honmaple/maple-file/server/pkg/util"
)

type Service struct {
	app.BaseService
	pb.UnimplementedFileServiceServer
	pb.UnimplementedServerServiceServer
	fs      fs.FS
	app     *app.App
	servers util.Cache[string, server.Server]
}

func (srv *Service) RegisterGateway(ctx context.Context, mux *runtime.ServeMux) {
	pb.RegisterFileServiceHandlerServer(ctx, mux, srv)
}

func (srv *Service) Register(grpc *grpc.Server) {
	pb.RegisterFileServiceServer(grpc, srv)
	pb.RegisterServerServiceServer(grpc, srv)
}

func (srv *Service) RegisterHTTP(e *echo.Echo) {
	g := e.Group("/api/file")

	g.POST("/upload/blob", func(c echo.Context) error {
		path := c.FormValue("path")
		if path == "" {
			return c.JSON(400, "path is required")
		}
		rctx := c.Request().Context()

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

			result, err := srv.upload(rctx, &pb.FileRequest{
				Path:     path,
				Size:     file.Size,
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
		path := c.QueryParams().Get("path")
		if path == "" {
			return c.JSON(400, "path is required")
		}

		rctx := c.Request().Context()
		info, err := srv.fs.Get(rctx, path)
		if err != nil {
			return err
		}
		if info.IsDir() {
			return errors.New("can't preview dir")
		}

		thumb := slices.Contains([]string{"true", "1"}, c.QueryParams().Get("thumb"))
		if thumb {
			thumbPath, err := srv.thumbFile(srv.app.Context(), path, info)
			if err != nil {
				return err
			}

			file, err := os.Open(thumbPath)
			if err != nil {
				return err
			}
			defer file.Close()

			stat, err := file.Stat()
			if err != nil {
				return err
			}

			// 更新访问时间
			if err := os.Chtimes(thumbPath, time.Now(), stat.ModTime()); err != nil {
				return err
			}

			http.ServeContent(c.Response(), c.Request(), stat.Name(), stat.ModTime(), file)
			return nil
		}

		file, err := srv.fs.Open(path)
		if err != nil {
			return err
		}
		defer file.Close()

		http.ServeContent(c.Response(), c.Request(), info.Name(), info.ModTime(), file)
		return nil
	})

	g.GET("/download/blob", func(c echo.Context) error {
		path := c.QueryParams().Get("path")
		if path == "" {
			return c.JSON(400, "path is required")
		}

		info, err := srv.fs.Get(c.Request().Context(), path)
		if err != nil {
			return err
		}
		if info.IsDir() {
			return errors.New("can't download dir")
		}

		file, err := srv.fs.Open(path)
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
		app:     app,
		servers: util.NewCache[string, server.Server](),
	}
	srv.fs = fs.New(app)

	go srv.cleanThumbFile()
	return srv
}

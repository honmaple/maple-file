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

	"github.com/honmaple/maple-file/server/internal/api/file/provider/fs"
	"github.com/honmaple/maple-file/server/internal/api/file/provider/server"
	"github.com/honmaple/maple-file/server/internal/api/file/repository"
	"github.com/honmaple/maple-file/server/internal/api/file/types"
	"github.com/honmaple/maple-file/server/internal/api/shared"
	"github.com/honmaple/maple-file/server/internal/platform/utils/cacheutil"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
)

type (
	Service interface {
		shared.Service
		pb.FileServiceServer
		pb.RepoServiceServer
		pb.ExternalServerServiceServer
	}
	serviceImpl struct {
		shared.ServiceImpl
		pb.UnimplementedFileServiceServer
		pb.UnimplementedRepoServiceServer
		pb.UnimplementedExternalServerServiceServer
		ctx      *types.Context
		repo     repository.Repository
		settings SettingLoader
		fs       fs.FS
		resolver fs.RepoResolver
		servers  cacheutil.Cache[string, server.Server]
	}
	SettingLoader interface {
		LoadSetting(context.Context, string, any) error
	}
)

func (srv *serviceImpl) Register(grpc *grpc.Server) {
	pb.RegisterFileServiceServer(grpc, srv)
	pb.RegisterRepoServiceServer(grpc, srv)
	pb.RegisterExternalServerServiceServer(grpc, srv)
}

func (srv *serviceImpl) RegisterGateway(ctx context.Context, mux *runtime.ServeMux) {
	pb.RegisterFileServiceHandlerServer(ctx, mux, srv)
	pb.RegisterRepoServiceHandlerServer(ctx, mux, srv)
}

func (srv *serviceImpl) RegisterHTTP(e *echo.Echo) {
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
		results := make([]*pb.File_UploadResponse, 0)
		for _, file := range form.File["files"] {
			src, err := file.Open()
			if err != nil {
				return err
			}

			result, err := srv.upload(rctx, &pb.File_UploadRequest{
				Path:     path,
				Size:     file.Size,
				Filename: file.Filename,
			}, src)
			if err != nil {
				src.Close()
				return c.JSON(400, &pb.File_UploadResponse{Message: err.Error()})
			}
			src.Close()
			results = append(results, &pb.File_UploadResponse{Result: result})
		}
		return c.JSON(200, results)
	})

	g.GET("/preview/blob", func(c echo.Context) error {
		path := c.QueryParams().Get("path")
		if path == "" {
			return c.JSON(400, "path is required")
		}

		rctx := c.Request().Context()
		info, err := srv.fs.Stat(rctx, path)
		if err != nil {
			return err
		}
		if info.IsDir() {
			return errors.New("can't preview dir")
		}

		thumb := slices.Contains([]string{"true", "1"}, c.QueryParams().Get("thumb"))
		if thumb {
			thumbPath, err := srv.thumbFile(srv.ctx.Context, path, info)
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

		file, err := srv.fs.Open(rctx, path)
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

		info, err := srv.fs.Stat(c.Request().Context(), path)
		if err != nil {
			return err
		}
		if info.IsDir() {
			return errors.New("can't download dir")
		}

		file, err := srv.fs.Open(c.Request().Context(), path)
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

func New(ctx *types.Context, repo repository.Repository, settings SettingLoader) (Service, error) {
	if err := ctx.DB.AutoMigrate(
		new(pb.Repo),
	); err != nil {
		return nil, err
	}
	srv := &serviceImpl{
		ctx:      ctx,
		repo:     repo,
		settings: settings,
		servers:  cacheutil.New[string, server.Server](),
	}
	resolver, err := fs.NewRepoResolver(ctx.Context, repo)
	if err != nil {
		return nil, err
	}
	srv.fs = fs.New(ctx, resolver)
	srv.resolver = resolver

	go srv.cleanThumbFile()
	return srv, nil
}

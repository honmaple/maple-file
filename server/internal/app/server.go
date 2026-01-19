package app

import (
	"context"
	"encoding/json"
	"errors"
	"net"
	"net/http"
	"strings"
	"time"

	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"google.golang.org/grpc"
	"google.golang.org/grpc/metadata"

	"github.com/golang-jwt/jwt/v5"
	"github.com/grpc-ecosystem/grpc-gateway/v2/runtime"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"

	"github.com/honmaple/maple-file/server/internal/app/config"
)

var (
	errInvalidToken    = errors.New("invalid token")
	errMissingMetadata = errors.New("miss metadata")
)

type Server struct {
	Mux  *runtime.ServeMux
	Echo *echo.Echo
	Grpc *grpc.Server

	app      *App
	server   *http.Server
	listener net.Listener
	token    string
	services Services
}

func (srv *Server) Result() (string, error) {
	result := map[string]any{
		"addr":  srv.listener.Addr().String(),
		"token": srv.token,
	}
	b, err := json.Marshal(&result)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

func (srv *Server) Addr() string {
	return srv.listener.Addr().String()
}

func (srv *Server) Start() error {
	srv.app.Logger.Infoln("http server listen:", srv.Addr())

	return srv.server.Serve(srv.listener)
}

func (srv *Server) Shutdown() error {
	srv.app.Logger.Infoln("http server shutdown...")

	defer srv.services.Close()
	defer srv.Grpc.Stop()
	return srv.server.Shutdown(context.TODO())
}

func (srv *Server) checkToken(token string) bool {
	token = strings.TrimPrefix(token, "Bearer ")

	t, err := jwt.ParseWithClaims(token, &jwt.RegisteredClaims{}, func(token *jwt.Token) (any, error) {
		return []byte(srv.app.Config.GetString(config.ServerSecretKey)), nil
	})
	if err != nil || t == nil {
		return false
	}
	claims, ok := t.Claims.(*jwt.RegisteredClaims)
	if !ok {
		return false
	}
	return claims.Issuer == PROCESS
}

func (srv *Server) setToken() {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, &jwt.RegisteredClaims{
		Issuer:    PROCESS,
		ExpiresAt: jwt.NewNumericDate(time.Now().Add(time.Hour * 24 * 365)),
	})

	srv.token, _ = token.SignedString([]byte(srv.app.Config.GetString(config.ServerSecretKey)))
}

func (srv *Server) setGrpc() {
	unaryInterceptor := func(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (any, error) {
		md, ok := metadata.FromIncomingContext(ctx)
		if !ok {
			return nil, errMissingMetadata
		}

		if values := md.Get("Authorization"); len(values) > 0 {
			if srv.checkToken(values[0]) {
				return handler(ctx, req)
			}
		}
		return nil, errInvalidToken
	}

	streamInterceptor := func(req any, ss grpc.ServerStream, _ *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
		md, ok := metadata.FromIncomingContext(ss.Context())
		if !ok {
			return errMissingMetadata
		}
		if values := md.Get("Authorization"); len(values) > 0 {
			if srv.checkToken(values[0]) {
				return handler(req, ss)
			}
		}
		return errInvalidToken
	}
	srv.Mux = runtime.NewServeMux()
	srv.Grpc = grpc.NewServer(
		grpc.UnaryInterceptor(unaryInterceptor),
		grpc.StreamInterceptor(streamInterceptor),
	)

	srv.services.Register(srv.Grpc)
	srv.services.RegisterGateway(srv.app.ctx, srv.Mux)
}

func (srv *Server) setHttp() {
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.ProtoMajor == 2 && strings.Contains(r.Header.Get("Content-Type"), "application/grpc") {
			srv.Grpc.ServeHTTP(w, r)
		} else {
			srv.Mux.ServeHTTP(w, r)
		}
	})

	srv.Echo = echo.New()
	srv.Echo.Use(middleware.KeyAuthWithConfig(middleware.KeyAuthConfig{
		Skipper:    middleware.DefaultSkipper,
		KeyLookup:  "query:token,header:" + echo.HeaderAuthorization,
		AuthScheme: "Bearer",
		Validator: func(key string, c echo.Context) (bool, error) {
			return srv.checkToken(key), nil
		},
	}))
	srv.Echo.Any("/*", echo.WrapHandler(handler))

	srv.services.RegisterHTTP(srv.Echo)
}

func NewServer(app *App) (*Server, error) {
	ss := make(Services, 0)
	for _, creator := range creators {
		s, err := creator(app)
		if err != nil {
			return nil, err
		}
		ss = append(ss, s)
	}

	listener, err := Listen(app.Config.GetString(config.ServerAddr))
	if err != nil {
		return nil, err
	}

	srv := &Server{
		app:      app,
		listener: listener,
		services: ss,
	}
	srv.setToken()
	srv.setGrpc()
	srv.setHttp()

	srv.server = &http.Server{Handler: h2c.NewHandler(srv.Echo, &http2.Server{})}
	return srv, nil
}
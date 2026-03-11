package webdav

import (
	"fmt"
	"net"
	"net/http"
	"sync"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"golang.org/x/net/context"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"
	"golang.org/x/net/webdav"

	"github.com/honmaple/maple-file/server/pkg/driver"
	"github.com/honmaple/maple-file/server/pkg/server"
)

type Option struct {
	Host     string `json:"host"     validate:"required"`
	Port     int    `json:"port"     validate:"omitempty,gte=4000"`
	Username string `json:"username" validate:"required"`
	Password string `json:"password" validate:"required"`
}

func (opt *Option) NewServer(fs driver.FS) (server.Server, error) {
	return New(fs, opt)
}

type Webdav struct {
	fs       driver.FS
	opt      *Option
	server   *http.Server
	listener net.Listener
	mu       sync.RWMutex
	err      error
}

func (d *Webdav) basicAuth(username, password string, c echo.Context) (bool, error) {
	if username == d.opt.Username && password == d.opt.Password {
		return true, nil
	}
	return false, nil
}

func (d *Webdav) Status() server.ServerStatus {
	d.mu.RLock()
	defer d.mu.RUnlock()

	status := server.ServerStatus{}
	if d.err != nil {
		status.Error = d.err.Error()
		return status
	}

	if d.listener != nil {
		status.Addr = d.listener.Addr().String()
		status.Running = true
	}
	return status
}

func (d *Webdav) Start() error {
	if d.server != nil {
		if err := d.Stop(); err != nil {
			return err
		}
	}

	listener, err := net.Listen("tcp4", fmt.Sprintf("%s:%d", d.opt.Host, d.opt.Port))
	if err != nil {
		return err
	}

	d.listener = listener

	methods := []string{
		"GET",
		"HEAD",
		"POST",
		"OPTIONS",
		"PUT",
		"DELETE",
		"MKCOL",
		"COPY",
		"MOVE",
		"LOCK",
		"UNLOCK",
		"PROPFIND",
		"PROPPATCH",
	}

	handler := &webdav.Handler{
		Prefix:     "/dav",
		FileSystem: &FS{d.fs},
		LockSystem: webdav.NewMemLS(),
		Logger: func(r *http.Request, err error) {
			if err != nil {
				fmt.Println(r.Method, err)
			}
		},
	}

	e := echo.New()
	e.Use(middleware.CORS())
	e.Use(middleware.BasicAuth(d.basicAuth))
	e.Match(methods, "/dav", echo.WrapHandler(handler))
	e.Match(methods, "/dav/*", echo.WrapHandler(handler))

	d.server = &http.Server{Handler: h2c.NewHandler(e, &http2.Server{})}

	go func() {
		if err := d.server.Serve(listener); err != nil && err != http.ErrServerClosed {
			d.mu.Lock()
			d.err = err
			d.mu.Unlock()
		}
	}()
	return nil
}

func (d *Webdav) Stop() error {
	d.mu.Lock()
	defer d.mu.Unlock()

	d.err = nil
	d.listener = nil
	if d.server != nil {
		if err := d.server.Shutdown(context.TODO()); err != nil {
			return err
		}
		d.server = nil
	}
	return nil
}

func New(fs driver.FS, opt *Option) (server.Server, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}
	return &Webdav{fs: fs, opt: opt}, nil
}

func init() {
	server.Register("webdav", func() server.Option {
		return &Option{}
	})
}

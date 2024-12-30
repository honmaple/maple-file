package main

import (
	"embed"
	"fmt"
	"io/fs"
	"os"

	"github.com/honmaple/maple-file/server/internal/app"
	"github.com/honmaple/maple-file/server/internal/app/config"
	"github.com/urfave/cli/v2"

	_ "github.com/honmaple/maple-file/server/internal/api"
)

var (
	//go:embed web
	webFS      embed.FS
	defaultApp = app.New()
)

func before(clx *cli.Context) error {
	if err := defaultApp.Config.LoadFromFile(clx.String("config")); err != nil {
		return err
	}
	return defaultApp.Init()
}

func action(clx *cli.Context) error {
	if addr := clx.String("addr"); addr != "" {
		defaultApp.Config.Set(config.ServerAddr, addr)
	}
	if debug := clx.Bool("debug"); debug {
		defaultApp.Config.Set("server.mode", "dev")
	}

	var root fs.FS

	if ok := clx.Bool("fs"); ok {
		rootFS, err := fs.Sub(webFS, "web")
		if err != nil {
			return err
		}
		root = rootFS
	}

	listener, err := app.Listen(defaultApp.Config.GetString(config.ServerAddr))
	if err != nil {
		return err
	}
	return defaultApp.Start(listener, root)
}

func main() {
	app := &cli.App{
		Name:    app.PROCESS,
		Usage:   app.DESCRIPTION,
		Version: app.VERSION,
		Flags: []cli.Flag{
			&cli.BoolFlag{
				Name:    "debug",
				Aliases: []string{"D"},
				Usage:   "debug mode",
			},
			&cli.BoolFlag{
				Name:    "fs",
				Aliases: []string{"F"},
				Usage:   "serve static file",
			},
			&cli.StringFlag{
				Name:    "addr",
				Aliases: []string{"a"},
				Usage:   "listen `ADDR`",
				Value:   "127.0.0.1:8000",
			},
			&cli.PathFlag{
				Name:    "config",
				Aliases: []string{"c"},
				Usage:   "load config from `FILE`",
				Value:   "config.yaml",
			},
		},
		Before: before,
		Action: action,
	}
	if err := app.Run(os.Args); err != nil {
		fmt.Println(err.Error())
	}
}

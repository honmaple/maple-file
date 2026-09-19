package types

import "github.com/honmaple/maple-file/server/internal/app"

type Context struct {
	*app.Context
}

func NewContext(ctx *app.Context) *Context {
	return &Context{Context: ctx}
}

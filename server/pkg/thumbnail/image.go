package thumbnail

import (
	"context"
	"image"
	_ "image/gif"
	"image/jpeg"
	_ "image/png"
	"io"
	"strings"

	"github.com/honmaple/maple-file/server/pkg/util"
	"golang.org/x/image/draw"
)

type ImageOption struct {
	Width   int
	Height  int
	Quality int
}

func (opt *ImageOption) Match(mimeType string) bool {
	return strings.HasPrefix(mimeType, "image/")
}

func (opt *ImageOption) New() (Generator, error) {
	return NewImageGenerator(opt)
}

type imageGenerator struct {
	opt *ImageOption
}

func (d *imageGenerator) Generate(ctx context.Context, file io.ReadSeeker, size int64) (io.ReadCloser, error) {
	img, _, err := image.Decode(file)
	if err != nil {
		return nil, err
	}

	// ratio := (float64)(src.Bounds().Max.Y) / (float64)(src.Bounds().Max.X)
	//    height := int(math.Round(float64(width) * ratio))

	newImg := image.NewRGBA(image.Rect(0, 0, d.opt.Width, d.opt.Height))
	draw.BiLinear.Scale(newImg, newImg.Rect, img, img.Bounds(), draw.Src, nil)

	r, w := util.Pipe()
	go func() {
		err := jpeg.Encode(w, newImg, &jpeg.Options{Quality: d.opt.Quality})
		w.CloseWithError(err)
	}()
	return r, nil
}

func NewImageGenerator(opt *ImageOption) (Generator, error) {
	if opt.Width <= 0 {
		opt.Width = 200
	}
	if opt.Height <= 0 {
		opt.Height = 200
	}
	if opt.Quality <= 0 {
		opt.Quality = 100
	}
	return &imageGenerator{opt: opt}, nil
}

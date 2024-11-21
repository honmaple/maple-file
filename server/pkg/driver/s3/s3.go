package s3

import (
	"context"
	"io"

	"github.com/honmaple/maple-file/server/pkg/driver"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
)

type Option struct {
	Endpoint  string `json:"endpoint"`
	Bucket    string `json:"bucket"`
	Region    string `json:"region"`
	AccessKey string `json:"access_key"`
	SecretKey string `json:"secret_key"`
	RootPath  string `json:"root_path"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type S3 struct {
	driver.Base
	opt    *Option
	client *s3.S3
}

var _ driver.FS = (*S3)(nil)

func (d *S3) WalkDir(ctx context.Context, root string, fn driver.WalkDirFunc) error {
	input := &s3.ListObjectsInput{
		Bucket:  aws.String(d.opt.Bucket),
		Prefix:  aws.String(root),
		MaxKeys: aws.Int64(1000),
	}

	for {
		result, err := d.client.ListObjectsWithContext(ctx, input)
		if err != nil {
			return err
		}

		// 处理目录
		for _, object := range result.CommonPrefixes {
			err := fn(driver.NewFile(*input.Prefix, &dirinfo{object}), nil)
			if err != nil {
				return err
			}
		}

		// 处理文件
		for _, object := range result.Contents {
			err := fn(driver.NewFile(*input.Prefix, &fileinfo{object}), nil)
			if err != nil {
				return err
			}
		}

		if result.IsTruncated != nil && *result.IsTruncated {
			input.Marker = result.NextMarker
		} else {
			break
		}
	}
	return nil
}

func (d *S3) List(ctx context.Context, path string) ([]driver.File, error) {
	input := &s3.ListObjectsInput{
		Bucket:    aws.String(d.opt.Bucket),
		Prefix:    aws.String(path),
		MaxKeys:   aws.Int64(1000),
		Delimiter: aws.String("/"),
	}

	files := make([]driver.File, 0)
	for {
		result, err := d.client.ListObjectsWithContext(ctx, input)
		if err != nil {
			return nil, err
		}

		// 处理目录
		for _, object := range result.CommonPrefixes {
			files = append(files, driver.NewFile(*input.Prefix, &dirinfo{object}))
		}

		// 处理文件
		for _, object := range result.Contents {
			files = append(files, driver.NewFile(*input.Prefix, &fileinfo{object}))
		}

		if result.IsTruncated != nil && *result.IsTruncated {
			input.Marker = result.NextMarker
		} else {
			break
		}
	}
	return files, nil
}

func (d *S3) Move(ctx context.Context, src, dst string) error {
	if err := d.Copy(ctx, src, dst); err != nil {
		return err
	}
	return d.Remove(ctx, src)
}

func (d *S3) Copy(ctx context.Context, src, dst string) error {
	input := &s3.CopyObjectInput{
		Bucket:     aws.String(d.opt.Bucket),
		CopySource: aws.String("/" + d.opt.Bucket + "/" + src),
		Key:        aws.String(dst),
	}
	_, err := d.client.CopyObjectWithContext(ctx, input)
	return err
}

func (d *S3) Rename(ctx context.Context, src, dst string) error {
	return d.Move(ctx, src, dst)
}

func (d *S3) Remove(ctx context.Context, path string) error {
	input := &s3.DeleteObjectInput{
		Bucket: aws.String(d.opt.Bucket),
		Key:    aws.String(path),
	}
	_, err := d.client.DeleteObjectWithContext(ctx, input)
	return err
}

func (d *S3) MakeDir(ctx context.Context, path string) error {
	uploader := s3manager.NewUploader(nil)

	_, err := uploader.UploadWithContext(ctx, &s3manager.UploadInput{
		Bucket: aws.String(""),
		Key:    aws.String(""),
		Body:   nil,
	})
	return err
}

func (d *S3) Open(path string) (driver.FileReader, error) {
	input := &s3.GetObjectInput{
		Bucket: aws.String(""),
		Key:    aws.String(""),
	}
	result, err := d.client.GetObject(input)
	if err != nil {
		return nil, err
	}
	return driver.ReadSeeker(result.Body, *result.ContentLength), nil
}

func (d *S3) Create(path string) (driver.FileWriter, error) {
	r, w := io.Pipe()
	go func() {
		uploader := s3manager.NewUploader(nil)

		_, err := uploader.Upload(&s3manager.UploadInput{
			Bucket: aws.String(""),
			Key:    aws.String(""),
			Body:   r,
		})
		r.CloseWithError(err)
	}()
	return w, nil
}

func (d *S3) Get(path string) (driver.File, error) {
	input := &s3.GetObjectInput{
		Bucket: aws.String(""),
		Key:    aws.String(""),
	}
	object, err := d.client.GetObject(input)
	if err != nil {
		return nil, err
	}
	info := &fileinfo1{
		name: "",
		size: *object.ContentLength,
	}
	return driver.NewFile(path, info), nil
}

func (d *S3) Close() error {
	return nil
}

func New(opt *Option) (driver.FS, error) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String(opt.Region),
	})
	if err != nil {
		return nil, err
	}

	d := &S3{
		opt:    opt,
		client: s3.New(sess),
	}
	if opt.RootPath != "" {
		return driver.PrefixFS(d, opt.RootPath), nil
	}
	return d, nil
}

func init() {
	driver.Register("s3", func() driver.Option {
		return &Option{}
	})
}

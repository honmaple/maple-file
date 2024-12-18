package s3

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"path/filepath"
	"strings"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/credentials"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
	"github.com/honmaple/maple-file/server/pkg/driver"
)

type Option struct {
	Endpoint  string `json:"endpoint"    validate:"required"`
	Bucket    string `json:"bucket"      validate:"required"`
	Region    string `json:"region"`
	AccessKey string `json:"access_key"`
	SecretKey string `json:"secret_key"  validate:"required_with=AccessKey"`
	RootPath  string `json:"root_path"   validate:"omitempty,startswith=/"`
}

func (opt *Option) NewFS() (driver.FS, error) {
	return New(opt)
}

type S3 struct {
	driver.Base
	opt     *Option
	client  *s3.S3
	session *session.Session
}

var _ driver.FS = (*S3)(nil)

func (d *S3) getPath(path string, isDir bool) string {
	path = strings.TrimPrefix(path, "/")
	if path != "" && isDir {
		path = path + "/"
	}
	return path
}

func (d *S3) WalkDir(ctx context.Context, root string, fn driver.WalkDirFunc) error {
	root = d.getPath(root, true)

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
		Prefix:    aws.String(d.getPath(path, true)),
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
			files = append(files, driver.NewFile(path, &dirinfo{object}))
		}

		// 处理文件
		for _, object := range result.Contents {
			if *input.Prefix == *object.Key {
				continue
			}
			files = append(files, driver.NewFile(path, &fileinfo{object}))
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

func (d *S3) copyDir(ctx context.Context, src, dst string) error {
	files, err := d.List(ctx, src)
	if err != nil {
		return err
	}
	for _, file := range files {
		srcPath := filepath.Join(src, file.Name())
		dstPath := filepath.Join(dst, file.Name())
		if file.IsDir() {
			err = d.copyDir(ctx, srcPath, dstPath)
		} else {
			err = d.copyFile(ctx, srcPath, dstPath)
		}
		if err != nil {
			return err
		}
	}
	return err
}

func (d *S3) copyFile(ctx context.Context, src, dst string) error {
	input := &s3.CopyObjectInput{
		Bucket:     aws.String(d.opt.Bucket),
		CopySource: aws.String("/" + d.opt.Bucket + "/" + d.getPath(src, false)),
		Key:        aws.String(d.getPath(dst, false)),
	}
	_, err := d.client.CopyObjectWithContext(ctx, input)
	return err
}

func (d *S3) Copy(ctx context.Context, src, dst string) error {
	info, err := d.Get(src)
	if err != nil {
		return err
	}
	if info.IsDir() {
		return d.copyDir(ctx, src, dst)
	}
	return d.copyFile(ctx, src, filepath.Join(dst, filepath.Base(src)))
}

func (d *S3) Rename(ctx context.Context, path, newName string) error {
	return d.Move(ctx, path, filepath.Join(filepath.Dir(path), newName))
}

func (d *S3) removeDir(ctx context.Context, path string) error {
	files, err := d.List(ctx, path)
	if err != nil {
		return err
	}
	for _, file := range files {
		fpath := filepath.Join(file.Path(), file.Name())
		if file.IsDir() {
			err = d.removeDir(ctx, fpath)
		} else {
			err = d.removeFile(ctx, fpath)
		}
		if err != nil {
			return err
		}
	}
	input := &s3.DeleteObjectInput{
		Bucket: aws.String(d.opt.Bucket),
		Key:    aws.String(d.getPath(path, true)),
	}
	_, err = d.client.DeleteObjectWithContext(ctx, input)
	return err
}

func (d *S3) removeFile(ctx context.Context, path string) error {
	input := &s3.DeleteObjectInput{
		Bucket: aws.String(d.opt.Bucket),
		Key:    aws.String(d.getPath(path, false)),
	}
	_, err := d.client.DeleteObjectWithContext(ctx, input)
	return err
}

func (d *S3) Remove(ctx context.Context, path string) error {
	info, err := d.Get(path)
	if err != nil {
		return err
	}
	if info.IsDir() {
		return d.removeDir(ctx, path)
	}
	return d.removeFile(ctx, path)
}

func (d *S3) MakeDir(ctx context.Context, path string) error {
	uploader := s3manager.NewUploader(d.session)

	_, err := uploader.UploadWithContext(ctx, &s3manager.UploadInput{
		Bucket: aws.String(d.opt.Bucket),
		Key:    aws.String(d.getPath(path, true)),
		Body:   io.NopCloser(bytes.NewReader([]byte{})),
	})
	return err
}

func (d *S3) Open(path string) (driver.FileReader, error) {
	result, err := d.client.HeadObject(&s3.HeadObjectInput{
		Bucket: aws.String(d.opt.Bucket),
		Key:    aws.String(d.getPath(path, false)),
	})
	if err != nil {
		return nil, err
	}

	rangeFunc := func(offset, length int64) (io.ReadCloser, error) {
		input := &s3.GetObjectInput{
			Bucket: aws.String(d.opt.Bucket),
			Key:    aws.String(d.getPath(path, false)),
		}
		if length > 0 {
			input.Range = aws.String(fmt.Sprintf("bytes=%d-%d", offset, offset+length-1))
		} else {
			input.Range = aws.String(fmt.Sprintf("bytes=%d-", offset))
		}
		result, err := d.client.GetObject(input)
		if err != nil {
			return nil, err
		}
		return result.Body, nil
	}
	return driver.NewFileReader(*result.ContentLength, rangeFunc)
}

func (d *S3) Create(path string) (driver.FileWriter, error) {
	r, w := io.Pipe()
	go func() {
		uploader := s3manager.NewUploader(d.session)

		_, err := uploader.Upload(&s3manager.UploadInput{
			Bucket: aws.String(d.opt.Bucket),
			Key:    aws.String(d.getPath(path, false)),
			Body:   r,
		})
		r.CloseWithError(err)
	}()
	return w, nil
}

func (d *S3) Get(path string) (driver.File, error) {
	result, err := d.client.HeadObject(&s3.HeadObjectInput{
		Bucket: aws.String(d.opt.Bucket),
		Key:    aws.String(d.getPath(path, false)),
	})
	if err != nil {
		if e, ok := err.(awserr.Error); ok && e.Code() == "NotFound" {
			input := &s3.ListObjectsInput{
				Bucket:    aws.String(d.opt.Bucket),
				Prefix:    aws.String(d.getPath(path, true)),
				Delimiter: aws.String("/"),
				MaxKeys:   aws.Int64(1),
			}
			ctx := context.Background()
			result, err := d.client.ListObjectsWithContext(ctx, input)
			if err != nil {
				return nil, err
			}
			if len(result.CommonPrefixes)+len(result.Contents) > 0 {
				info := &emptyinfo{
					name:  filepath.Base(path),
					isDir: true,
				}
				return driver.NewFile(filepath.Dir(path), info), nil
			}
		}
		return nil, err
	}
	return driver.NewFile(filepath.Dir(path), &headinfo{name: filepath.Base(path), info: result}), nil
}

func New(opt *Option) (driver.FS, error) {
	if err := driver.VerifyOption(opt); err != nil {
		return nil, err
	}
	if opt.Region == "" {
		opt.Region = "maple-file"
	}
	cfg := &aws.Config{
		Region:           aws.String(opt.Region),
		Endpoint:         aws.String(opt.Endpoint),
		S3ForcePathStyle: aws.Bool(true),
	}
	if opt.AccessKey != "" {
		cfg.Credentials = credentials.NewStaticCredentials(opt.AccessKey, opt.SecretKey, "")
	}
	sess, err := session.NewSession(cfg)
	if err != nil {
		return nil, err
	}

	d := &S3{
		opt:     opt,
		client:  s3.New(sess),
		session: sess,
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

package service

import (
	stdpath "path"
	"time"

	"github.com/honmaple/cloudfs"
	"github.com/honmaple/maple-file/server/internal/api/file/types"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type uploadReader struct {
	recv  func() (*pb.File_UploadRequest, error)
	chunk []byte
}

func (r *uploadReader) Read(p []byte) (int, error) {
	if len(p) == 0 {
		return 0, nil
	}
	for len(r.chunk) == 0 {
		req, err := r.recv()
		if err != nil {
			return 0, err
		}
		r.chunk = req.GetChunk()
	}
	n := copy(p, r.chunk)
	r.chunk = r.chunk[n:]
	return n, nil
}

type chunkFunc func([]byte) error

func (cf chunkFunc) Write(p []byte) (n int, err error) {
	if err := cf(p); err != nil {
		return 0, err
	}
	return len(p), nil
}

func resolveUploadPolicy(policy types.UploadPolicy, requested pb.File_UploadPolicy) pb.File_UploadPolicy {
	switch requested {
	case pb.File_UPLOAD_POLICY_PRESERVE, pb.File_UPLOAD_POLICY_RENAME:
		return requested
	}
	if policy == types.UploadPolicyRename {
		return pb.File_UPLOAD_POLICY_RENAME
	}
	return pb.File_UPLOAD_POLICY_PRESERVE
}

func renameFile(filename string) string {
	ext := stdpath.Ext(filename)
	name := filename[:len(filename)-len(ext)]
	return name + "_" + time.Now().Format("20060102_150405.000000000") + ext
}

func infoToFile(m cloudfs.FileInfo) *pb.File {
	file := &pb.File{
		Path:      m.Path(),
		Name:      m.Name(),
		Size:      m.Size(),
		Type:      m.Type(),
		CreatedAt: timestamppb.New(m.ModTime()),
		UpdatedAt: timestamppb.New(m.ModTime()),
	}
	return file
}

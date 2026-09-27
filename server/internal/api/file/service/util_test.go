package service

import (
	"io"
	"path"
	"strings"
	"testing"

	"github.com/honmaple/maple-file/server/internal/api/file/types"
	pb "github.com/honmaple/maple-file/server/internal/proto/api/file"
)

func TestUploadReaderPreservesUnreadChunkData(t *testing.T) {
	requests := []*pb.File_UploadRequest{
		{Chunk: []byte("abcdef")},
		{Chunk: []byte("gh")},
	}
	index := 0
	reader := &uploadReader{recv: func() (*pb.File_UploadRequest, error) {
		if index == len(requests) {
			return nil, io.EOF
		}
		request := requests[index]
		index++
		return request, nil
	}}

	var data []byte
	buffer := make([]byte, 2)
	for {
		n, err := reader.Read(buffer)
		data = append(data, buffer[:n]...)
		if err == io.EOF {
			break
		}
		if err != nil {
			t.Fatal(err)
		}
	}
	if got, want := string(data), "abcdefgh"; got != want {
		t.Fatalf("uploaded data = %q, want %q", got, want)
	}
}

func TestUploadReaderSkipsEmptyChunks(t *testing.T) {
	requests := []*pb.File_UploadRequest{
		{},
		{Chunk: []byte("data")},
	}
	index := 0
	reader := &uploadReader{recv: func() (*pb.File_UploadRequest, error) {
		if index == len(requests) {
			return nil, io.EOF
		}
		request := requests[index]
		index++
		return request, nil
	}}

	data, err := io.ReadAll(reader)
	if err != nil {
		t.Fatal(err)
	}
	if got, want := string(data), "data"; got != want {
		t.Fatalf("uploaded data = %q, want %q", got, want)
	}
}

func TestResolveUploadPolicy(t *testing.T) {
	tests := []struct {
		name      string
		global    types.UploadPolicy
		requested pb.File_UploadPolicy
		want      pb.File_UploadPolicy
	}{
		{
			name: "default preserves filename",
			want: pb.File_UPLOAD_POLICY_PRESERVE,
		},
		{
			name:   "inherits preserve policy",
			global: types.UploadPolicyPreserve,
			want:   pb.File_UPLOAD_POLICY_PRESERVE,
		},
		{
			name:   "inherits auto rename policy",
			global: types.UploadPolicyRename,
			want:   pb.File_UPLOAD_POLICY_RENAME,
		},
		{
			name:      "explicit preserve overrides global policy",
			global:    types.UploadPolicyRename,
			requested: pb.File_UPLOAD_POLICY_PRESERVE,
			want:      pb.File_UPLOAD_POLICY_PRESERVE,
		},
		{
			name:      "explicit auto rename overrides global policy",
			global:    types.UploadPolicyPreserve,
			requested: pb.File_UPLOAD_POLICY_RENAME,
			want:      pb.File_UPLOAD_POLICY_RENAME,
		},
		{
			name:      "unknown request inherits global policy",
			global:    types.UploadPolicyRename,
			requested: pb.File_UploadPolicy(99),
			want:      pb.File_UPLOAD_POLICY_RENAME,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := resolveUploadPolicy(tt.global, tt.requested); got != tt.want {
				t.Fatalf("resolveUploadPolicy() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestRenameFile(t *testing.T) {
	const filename = "archive.tar.gz"
	renamed := renameFile(filename)

	if path.Ext(renamed) != ".gz" {
		t.Fatalf("renameFile() extension = %q, want .gz", path.Ext(renamed))
	}
	if !strings.HasPrefix(renamed, "archive.tar_") {
		t.Fatalf("renameFile() = %q, want timestamp appended to base name", renamed)
	}
}

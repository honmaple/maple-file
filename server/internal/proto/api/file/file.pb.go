// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.36.6
// 	protoc        (unknown)
// source: api/file/file.proto

package file

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	timestamppb "google.golang.org/protobuf/types/known/timestamppb"
	reflect "reflect"
	sync "sync"
	unsafe "unsafe"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type File struct {
	state protoimpl.MessageState `protogen:"open.v1"`
	// @gotags: gorm:"primary_key;auto_increment"
	Id int32 `protobuf:"varint,1,opt,name=id,proto3" json:"id,omitempty" gorm:"primary_key;auto_increment"`
	// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
	CreatedAt *timestamppb.Timestamp `protobuf:"bytes,2,opt,name=created_at,json=createdAt,proto3" json:"created_at,omitempty" gorm:"serializer:protobuf_timestamp;type:datetime"`
	// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
	UpdatedAt *timestamppb.Timestamp `protobuf:"bytes,3,opt,name=updated_at,json=updatedAt,proto3" json:"updated_at,omitempty" gorm:"serializer:protobuf_timestamp;type:datetime"`
	// @gotags: gorm:"not null;"
	Name string `protobuf:"bytes,4,opt,name=name,proto3" json:"name,omitempty" gorm:"not null;"`
	Type string `protobuf:"bytes,5,opt,name=type,proto3" json:"type,omitempty"`
	Size int64  `protobuf:"varint,6,opt,name=size,proto3" json:"size,omitempty"`
	Hash string `protobuf:"bytes,7,opt,name=hash,proto3" json:"hash,omitempty"`
	// @gotags: gorm:"not null;"
	Path string `protobuf:"bytes,8,opt,name=path,proto3" json:"path,omitempty" gorm:"not null;"`
	Repo *Repo  `protobuf:"bytes,10,opt,name=repo,proto3" json:"repo,omitempty"`
	// @gotags: gorm:"not null"
	RepoId        int32 `protobuf:"varint,11,opt,name=repo_id,json=repoId,proto3" json:"repo_id,omitempty" gorm:"not null"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *File) Reset() {
	*x = File{}
	mi := &file_api_file_file_proto_msgTypes[0]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *File) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*File) ProtoMessage() {}

func (x *File) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[0]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use File.ProtoReflect.Descriptor instead.
func (*File) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{0}
}

func (x *File) GetId() int32 {
	if x != nil {
		return x.Id
	}
	return 0
}

func (x *File) GetCreatedAt() *timestamppb.Timestamp {
	if x != nil {
		return x.CreatedAt
	}
	return nil
}

func (x *File) GetUpdatedAt() *timestamppb.Timestamp {
	if x != nil {
		return x.UpdatedAt
	}
	return nil
}

func (x *File) GetName() string {
	if x != nil {
		return x.Name
	}
	return ""
}

func (x *File) GetType() string {
	if x != nil {
		return x.Type
	}
	return ""
}

func (x *File) GetSize() int64 {
	if x != nil {
		return x.Size
	}
	return 0
}

func (x *File) GetHash() string {
	if x != nil {
		return x.Hash
	}
	return ""
}

func (x *File) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

func (x *File) GetRepo() *Repo {
	if x != nil {
		return x.Repo
	}
	return nil
}

func (x *File) GetRepoId() int32 {
	if x != nil {
		return x.RepoId
	}
	return 0
}

type FileRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Index         int32                  `protobuf:"varint,1,opt,name=index,proto3" json:"index,omitempty"`
	Size          int64                  `protobuf:"varint,5,opt,name=size,proto3" json:"size,omitempty"`
	Path          string                 `protobuf:"bytes,3,opt,name=path,proto3" json:"path,omitempty"`
	Filename      string                 `protobuf:"bytes,4,opt,name=filename,proto3" json:"filename,omitempty"`
	Chunk         []byte                 `protobuf:"bytes,2,opt,name=chunk,proto3" json:"chunk,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *FileRequest) Reset() {
	*x = FileRequest{}
	mi := &file_api_file_file_proto_msgTypes[1]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *FileRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*FileRequest) ProtoMessage() {}

func (x *FileRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[1]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use FileRequest.ProtoReflect.Descriptor instead.
func (*FileRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{1}
}

func (x *FileRequest) GetIndex() int32 {
	if x != nil {
		return x.Index
	}
	return 0
}

func (x *FileRequest) GetSize() int64 {
	if x != nil {
		return x.Size
	}
	return 0
}

func (x *FileRequest) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

func (x *FileRequest) GetFilename() string {
	if x != nil {
		return x.Filename
	}
	return ""
}

func (x *FileRequest) GetChunk() []byte {
	if x != nil {
		return x.Chunk
	}
	return nil
}

type FileResponse struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Result        *File                  `protobuf:"bytes,1,opt,name=result,proto3" json:"result,omitempty"`
	Message       string                 `protobuf:"bytes,2,opt,name=message,proto3" json:"message,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *FileResponse) Reset() {
	*x = FileResponse{}
	mi := &file_api_file_file_proto_msgTypes[2]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *FileResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*FileResponse) ProtoMessage() {}

func (x *FileResponse) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[2]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use FileResponse.ProtoReflect.Descriptor instead.
func (*FileResponse) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{2}
}

func (x *FileResponse) GetResult() *File {
	if x != nil {
		return x.Result
	}
	return nil
}

func (x *FileResponse) GetMessage() string {
	if x != nil {
		return x.Message
	}
	return ""
}

type ListFilesRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Filter        map[string]string      `protobuf:"bytes,1,rep,name=filter,proto3" json:"filter,omitempty" protobuf_key:"bytes,1,opt,name=key" protobuf_val:"bytes,2,opt,name=value"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *ListFilesRequest) Reset() {
	*x = ListFilesRequest{}
	mi := &file_api_file_file_proto_msgTypes[3]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *ListFilesRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*ListFilesRequest) ProtoMessage() {}

func (x *ListFilesRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[3]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use ListFilesRequest.ProtoReflect.Descriptor instead.
func (*ListFilesRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{3}
}

func (x *ListFilesRequest) GetFilter() map[string]string {
	if x != nil {
		return x.Filter
	}
	return nil
}

type ListFilesResponse struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Results       []*File                `protobuf:"bytes,1,rep,name=results,proto3" json:"results,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *ListFilesResponse) Reset() {
	*x = ListFilesResponse{}
	mi := &file_api_file_file_proto_msgTypes[4]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *ListFilesResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*ListFilesResponse) ProtoMessage() {}

func (x *ListFilesResponse) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[4]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use ListFilesResponse.ProtoReflect.Descriptor instead.
func (*ListFilesResponse) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{4}
}

func (x *ListFilesResponse) GetResults() []*File {
	if x != nil {
		return x.Results
	}
	return nil
}

type MoveFileRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Path          string                 `protobuf:"bytes,1,opt,name=path,proto3" json:"path,omitempty"`
	NewPath       string                 `protobuf:"bytes,2,opt,name=new_path,json=newPath,proto3" json:"new_path,omitempty"`
	Names         []string               `protobuf:"bytes,3,rep,name=names,proto3" json:"names,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *MoveFileRequest) Reset() {
	*x = MoveFileRequest{}
	mi := &file_api_file_file_proto_msgTypes[5]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *MoveFileRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*MoveFileRequest) ProtoMessage() {}

func (x *MoveFileRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[5]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use MoveFileRequest.ProtoReflect.Descriptor instead.
func (*MoveFileRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{5}
}

func (x *MoveFileRequest) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

func (x *MoveFileRequest) GetNewPath() string {
	if x != nil {
		return x.NewPath
	}
	return ""
}

func (x *MoveFileRequest) GetNames() []string {
	if x != nil {
		return x.Names
	}
	return nil
}

type MoveFileResponse struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *MoveFileResponse) Reset() {
	*x = MoveFileResponse{}
	mi := &file_api_file_file_proto_msgTypes[6]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *MoveFileResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*MoveFileResponse) ProtoMessage() {}

func (x *MoveFileResponse) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[6]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use MoveFileResponse.ProtoReflect.Descriptor instead.
func (*MoveFileResponse) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{6}
}

type CopyFileRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Path          string                 `protobuf:"bytes,1,opt,name=path,proto3" json:"path,omitempty"`
	NewPath       string                 `protobuf:"bytes,2,opt,name=new_path,json=newPath,proto3" json:"new_path,omitempty"`
	Names         []string               `protobuf:"bytes,3,rep,name=names,proto3" json:"names,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *CopyFileRequest) Reset() {
	*x = CopyFileRequest{}
	mi := &file_api_file_file_proto_msgTypes[7]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *CopyFileRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*CopyFileRequest) ProtoMessage() {}

func (x *CopyFileRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[7]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use CopyFileRequest.ProtoReflect.Descriptor instead.
func (*CopyFileRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{7}
}

func (x *CopyFileRequest) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

func (x *CopyFileRequest) GetNewPath() string {
	if x != nil {
		return x.NewPath
	}
	return ""
}

func (x *CopyFileRequest) GetNames() []string {
	if x != nil {
		return x.Names
	}
	return nil
}

type CopyFileResponse struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *CopyFileResponse) Reset() {
	*x = CopyFileResponse{}
	mi := &file_api_file_file_proto_msgTypes[8]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *CopyFileResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*CopyFileResponse) ProtoMessage() {}

func (x *CopyFileResponse) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[8]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use CopyFileResponse.ProtoReflect.Descriptor instead.
func (*CopyFileResponse) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{8}
}

type MkdirFileRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Path          string                 `protobuf:"bytes,1,opt,name=path,proto3" json:"path,omitempty"`
	Name          string                 `protobuf:"bytes,2,opt,name=name,proto3" json:"name,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *MkdirFileRequest) Reset() {
	*x = MkdirFileRequest{}
	mi := &file_api_file_file_proto_msgTypes[9]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *MkdirFileRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*MkdirFileRequest) ProtoMessage() {}

func (x *MkdirFileRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[9]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use MkdirFileRequest.ProtoReflect.Descriptor instead.
func (*MkdirFileRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{9}
}

func (x *MkdirFileRequest) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

func (x *MkdirFileRequest) GetName() string {
	if x != nil {
		return x.Name
	}
	return ""
}

type MkdirFileResponse struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *MkdirFileResponse) Reset() {
	*x = MkdirFileResponse{}
	mi := &file_api_file_file_proto_msgTypes[10]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *MkdirFileResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*MkdirFileResponse) ProtoMessage() {}

func (x *MkdirFileResponse) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[10]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use MkdirFileResponse.ProtoReflect.Descriptor instead.
func (*MkdirFileResponse) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{10}
}

type RenameFileRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Path          string                 `protobuf:"bytes,1,opt,name=path,proto3" json:"path,omitempty"`
	Name          string                 `protobuf:"bytes,2,opt,name=name,proto3" json:"name,omitempty"`
	NewName       string                 `protobuf:"bytes,3,opt,name=new_name,json=newName,proto3" json:"new_name,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *RenameFileRequest) Reset() {
	*x = RenameFileRequest{}
	mi := &file_api_file_file_proto_msgTypes[11]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *RenameFileRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*RenameFileRequest) ProtoMessage() {}

func (x *RenameFileRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[11]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use RenameFileRequest.ProtoReflect.Descriptor instead.
func (*RenameFileRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{11}
}

func (x *RenameFileRequest) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

func (x *RenameFileRequest) GetName() string {
	if x != nil {
		return x.Name
	}
	return ""
}

func (x *RenameFileRequest) GetNewName() string {
	if x != nil {
		return x.NewName
	}
	return ""
}

type RenameFileResponse struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *RenameFileResponse) Reset() {
	*x = RenameFileResponse{}
	mi := &file_api_file_file_proto_msgTypes[12]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *RenameFileResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*RenameFileResponse) ProtoMessage() {}

func (x *RenameFileResponse) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[12]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use RenameFileResponse.ProtoReflect.Descriptor instead.
func (*RenameFileResponse) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{12}
}

type RemoveFileRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Path          string                 `protobuf:"bytes,1,opt,name=path,proto3" json:"path,omitempty"`
	Names         []string               `protobuf:"bytes,3,rep,name=names,proto3" json:"names,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *RemoveFileRequest) Reset() {
	*x = RemoveFileRequest{}
	mi := &file_api_file_file_proto_msgTypes[13]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *RemoveFileRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*RemoveFileRequest) ProtoMessage() {}

func (x *RemoveFileRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[13]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use RemoveFileRequest.ProtoReflect.Descriptor instead.
func (*RemoveFileRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{13}
}

func (x *RemoveFileRequest) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

func (x *RemoveFileRequest) GetNames() []string {
	if x != nil {
		return x.Names
	}
	return nil
}

type RemoveFileResponse struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *RemoveFileResponse) Reset() {
	*x = RemoveFileResponse{}
	mi := &file_api_file_file_proto_msgTypes[14]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *RemoveFileResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*RemoveFileResponse) ProtoMessage() {}

func (x *RemoveFileResponse) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[14]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use RemoveFileResponse.ProtoReflect.Descriptor instead.
func (*RemoveFileResponse) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{14}
}

type UploadFileRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *UploadFileRequest) Reset() {
	*x = UploadFileRequest{}
	mi := &file_api_file_file_proto_msgTypes[15]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *UploadFileRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*UploadFileRequest) ProtoMessage() {}

func (x *UploadFileRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[15]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use UploadFileRequest.ProtoReflect.Descriptor instead.
func (*UploadFileRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{15}
}

type PreviewFileRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Path          string                 `protobuf:"bytes,1,opt,name=path,proto3" json:"path,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *PreviewFileRequest) Reset() {
	*x = PreviewFileRequest{}
	mi := &file_api_file_file_proto_msgTypes[16]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *PreviewFileRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*PreviewFileRequest) ProtoMessage() {}

func (x *PreviewFileRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[16]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use PreviewFileRequest.ProtoReflect.Descriptor instead.
func (*PreviewFileRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{16}
}

func (x *PreviewFileRequest) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

type PreviewFileResponse struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Chunk         []byte                 `protobuf:"bytes,1,opt,name=chunk,proto3" json:"chunk,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *PreviewFileResponse) Reset() {
	*x = PreviewFileResponse{}
	mi := &file_api_file_file_proto_msgTypes[17]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *PreviewFileResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*PreviewFileResponse) ProtoMessage() {}

func (x *PreviewFileResponse) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[17]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use PreviewFileResponse.ProtoReflect.Descriptor instead.
func (*PreviewFileResponse) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{17}
}

func (x *PreviewFileResponse) GetChunk() []byte {
	if x != nil {
		return x.Chunk
	}
	return nil
}

type DownloadFileRequest struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Path          string                 `protobuf:"bytes,1,opt,name=path,proto3" json:"path,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *DownloadFileRequest) Reset() {
	*x = DownloadFileRequest{}
	mi := &file_api_file_file_proto_msgTypes[18]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *DownloadFileRequest) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*DownloadFileRequest) ProtoMessage() {}

func (x *DownloadFileRequest) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[18]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use DownloadFileRequest.ProtoReflect.Descriptor instead.
func (*DownloadFileRequest) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{18}
}

func (x *DownloadFileRequest) GetPath() string {
	if x != nil {
		return x.Path
	}
	return ""
}

type DownloadFileResponse struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Chunk         []byte                 `protobuf:"bytes,1,opt,name=chunk,proto3" json:"chunk,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *DownloadFileResponse) Reset() {
	*x = DownloadFileResponse{}
	mi := &file_api_file_file_proto_msgTypes[19]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *DownloadFileResponse) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*DownloadFileResponse) ProtoMessage() {}

func (x *DownloadFileResponse) ProtoReflect() protoreflect.Message {
	mi := &file_api_file_file_proto_msgTypes[19]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use DownloadFileResponse.ProtoReflect.Descriptor instead.
func (*DownloadFileResponse) Descriptor() ([]byte, []int) {
	return file_api_file_file_proto_rawDescGZIP(), []int{19}
}

func (x *DownloadFileResponse) GetChunk() []byte {
	if x != nil {
		return x.Chunk
	}
	return nil
}

var File_api_file_file_proto protoreflect.FileDescriptor

const file_api_file_file_proto_rawDesc = "" +
	"\n" +
	"\x13api/file/file.proto\x12\bapi.file\x1a\x1fgoogle/protobuf/timestamp.proto\x1a\x13api/file/repo.proto\"\xad\x02\n" +
	"\x04File\x12\x0e\n" +
	"\x02id\x18\x01 \x01(\x05R\x02id\x129\n" +
	"\n" +
	"created_at\x18\x02 \x01(\v2\x1a.google.protobuf.TimestampR\tcreatedAt\x129\n" +
	"\n" +
	"updated_at\x18\x03 \x01(\v2\x1a.google.protobuf.TimestampR\tupdatedAt\x12\x12\n" +
	"\x04name\x18\x04 \x01(\tR\x04name\x12\x12\n" +
	"\x04type\x18\x05 \x01(\tR\x04type\x12\x12\n" +
	"\x04size\x18\x06 \x01(\x03R\x04size\x12\x12\n" +
	"\x04hash\x18\a \x01(\tR\x04hash\x12\x12\n" +
	"\x04path\x18\b \x01(\tR\x04path\x12\"\n" +
	"\x04repo\x18\n" +
	" \x01(\v2\x0e.api.file.RepoR\x04repo\x12\x17\n" +
	"\arepo_id\x18\v \x01(\x05R\x06repoId\"}\n" +
	"\vFileRequest\x12\x14\n" +
	"\x05index\x18\x01 \x01(\x05R\x05index\x12\x12\n" +
	"\x04size\x18\x05 \x01(\x03R\x04size\x12\x12\n" +
	"\x04path\x18\x03 \x01(\tR\x04path\x12\x1a\n" +
	"\bfilename\x18\x04 \x01(\tR\bfilename\x12\x14\n" +
	"\x05chunk\x18\x02 \x01(\fR\x05chunk\"P\n" +
	"\fFileResponse\x12&\n" +
	"\x06result\x18\x01 \x01(\v2\x0e.api.file.FileR\x06result\x12\x18\n" +
	"\amessage\x18\x02 \x01(\tR\amessage\"\x8d\x01\n" +
	"\x10ListFilesRequest\x12>\n" +
	"\x06filter\x18\x01 \x03(\v2&.api.file.ListFilesRequest.FilterEntryR\x06filter\x1a9\n" +
	"\vFilterEntry\x12\x10\n" +
	"\x03key\x18\x01 \x01(\tR\x03key\x12\x14\n" +
	"\x05value\x18\x02 \x01(\tR\x05value:\x028\x01\"=\n" +
	"\x11ListFilesResponse\x12(\n" +
	"\aresults\x18\x01 \x03(\v2\x0e.api.file.FileR\aresults\"V\n" +
	"\x0fMoveFileRequest\x12\x12\n" +
	"\x04path\x18\x01 \x01(\tR\x04path\x12\x19\n" +
	"\bnew_path\x18\x02 \x01(\tR\anewPath\x12\x14\n" +
	"\x05names\x18\x03 \x03(\tR\x05names\"\x12\n" +
	"\x10MoveFileResponse\"V\n" +
	"\x0fCopyFileRequest\x12\x12\n" +
	"\x04path\x18\x01 \x01(\tR\x04path\x12\x19\n" +
	"\bnew_path\x18\x02 \x01(\tR\anewPath\x12\x14\n" +
	"\x05names\x18\x03 \x03(\tR\x05names\"\x12\n" +
	"\x10CopyFileResponse\":\n" +
	"\x10MkdirFileRequest\x12\x12\n" +
	"\x04path\x18\x01 \x01(\tR\x04path\x12\x12\n" +
	"\x04name\x18\x02 \x01(\tR\x04name\"\x13\n" +
	"\x11MkdirFileResponse\"V\n" +
	"\x11RenameFileRequest\x12\x12\n" +
	"\x04path\x18\x01 \x01(\tR\x04path\x12\x12\n" +
	"\x04name\x18\x02 \x01(\tR\x04name\x12\x19\n" +
	"\bnew_name\x18\x03 \x01(\tR\anewName\"\x14\n" +
	"\x12RenameFileResponse\"=\n" +
	"\x11RemoveFileRequest\x12\x12\n" +
	"\x04path\x18\x01 \x01(\tR\x04path\x12\x14\n" +
	"\x05names\x18\x03 \x03(\tR\x05names\"\x14\n" +
	"\x12RemoveFileResponse\"\x13\n" +
	"\x11UploadFileRequest\"(\n" +
	"\x12PreviewFileRequest\x12\x12\n" +
	"\x04path\x18\x01 \x01(\tR\x04path\"+\n" +
	"\x13PreviewFileResponse\x12\x14\n" +
	"\x05chunk\x18\x01 \x01(\fR\x05chunk\")\n" +
	"\x13DownloadFileRequest\x12\x12\n" +
	"\x04path\x18\x01 \x01(\tR\x04path\",\n" +
	"\x14DownloadFileResponse\x12\x14\n" +
	"\x05chunk\x18\x01 \x01(\fR\x05chunkB\x99\x01\n" +
	"\fcom.api.fileB\tFileProtoP\x01Z=github.com/honmaple/maple-file/server/internal/proto/api/file\xa2\x02\x03AFX\xaa\x02\bApi.File\xca\x02\bApi\\File\xe2\x02\x14Api\\File\\GPBMetadata\xea\x02\tApi::Fileb\x06proto3"

var (
	file_api_file_file_proto_rawDescOnce sync.Once
	file_api_file_file_proto_rawDescData []byte
)

func file_api_file_file_proto_rawDescGZIP() []byte {
	file_api_file_file_proto_rawDescOnce.Do(func() {
		file_api_file_file_proto_rawDescData = protoimpl.X.CompressGZIP(unsafe.Slice(unsafe.StringData(file_api_file_file_proto_rawDesc), len(file_api_file_file_proto_rawDesc)))
	})
	return file_api_file_file_proto_rawDescData
}

var file_api_file_file_proto_msgTypes = make([]protoimpl.MessageInfo, 21)
var file_api_file_file_proto_goTypes = []any{
	(*File)(nil),                  // 0: api.file.File
	(*FileRequest)(nil),           // 1: api.file.FileRequest
	(*FileResponse)(nil),          // 2: api.file.FileResponse
	(*ListFilesRequest)(nil),      // 3: api.file.ListFilesRequest
	(*ListFilesResponse)(nil),     // 4: api.file.ListFilesResponse
	(*MoveFileRequest)(nil),       // 5: api.file.MoveFileRequest
	(*MoveFileResponse)(nil),      // 6: api.file.MoveFileResponse
	(*CopyFileRequest)(nil),       // 7: api.file.CopyFileRequest
	(*CopyFileResponse)(nil),      // 8: api.file.CopyFileResponse
	(*MkdirFileRequest)(nil),      // 9: api.file.MkdirFileRequest
	(*MkdirFileResponse)(nil),     // 10: api.file.MkdirFileResponse
	(*RenameFileRequest)(nil),     // 11: api.file.RenameFileRequest
	(*RenameFileResponse)(nil),    // 12: api.file.RenameFileResponse
	(*RemoveFileRequest)(nil),     // 13: api.file.RemoveFileRequest
	(*RemoveFileResponse)(nil),    // 14: api.file.RemoveFileResponse
	(*UploadFileRequest)(nil),     // 15: api.file.UploadFileRequest
	(*PreviewFileRequest)(nil),    // 16: api.file.PreviewFileRequest
	(*PreviewFileResponse)(nil),   // 17: api.file.PreviewFileResponse
	(*DownloadFileRequest)(nil),   // 18: api.file.DownloadFileRequest
	(*DownloadFileResponse)(nil),  // 19: api.file.DownloadFileResponse
	nil,                           // 20: api.file.ListFilesRequest.FilterEntry
	(*timestamppb.Timestamp)(nil), // 21: google.protobuf.Timestamp
	(*Repo)(nil),                  // 22: api.file.Repo
}
var file_api_file_file_proto_depIdxs = []int32{
	21, // 0: api.file.File.created_at:type_name -> google.protobuf.Timestamp
	21, // 1: api.file.File.updated_at:type_name -> google.protobuf.Timestamp
	22, // 2: api.file.File.repo:type_name -> api.file.Repo
	0,  // 3: api.file.FileResponse.result:type_name -> api.file.File
	20, // 4: api.file.ListFilesRequest.filter:type_name -> api.file.ListFilesRequest.FilterEntry
	0,  // 5: api.file.ListFilesResponse.results:type_name -> api.file.File
	6,  // [6:6] is the sub-list for method output_type
	6,  // [6:6] is the sub-list for method input_type
	6,  // [6:6] is the sub-list for extension type_name
	6,  // [6:6] is the sub-list for extension extendee
	0,  // [0:6] is the sub-list for field type_name
}

func init() { file_api_file_file_proto_init() }
func file_api_file_file_proto_init() {
	if File_api_file_file_proto != nil {
		return
	}
	file_api_file_repo_proto_init()
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: unsafe.Slice(unsafe.StringData(file_api_file_file_proto_rawDesc), len(file_api_file_file_proto_rawDesc)),
			NumEnums:      0,
			NumMessages:   21,
			NumExtensions: 0,
			NumServices:   0,
		},
		GoTypes:           file_api_file_file_proto_goTypes,
		DependencyIndexes: file_api_file_file_proto_depIdxs,
		MessageInfos:      file_api_file_file_proto_msgTypes,
	}.Build()
	File_api_file_file_proto = out.File
	file_api_file_file_proto_goTypes = nil
	file_api_file_file_proto_depIdxs = nil
}

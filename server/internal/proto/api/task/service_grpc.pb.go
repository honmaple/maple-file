// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.2.0
// - protoc             (unknown)
// source: api/task/service.proto

package task

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// TaskServiceClient is the client API for TaskService service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type TaskServiceClient interface {
	ListTasks(ctx context.Context, in *ListTasksRequest, opts ...grpc.CallOption) (*ListTasksResponse, error)
	RetryTask(ctx context.Context, in *RetryTaskRequest, opts ...grpc.CallOption) (*RetryTaskResponse, error)
	CancelTask(ctx context.Context, in *CancelTaskRequest, opts ...grpc.CallOption) (*CancelTaskResponse, error)
	RemoveTask(ctx context.Context, in *RemoveTaskRequest, opts ...grpc.CallOption) (*RemoveTaskResponse, error)
	ListPersistTasks(ctx context.Context, in *ListPersistTasksRequest, opts ...grpc.CallOption) (*ListPersistTasksResponse, error)
	CreatePersistTask(ctx context.Context, in *CreatePersistTaskRequest, opts ...grpc.CallOption) (*CreatePersistTaskResponse, error)
	UpdatePersistTask(ctx context.Context, in *UpdatePersistTaskRequest, opts ...grpc.CallOption) (*UpdatePersistTaskResponse, error)
	DeletePersistTask(ctx context.Context, in *DeletePersistTaskRequest, opts ...grpc.CallOption) (*DeletePersistTaskResponse, error)
	TestPersistTask(ctx context.Context, in *TestPersistTaskRequest, opts ...grpc.CallOption) (*TestPersistTaskResponse, error)
	ExecutePersistTask(ctx context.Context, in *ExecutePersistTaskRequest, opts ...grpc.CallOption) (*ExecutePersistTaskResponse, error)
}

type taskServiceClient struct {
	cc grpc.ClientConnInterface
}

func NewTaskServiceClient(cc grpc.ClientConnInterface) TaskServiceClient {
	return &taskServiceClient{cc}
}

func (c *taskServiceClient) ListTasks(ctx context.Context, in *ListTasksRequest, opts ...grpc.CallOption) (*ListTasksResponse, error) {
	out := new(ListTasksResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/ListTasks", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *taskServiceClient) RetryTask(ctx context.Context, in *RetryTaskRequest, opts ...grpc.CallOption) (*RetryTaskResponse, error) {
	out := new(RetryTaskResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/RetryTask", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *taskServiceClient) CancelTask(ctx context.Context, in *CancelTaskRequest, opts ...grpc.CallOption) (*CancelTaskResponse, error) {
	out := new(CancelTaskResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/CancelTask", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *taskServiceClient) RemoveTask(ctx context.Context, in *RemoveTaskRequest, opts ...grpc.CallOption) (*RemoveTaskResponse, error) {
	out := new(RemoveTaskResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/RemoveTask", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *taskServiceClient) ListPersistTasks(ctx context.Context, in *ListPersistTasksRequest, opts ...grpc.CallOption) (*ListPersistTasksResponse, error) {
	out := new(ListPersistTasksResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/ListPersistTasks", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *taskServiceClient) CreatePersistTask(ctx context.Context, in *CreatePersistTaskRequest, opts ...grpc.CallOption) (*CreatePersistTaskResponse, error) {
	out := new(CreatePersistTaskResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/CreatePersistTask", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *taskServiceClient) UpdatePersistTask(ctx context.Context, in *UpdatePersistTaskRequest, opts ...grpc.CallOption) (*UpdatePersistTaskResponse, error) {
	out := new(UpdatePersistTaskResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/UpdatePersistTask", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *taskServiceClient) DeletePersistTask(ctx context.Context, in *DeletePersistTaskRequest, opts ...grpc.CallOption) (*DeletePersistTaskResponse, error) {
	out := new(DeletePersistTaskResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/DeletePersistTask", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *taskServiceClient) TestPersistTask(ctx context.Context, in *TestPersistTaskRequest, opts ...grpc.CallOption) (*TestPersistTaskResponse, error) {
	out := new(TestPersistTaskResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/TestPersistTask", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (c *taskServiceClient) ExecutePersistTask(ctx context.Context, in *ExecutePersistTaskRequest, opts ...grpc.CallOption) (*ExecutePersistTaskResponse, error) {
	out := new(ExecutePersistTaskResponse)
	err := c.cc.Invoke(ctx, "/api.task.TaskService/ExecutePersistTask", in, out, opts...)
	if err != nil {
		return nil, err
	}
	return out, nil
}

// TaskServiceServer is the server API for TaskService service.
// All implementations must embed UnimplementedTaskServiceServer
// for forward compatibility
type TaskServiceServer interface {
	ListTasks(context.Context, *ListTasksRequest) (*ListTasksResponse, error)
	RetryTask(context.Context, *RetryTaskRequest) (*RetryTaskResponse, error)
	CancelTask(context.Context, *CancelTaskRequest) (*CancelTaskResponse, error)
	RemoveTask(context.Context, *RemoveTaskRequest) (*RemoveTaskResponse, error)
	ListPersistTasks(context.Context, *ListPersistTasksRequest) (*ListPersistTasksResponse, error)
	CreatePersistTask(context.Context, *CreatePersistTaskRequest) (*CreatePersistTaskResponse, error)
	UpdatePersistTask(context.Context, *UpdatePersistTaskRequest) (*UpdatePersistTaskResponse, error)
	DeletePersistTask(context.Context, *DeletePersistTaskRequest) (*DeletePersistTaskResponse, error)
	TestPersistTask(context.Context, *TestPersistTaskRequest) (*TestPersistTaskResponse, error)
	ExecutePersistTask(context.Context, *ExecutePersistTaskRequest) (*ExecutePersistTaskResponse, error)
	mustEmbedUnimplementedTaskServiceServer()
}

// UnimplementedTaskServiceServer must be embedded to have forward compatible implementations.
type UnimplementedTaskServiceServer struct {
}

func (UnimplementedTaskServiceServer) ListTasks(context.Context, *ListTasksRequest) (*ListTasksResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method ListTasks not implemented")
}
func (UnimplementedTaskServiceServer) RetryTask(context.Context, *RetryTaskRequest) (*RetryTaskResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method RetryTask not implemented")
}
func (UnimplementedTaskServiceServer) CancelTask(context.Context, *CancelTaskRequest) (*CancelTaskResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method CancelTask not implemented")
}
func (UnimplementedTaskServiceServer) RemoveTask(context.Context, *RemoveTaskRequest) (*RemoveTaskResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method RemoveTask not implemented")
}
func (UnimplementedTaskServiceServer) ListPersistTasks(context.Context, *ListPersistTasksRequest) (*ListPersistTasksResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method ListPersistTasks not implemented")
}
func (UnimplementedTaskServiceServer) CreatePersistTask(context.Context, *CreatePersistTaskRequest) (*CreatePersistTaskResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method CreatePersistTask not implemented")
}
func (UnimplementedTaskServiceServer) UpdatePersistTask(context.Context, *UpdatePersistTaskRequest) (*UpdatePersistTaskResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method UpdatePersistTask not implemented")
}
func (UnimplementedTaskServiceServer) DeletePersistTask(context.Context, *DeletePersistTaskRequest) (*DeletePersistTaskResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method DeletePersistTask not implemented")
}
func (UnimplementedTaskServiceServer) TestPersistTask(context.Context, *TestPersistTaskRequest) (*TestPersistTaskResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method TestPersistTask not implemented")
}
func (UnimplementedTaskServiceServer) ExecutePersistTask(context.Context, *ExecutePersistTaskRequest) (*ExecutePersistTaskResponse, error) {
	return nil, status.Errorf(codes.Unimplemented, "method ExecutePersistTask not implemented")
}
func (UnimplementedTaskServiceServer) mustEmbedUnimplementedTaskServiceServer() {}

// UnsafeTaskServiceServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to TaskServiceServer will
// result in compilation errors.
type UnsafeTaskServiceServer interface {
	mustEmbedUnimplementedTaskServiceServer()
}

func RegisterTaskServiceServer(s grpc.ServiceRegistrar, srv TaskServiceServer) {
	s.RegisterService(&TaskService_ServiceDesc, srv)
}

func _TaskService_ListTasks_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(ListTasksRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).ListTasks(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/ListTasks",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).ListTasks(ctx, req.(*ListTasksRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _TaskService_RetryTask_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(RetryTaskRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).RetryTask(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/RetryTask",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).RetryTask(ctx, req.(*RetryTaskRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _TaskService_CancelTask_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(CancelTaskRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).CancelTask(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/CancelTask",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).CancelTask(ctx, req.(*CancelTaskRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _TaskService_RemoveTask_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(RemoveTaskRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).RemoveTask(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/RemoveTask",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).RemoveTask(ctx, req.(*RemoveTaskRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _TaskService_ListPersistTasks_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(ListPersistTasksRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).ListPersistTasks(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/ListPersistTasks",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).ListPersistTasks(ctx, req.(*ListPersistTasksRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _TaskService_CreatePersistTask_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(CreatePersistTaskRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).CreatePersistTask(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/CreatePersistTask",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).CreatePersistTask(ctx, req.(*CreatePersistTaskRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _TaskService_UpdatePersistTask_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(UpdatePersistTaskRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).UpdatePersistTask(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/UpdatePersistTask",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).UpdatePersistTask(ctx, req.(*UpdatePersistTaskRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _TaskService_DeletePersistTask_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(DeletePersistTaskRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).DeletePersistTask(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/DeletePersistTask",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).DeletePersistTask(ctx, req.(*DeletePersistTaskRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _TaskService_TestPersistTask_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(TestPersistTaskRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).TestPersistTask(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/TestPersistTask",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).TestPersistTask(ctx, req.(*TestPersistTaskRequest))
	}
	return interceptor(ctx, in, info, handler)
}

func _TaskService_ExecutePersistTask_Handler(srv interface{}, ctx context.Context, dec func(interface{}) error, interceptor grpc.UnaryServerInterceptor) (interface{}, error) {
	in := new(ExecutePersistTaskRequest)
	if err := dec(in); err != nil {
		return nil, err
	}
	if interceptor == nil {
		return srv.(TaskServiceServer).ExecutePersistTask(ctx, in)
	}
	info := &grpc.UnaryServerInfo{
		Server:     srv,
		FullMethod: "/api.task.TaskService/ExecutePersistTask",
	}
	handler := func(ctx context.Context, req interface{}) (interface{}, error) {
		return srv.(TaskServiceServer).ExecutePersistTask(ctx, req.(*ExecutePersistTaskRequest))
	}
	return interceptor(ctx, in, info, handler)
}

// TaskService_ServiceDesc is the grpc.ServiceDesc for TaskService service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var TaskService_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "api.task.TaskService",
	HandlerType: (*TaskServiceServer)(nil),
	Methods: []grpc.MethodDesc{
		{
			MethodName: "ListTasks",
			Handler:    _TaskService_ListTasks_Handler,
		},
		{
			MethodName: "RetryTask",
			Handler:    _TaskService_RetryTask_Handler,
		},
		{
			MethodName: "CancelTask",
			Handler:    _TaskService_CancelTask_Handler,
		},
		{
			MethodName: "RemoveTask",
			Handler:    _TaskService_RemoveTask_Handler,
		},
		{
			MethodName: "ListPersistTasks",
			Handler:    _TaskService_ListPersistTasks_Handler,
		},
		{
			MethodName: "CreatePersistTask",
			Handler:    _TaskService_CreatePersistTask_Handler,
		},
		{
			MethodName: "UpdatePersistTask",
			Handler:    _TaskService_UpdatePersistTask_Handler,
		},
		{
			MethodName: "DeletePersistTask",
			Handler:    _TaskService_DeletePersistTask_Handler,
		},
		{
			MethodName: "TestPersistTask",
			Handler:    _TaskService_TestPersistTask_Handler,
		},
		{
			MethodName: "ExecutePersistTask",
			Handler:    _TaskService_ExecutePersistTask_Handler,
		},
	},
	Streams:  []grpc.StreamDesc{},
	Metadata: "api/task/service.proto",
}

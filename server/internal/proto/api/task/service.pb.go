// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.28.1
// 	protoc        (unknown)
// source: api/task/service.proto

package task

import (
	_ "google.golang.org/genproto/googleapis/api/annotations"
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

var File_api_task_service_proto protoreflect.FileDescriptor

var file_api_task_service_proto_rawDesc = []byte{
	0x0a, 0x16, 0x61, 0x70, 0x69, 0x2f, 0x74, 0x61, 0x73, 0x6b, 0x2f, 0x73, 0x65, 0x72, 0x76, 0x69,
	0x63, 0x65, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x08, 0x61, 0x70, 0x69, 0x2e, 0x74, 0x61,
	0x73, 0x6b, 0x1a, 0x1c, 0x67, 0x6f, 0x6f, 0x67, 0x6c, 0x65, 0x2f, 0x61, 0x70, 0x69, 0x2f, 0x61,
	0x6e, 0x6e, 0x6f, 0x74, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x73, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f,
	0x1a, 0x13, 0x61, 0x70, 0x69, 0x2f, 0x74, 0x61, 0x73, 0x6b, 0x2f, 0x74, 0x61, 0x73, 0x6b, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x32, 0x9a, 0x03, 0x0a, 0x0b, 0x54, 0x61, 0x73, 0x6b, 0x53, 0x65,
	0x72, 0x76, 0x69, 0x63, 0x65, 0x12, 0x5f, 0x0a, 0x09, 0x4c, 0x69, 0x73, 0x74, 0x54, 0x61, 0x73,
	0x6b, 0x73, 0x12, 0x1a, 0x2e, 0x61, 0x70, 0x69, 0x2e, 0x74, 0x61, 0x73, 0x6b, 0x2e, 0x4c, 0x69,
	0x73, 0x74, 0x54, 0x61, 0x73, 0x6b, 0x73, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x1b,
	0x2e, 0x61, 0x70, 0x69, 0x2e, 0x74, 0x61, 0x73, 0x6b, 0x2e, 0x4c, 0x69, 0x73, 0x74, 0x54, 0x61,
	0x73, 0x6b, 0x73, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x19, 0x82, 0xd3, 0xe4,
	0x93, 0x02, 0x13, 0x3a, 0x01, 0x2a, 0x22, 0x0e, 0x2f, 0x61, 0x70, 0x69, 0x2f, 0x74, 0x61, 0x73,
	0x6b, 0x2f, 0x6c, 0x69, 0x73, 0x74, 0x12, 0x60, 0x0a, 0x09, 0x52, 0x65, 0x74, 0x72, 0x79, 0x54,
	0x61, 0x73, 0x6b, 0x12, 0x1a, 0x2e, 0x61, 0x70, 0x69, 0x2e, 0x74, 0x61, 0x73, 0x6b, 0x2e, 0x52,
	0x65, 0x74, 0x72, 0x79, 0x54, 0x61, 0x73, 0x6b, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a,
	0x1b, 0x2e, 0x61, 0x70, 0x69, 0x2e, 0x74, 0x61, 0x73, 0x6b, 0x2e, 0x52, 0x65, 0x74, 0x72, 0x79,
	0x54, 0x61, 0x73, 0x6b, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x1a, 0x82, 0xd3,
	0xe4, 0x93, 0x02, 0x14, 0x3a, 0x01, 0x2a, 0x22, 0x0f, 0x2f, 0x61, 0x70, 0x69, 0x2f, 0x74, 0x61,
	0x73, 0x6b, 0x2f, 0x72, 0x65, 0x74, 0x72, 0x79, 0x12, 0x64, 0x0a, 0x0a, 0x43, 0x61, 0x6e, 0x63,
	0x65, 0x6c, 0x54, 0x61, 0x73, 0x6b, 0x12, 0x1b, 0x2e, 0x61, 0x70, 0x69, 0x2e, 0x74, 0x61, 0x73,
	0x6b, 0x2e, 0x43, 0x61, 0x6e, 0x63, 0x65, 0x6c, 0x54, 0x61, 0x73, 0x6b, 0x52, 0x65, 0x71, 0x75,
	0x65, 0x73, 0x74, 0x1a, 0x1c, 0x2e, 0x61, 0x70, 0x69, 0x2e, 0x74, 0x61, 0x73, 0x6b, 0x2e, 0x43,
	0x61, 0x6e, 0x63, 0x65, 0x6c, 0x54, 0x61, 0x73, 0x6b, 0x52, 0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73,
	0x65, 0x22, 0x1b, 0x82, 0xd3, 0xe4, 0x93, 0x02, 0x15, 0x3a, 0x01, 0x2a, 0x22, 0x10, 0x2f, 0x61,
	0x70, 0x69, 0x2f, 0x74, 0x61, 0x73, 0x6b, 0x2f, 0x63, 0x61, 0x6e, 0x63, 0x65, 0x6c, 0x12, 0x62,
	0x0a, 0x0a, 0x52, 0x65, 0x6d, 0x6f, 0x76, 0x65, 0x54, 0x61, 0x73, 0x6b, 0x12, 0x1b, 0x2e, 0x61,
	0x70, 0x69, 0x2e, 0x74, 0x61, 0x73, 0x6b, 0x2e, 0x52, 0x65, 0x6d, 0x6f, 0x76, 0x65, 0x54, 0x61,
	0x73, 0x6b, 0x52, 0x65, 0x71, 0x75, 0x65, 0x73, 0x74, 0x1a, 0x1c, 0x2e, 0x61, 0x70, 0x69, 0x2e,
	0x74, 0x61, 0x73, 0x6b, 0x2e, 0x52, 0x65, 0x6d, 0x6f, 0x76, 0x65, 0x54, 0x61, 0x73, 0x6b, 0x52,
	0x65, 0x73, 0x70, 0x6f, 0x6e, 0x73, 0x65, 0x22, 0x19, 0x82, 0xd3, 0xe4, 0x93, 0x02, 0x13, 0x3a,
	0x01, 0x2a, 0x22, 0x0e, 0x2f, 0x61, 0x70, 0x69, 0x2f, 0x74, 0x61, 0x73, 0x6b, 0x2f, 0x6d, 0x6f,
	0x76, 0x65, 0x42, 0x9c, 0x01, 0x0a, 0x0c, 0x63, 0x6f, 0x6d, 0x2e, 0x61, 0x70, 0x69, 0x2e, 0x74,
	0x61, 0x73, 0x6b, 0x42, 0x0c, 0x53, 0x65, 0x72, 0x76, 0x69, 0x63, 0x65, 0x50, 0x72, 0x6f, 0x74,
	0x6f, 0x50, 0x01, 0x5a, 0x3d, 0x67, 0x69, 0x74, 0x68, 0x75, 0x62, 0x2e, 0x63, 0x6f, 0x6d, 0x2f,
	0x68, 0x6f, 0x6e, 0x6d, 0x61, 0x70, 0x6c, 0x65, 0x2f, 0x6d, 0x61, 0x70, 0x6c, 0x65, 0x2d, 0x66,
	0x69, 0x6c, 0x65, 0x2f, 0x73, 0x65, 0x72, 0x76, 0x65, 0x72, 0x2f, 0x69, 0x6e, 0x74, 0x65, 0x72,
	0x6e, 0x61, 0x6c, 0x2f, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x2f, 0x61, 0x70, 0x69, 0x2f, 0x74, 0x61,
	0x73, 0x6b, 0xa2, 0x02, 0x03, 0x41, 0x54, 0x58, 0xaa, 0x02, 0x08, 0x41, 0x70, 0x69, 0x2e, 0x54,
	0x61, 0x73, 0x6b, 0xca, 0x02, 0x08, 0x41, 0x70, 0x69, 0x5c, 0x54, 0x61, 0x73, 0x6b, 0xe2, 0x02,
	0x14, 0x41, 0x70, 0x69, 0x5c, 0x54, 0x61, 0x73, 0x6b, 0x5c, 0x47, 0x50, 0x42, 0x4d, 0x65, 0x74,
	0x61, 0x64, 0x61, 0x74, 0x61, 0xea, 0x02, 0x09, 0x41, 0x70, 0x69, 0x3a, 0x3a, 0x54, 0x61, 0x73,
	0x6b, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33,
}

var file_api_task_service_proto_goTypes = []interface{}{
	(*ListTasksRequest)(nil),   // 0: api.task.ListTasksRequest
	(*RetryTaskRequest)(nil),   // 1: api.task.RetryTaskRequest
	(*CancelTaskRequest)(nil),  // 2: api.task.CancelTaskRequest
	(*RemoveTaskRequest)(nil),  // 3: api.task.RemoveTaskRequest
	(*ListTasksResponse)(nil),  // 4: api.task.ListTasksResponse
	(*RetryTaskResponse)(nil),  // 5: api.task.RetryTaskResponse
	(*CancelTaskResponse)(nil), // 6: api.task.CancelTaskResponse
	(*RemoveTaskResponse)(nil), // 7: api.task.RemoveTaskResponse
}
var file_api_task_service_proto_depIdxs = []int32{
	0, // 0: api.task.TaskService.ListTasks:input_type -> api.task.ListTasksRequest
	1, // 1: api.task.TaskService.RetryTask:input_type -> api.task.RetryTaskRequest
	2, // 2: api.task.TaskService.CancelTask:input_type -> api.task.CancelTaskRequest
	3, // 3: api.task.TaskService.RemoveTask:input_type -> api.task.RemoveTaskRequest
	4, // 4: api.task.TaskService.ListTasks:output_type -> api.task.ListTasksResponse
	5, // 5: api.task.TaskService.RetryTask:output_type -> api.task.RetryTaskResponse
	6, // 6: api.task.TaskService.CancelTask:output_type -> api.task.CancelTaskResponse
	7, // 7: api.task.TaskService.RemoveTask:output_type -> api.task.RemoveTaskResponse
	4, // [4:8] is the sub-list for method output_type
	0, // [0:4] is the sub-list for method input_type
	0, // [0:0] is the sub-list for extension type_name
	0, // [0:0] is the sub-list for extension extendee
	0, // [0:0] is the sub-list for field type_name
}

func init() { file_api_task_service_proto_init() }
func file_api_task_service_proto_init() {
	if File_api_task_service_proto != nil {
		return
	}
	file_api_task_task_proto_init()
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_api_task_service_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   0,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_api_task_service_proto_goTypes,
		DependencyIndexes: file_api_task_service_proto_depIdxs,
	}.Build()
	File_api_task_service_proto = out.File
	file_api_task_service_proto_rawDesc = nil
	file_api_task_service_proto_goTypes = nil
	file_api_task_service_proto_depIdxs = nil
}
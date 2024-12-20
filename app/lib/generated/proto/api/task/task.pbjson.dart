//
//  Generated code. Do not modify.
//  source: api/task/task.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use taskStateDescriptor instead')
const TaskState$json = {
  '1': 'TaskState',
  '2': [
    {'1': 'TASK_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TASK_STATE_PENDING', '2': 0},
    {'1': 'TASK_STATE_RUNNING', '2': 1},
    {'1': 'TASK_STATE_SUCCEEDED', '2': 2},
    {'1': 'TASK_STATE_CANCELING', '2': 3},
    {'1': 'TASK_STATE_CANCELED', '2': 4},
    {'1': 'TASK_STATE_FAILED', '2': 5},
  ],
  '3': {'2': true},
};

/// Descriptor for `TaskState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskStateDescriptor = $convert.base64Decode(
    'CglUYXNrU3RhdGUSGgoWVEFTS19TVEFURV9VTlNQRUNJRklFRBAAEhYKElRBU0tfU1RBVEVfUE'
    'VORElORxAAEhYKElRBU0tfU1RBVEVfUlVOTklORxABEhgKFFRBU0tfU1RBVEVfU1VDQ0VFREVE'
    'EAISGAoUVEFTS19TVEFURV9DQU5DRUxJTkcQAxIXChNUQVNLX1NUQVRFX0NBTkNFTEVEEAQSFQ'
    'oRVEFTS19TVEFURV9GQUlMRUQQBRoCEAE=');

@$core.Deprecated('Use taskDescriptor instead')
const Task$json = {
  '1': 'Task',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'start_time', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'startTime'},
    {'1': 'end_time', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'endTime'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'state', '3': 5, '4': 1, '5': 14, '6': '.api.task.TaskState', '10': 'state'},
    {'1': 'progress', '3': 6, '4': 1, '5': 1, '10': 'progress'},
    {'1': 'progress_state', '3': 7, '4': 1, '5': 9, '10': 'progressState'},
    {'1': 'log', '3': 8, '4': 1, '5': 9, '10': 'log'},
    {'1': 'err', '3': 9, '4': 1, '5': 9, '10': 'err'},
  ],
};

/// Descriptor for `Task`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskDescriptor = $convert.base64Decode(
    'CgRUYXNrEg4KAmlkGAEgASgJUgJpZBI5CgpzdGFydF90aW1lGAIgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJc3RhcnRUaW1lEjUKCGVuZF90aW1lGAMgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIHZW5kVGltZRISCgRuYW1lGAQgASgJUgRuYW1lEikKBXN0YXRlGA'
    'UgASgOMhMuYXBpLnRhc2suVGFza1N0YXRlUgVzdGF0ZRIaCghwcm9ncmVzcxgGIAEoAVIIcHJv'
    'Z3Jlc3MSJQoOcHJvZ3Jlc3Nfc3RhdGUYByABKAlSDXByb2dyZXNzU3RhdGUSEAoDbG9nGAggAS'
    'gJUgNsb2cSEAoDZXJyGAkgASgJUgNlcnI=');

@$core.Deprecated('Use listTasksRequestDescriptor instead')
const ListTasksRequest$json = {
  '1': 'ListTasksRequest',
  '2': [
    {'1': 'filter', '3': 1, '4': 3, '5': 11, '6': '.api.task.ListTasksRequest.FilterEntry', '10': 'filter'},
  ],
  '3': [ListTasksRequest_FilterEntry$json],
};

@$core.Deprecated('Use listTasksRequestDescriptor instead')
const ListTasksRequest_FilterEntry$json = {
  '1': 'FilterEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ListTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTasksRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VGFza3NSZXF1ZXN0Ej4KBmZpbHRlchgBIAMoCzImLmFwaS50YXNrLkxpc3RUYXNrc1'
    'JlcXVlc3QuRmlsdGVyRW50cnlSBmZpbHRlcho5CgtGaWx0ZXJFbnRyeRIQCgNrZXkYASABKAlS'
    'A2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use listTasksResponseDescriptor instead')
const ListTasksResponse$json = {
  '1': 'ListTasksResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.task.Task', '10': 'results'},
  ],
};

/// Descriptor for `ListTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTasksResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VGFza3NSZXNwb25zZRIoCgdyZXN1bHRzGAEgAygLMg4uYXBpLnRhc2suVGFza1IHcm'
    'VzdWx0cw==');

@$core.Deprecated('Use retryTaskRequestDescriptor instead')
const RetryTaskRequest$json = {
  '1': 'RetryTaskRequest',
  '2': [
    {'1': 'tasks', '3': 1, '4': 3, '5': 9, '10': 'tasks'},
  ],
};

/// Descriptor for `RetryTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryTaskRequestDescriptor = $convert.base64Decode(
    'ChBSZXRyeVRhc2tSZXF1ZXN0EhQKBXRhc2tzGAEgAygJUgV0YXNrcw==');

@$core.Deprecated('Use retryTaskResponseDescriptor instead')
const RetryTaskResponse$json = {
  '1': 'RetryTaskResponse',
};

/// Descriptor for `RetryTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retryTaskResponseDescriptor = $convert.base64Decode(
    'ChFSZXRyeVRhc2tSZXNwb25zZQ==');

@$core.Deprecated('Use cancelTaskRequestDescriptor instead')
const CancelTaskRequest$json = {
  '1': 'CancelTaskRequest',
  '2': [
    {'1': 'tasks', '3': 1, '4': 3, '5': 9, '10': 'tasks'},
  ],
};

/// Descriptor for `CancelTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelTaskRequestDescriptor = $convert.base64Decode(
    'ChFDYW5jZWxUYXNrUmVxdWVzdBIUCgV0YXNrcxgBIAMoCVIFdGFza3M=');

@$core.Deprecated('Use cancelTaskResponseDescriptor instead')
const CancelTaskResponse$json = {
  '1': 'CancelTaskResponse',
};

/// Descriptor for `CancelTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelTaskResponseDescriptor = $convert.base64Decode(
    'ChJDYW5jZWxUYXNrUmVzcG9uc2U=');

@$core.Deprecated('Use removeTaskRequestDescriptor instead')
const RemoveTaskRequest$json = {
  '1': 'RemoveTaskRequest',
  '2': [
    {'1': 'tasks', '3': 1, '4': 3, '5': 9, '10': 'tasks'},
  ],
};

/// Descriptor for `RemoveTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeTaskRequestDescriptor = $convert.base64Decode(
    'ChFSZW1vdmVUYXNrUmVxdWVzdBIUCgV0YXNrcxgBIAMoCVIFdGFza3M=');

@$core.Deprecated('Use removeTaskResponseDescriptor instead')
const RemoveTaskResponse$json = {
  '1': 'RemoveTaskResponse',
};

/// Descriptor for `RemoveTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeTaskResponseDescriptor = $convert.base64Decode(
    'ChJSZW1vdmVUYXNrUmVzcG9uc2U=');


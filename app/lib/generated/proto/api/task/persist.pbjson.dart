//
//  Generated code. Do not modify.
//  source: api/task/persist.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use persistTaskDescriptor instead')
const PersistTask$json = {
  '1': 'PersistTask',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'status', '3': 5, '4': 1, '5': 8, '10': 'status'},
    {'1': 'type', '3': 6, '4': 1, '5': 9, '10': 'type'},
    {'1': 'option', '3': 7, '4': 1, '5': 9, '10': 'option'},
    {'1': 'cron_option', '3': 8, '4': 1, '5': 9, '10': 'cronOption'},
  ],
};

/// Descriptor for `PersistTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List persistTaskDescriptor = $convert.base64Decode(
    'CgtQZXJzaXN0VGFzaxIOCgJpZBgBIAEoBVICaWQSOQoKY3JlYXRlZF9hdBgCIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAMgASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EhIKBG5hbWUYBCABKAlSBG5hbW'
    'USFgoGc3RhdHVzGAUgASgIUgZzdGF0dXMSEgoEdHlwZRgGIAEoCVIEdHlwZRIWCgZvcHRpb24Y'
    'ByABKAlSBm9wdGlvbhIfCgtjcm9uX29wdGlvbhgIIAEoCVIKY3Jvbk9wdGlvbg==');

@$core.Deprecated('Use listPersistTasksRequestDescriptor instead')
const ListPersistTasksRequest$json = {
  '1': 'ListPersistTasksRequest',
  '2': [
    {'1': 'filter', '3': 1, '4': 3, '5': 11, '6': '.api.task.ListPersistTasksRequest.FilterEntry', '10': 'filter'},
  ],
  '3': [ListPersistTasksRequest_FilterEntry$json],
};

@$core.Deprecated('Use listPersistTasksRequestDescriptor instead')
const ListPersistTasksRequest_FilterEntry$json = {
  '1': 'FilterEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ListPersistTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPersistTasksRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0UGVyc2lzdFRhc2tzUmVxdWVzdBJFCgZmaWx0ZXIYASADKAsyLS5hcGkudGFzay5MaX'
    'N0UGVyc2lzdFRhc2tzUmVxdWVzdC5GaWx0ZXJFbnRyeVIGZmlsdGVyGjkKC0ZpbHRlckVudHJ5'
    'EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use listPersistTasksResponseDescriptor instead')
const ListPersistTasksResponse$json = {
  '1': 'ListPersistTasksResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.task.PersistTask', '10': 'results'},
  ],
};

/// Descriptor for `ListPersistTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPersistTasksResponseDescriptor = $convert.base64Decode(
    'ChhMaXN0UGVyc2lzdFRhc2tzUmVzcG9uc2USLwoHcmVzdWx0cxgBIAMoCzIVLmFwaS50YXNrLl'
    'BlcnNpc3RUYXNrUgdyZXN1bHRz');

@$core.Deprecated('Use createPersistTaskRequestDescriptor instead')
const CreatePersistTaskRequest$json = {
  '1': 'CreatePersistTaskRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.task.PersistTask', '10': 'payload'},
  ],
};

/// Descriptor for `CreatePersistTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPersistTaskRequestDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVQZXJzaXN0VGFza1JlcXVlc3QSLwoHcGF5bG9hZBgBIAEoCzIVLmFwaS50YXNrLl'
    'BlcnNpc3RUYXNrUgdwYXlsb2Fk');

@$core.Deprecated('Use createPersistTaskResponseDescriptor instead')
const CreatePersistTaskResponse$json = {
  '1': 'CreatePersistTaskResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.task.PersistTask', '10': 'result'},
  ],
};

/// Descriptor for `CreatePersistTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPersistTaskResponseDescriptor = $convert.base64Decode(
    'ChlDcmVhdGVQZXJzaXN0VGFza1Jlc3BvbnNlEi0KBnJlc3VsdBgBIAEoCzIVLmFwaS50YXNrLl'
    'BlcnNpc3RUYXNrUgZyZXN1bHQ=');

@$core.Deprecated('Use updatePersistTaskRequestDescriptor instead')
const UpdatePersistTaskRequest$json = {
  '1': 'UpdatePersistTaskRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.task.PersistTask', '10': 'payload'},
  ],
};

/// Descriptor for `UpdatePersistTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePersistTaskRequestDescriptor = $convert.base64Decode(
    'ChhVcGRhdGVQZXJzaXN0VGFza1JlcXVlc3QSLwoHcGF5bG9hZBgBIAEoCzIVLmFwaS50YXNrLl'
    'BlcnNpc3RUYXNrUgdwYXlsb2Fk');

@$core.Deprecated('Use updatePersistTaskResponseDescriptor instead')
const UpdatePersistTaskResponse$json = {
  '1': 'UpdatePersistTaskResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.task.PersistTask', '10': 'result'},
  ],
};

/// Descriptor for `UpdatePersistTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updatePersistTaskResponseDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVQZXJzaXN0VGFza1Jlc3BvbnNlEi0KBnJlc3VsdBgBIAEoCzIVLmFwaS50YXNrLl'
    'BlcnNpc3RUYXNrUgZyZXN1bHQ=');

@$core.Deprecated('Use deletePersistTaskRequestDescriptor instead')
const DeletePersistTaskRequest$json = {
  '1': 'DeletePersistTaskRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `DeletePersistTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePersistTaskRequestDescriptor = $convert.base64Decode(
    'ChhEZWxldGVQZXJzaXN0VGFza1JlcXVlc3QSDgoCaWQYASABKAVSAmlk');

@$core.Deprecated('Use deletePersistTaskResponseDescriptor instead')
const DeletePersistTaskResponse$json = {
  '1': 'DeletePersistTaskResponse',
};

/// Descriptor for `DeletePersistTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePersistTaskResponseDescriptor = $convert.base64Decode(
    'ChlEZWxldGVQZXJzaXN0VGFza1Jlc3BvbnNl');

@$core.Deprecated('Use executePersistTaskRequestDescriptor instead')
const ExecutePersistTaskRequest$json = {
  '1': 'ExecutePersistTaskRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `ExecutePersistTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executePersistTaskRequestDescriptor = $convert.base64Decode(
    'ChlFeGVjdXRlUGVyc2lzdFRhc2tSZXF1ZXN0Eg4KAmlkGAEgASgFUgJpZA==');

@$core.Deprecated('Use executePersistTaskResponseDescriptor instead')
const ExecutePersistTaskResponse$json = {
  '1': 'ExecutePersistTaskResponse',
};

/// Descriptor for `ExecutePersistTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executePersistTaskResponseDescriptor = $convert.base64Decode(
    'ChpFeGVjdXRlUGVyc2lzdFRhc2tSZXNwb25zZQ==');


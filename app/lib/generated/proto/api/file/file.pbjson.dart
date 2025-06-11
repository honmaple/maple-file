//
//  Generated code. Do not modify.
//  source: api/file/file.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use fileDescriptor instead')
const File$json = {
  '1': 'File',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 5, '4': 1, '5': 9, '10': 'type'},
    {'1': 'size', '3': 6, '4': 1, '5': 3, '10': 'size'},
    {'1': 'hash', '3': 7, '4': 1, '5': 9, '10': 'hash'},
    {'1': 'path', '3': 8, '4': 1, '5': 9, '10': 'path'},
    {'1': 'repo', '3': 10, '4': 1, '5': 11, '6': '.api.file.Repo', '10': 'repo'},
    {'1': 'repo_id', '3': 11, '4': 1, '5': 5, '10': 'repoId'},
  ],
};

/// Descriptor for `File`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileDescriptor = $convert.base64Decode(
    'CgRGaWxlEg4KAmlkGAEgASgFUgJpZBI5CgpjcmVhdGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYAyABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSEgoEbmFtZRgEIAEoCVIEbmFtZRISCgR0eX'
    'BlGAUgASgJUgR0eXBlEhIKBHNpemUYBiABKANSBHNpemUSEgoEaGFzaBgHIAEoCVIEaGFzaBIS'
    'CgRwYXRoGAggASgJUgRwYXRoEiIKBHJlcG8YCiABKAsyDi5hcGkuZmlsZS5SZXBvUgRyZXBvEh'
    'cKB3JlcG9faWQYCyABKAVSBnJlcG9JZA==');

@$core.Deprecated('Use fileRequestDescriptor instead')
const FileRequest$json = {
  '1': 'FileRequest',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 5, '10': 'index'},
    {'1': 'size', '3': 5, '4': 1, '5': 3, '10': 'size'},
    {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    {'1': 'filename', '3': 4, '4': 1, '5': 9, '10': 'filename'},
    {'1': 'chunk', '3': 2, '4': 1, '5': 12, '10': 'chunk'},
  ],
};

/// Descriptor for `FileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileRequestDescriptor = $convert.base64Decode(
    'CgtGaWxlUmVxdWVzdBIUCgVpbmRleBgBIAEoBVIFaW5kZXgSEgoEc2l6ZRgFIAEoA1IEc2l6ZR'
    'ISCgRwYXRoGAMgASgJUgRwYXRoEhoKCGZpbGVuYW1lGAQgASgJUghmaWxlbmFtZRIUCgVjaHVu'
    'axgCIAEoDFIFY2h1bms=');

@$core.Deprecated('Use fileResponseDescriptor instead')
const FileResponse$json = {
  '1': 'FileResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.file.File', '10': 'result'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `FileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileResponseDescriptor = $convert.base64Decode(
    'CgxGaWxlUmVzcG9uc2USJgoGcmVzdWx0GAEgASgLMg4uYXBpLmZpbGUuRmlsZVIGcmVzdWx0Eh'
    'gKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use listFilesRequestDescriptor instead')
const ListFilesRequest$json = {
  '1': 'ListFilesRequest',
  '2': [
    {'1': 'filter', '3': 1, '4': 3, '5': 11, '6': '.api.file.ListFilesRequest.FilterEntry', '10': 'filter'},
  ],
  '3': [ListFilesRequest_FilterEntry$json],
};

@$core.Deprecated('Use listFilesRequestDescriptor instead')
const ListFilesRequest_FilterEntry$json = {
  '1': 'FilterEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ListFilesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFilesRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0RmlsZXNSZXF1ZXN0Ej4KBmZpbHRlchgBIAMoCzImLmFwaS5maWxlLkxpc3RGaWxlc1'
    'JlcXVlc3QuRmlsdGVyRW50cnlSBmZpbHRlcho5CgtGaWx0ZXJFbnRyeRIQCgNrZXkYASABKAlS'
    'A2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use listFilesResponseDescriptor instead')
const ListFilesResponse$json = {
  '1': 'ListFilesResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.file.File', '10': 'results'},
  ],
};

/// Descriptor for `ListFilesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFilesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0RmlsZXNSZXNwb25zZRIoCgdyZXN1bHRzGAEgAygLMg4uYXBpLmZpbGUuRmlsZVIHcm'
    'VzdWx0cw==');

@$core.Deprecated('Use moveFileRequestDescriptor instead')
const MoveFileRequest$json = {
  '1': 'MoveFileRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'new_path', '3': 2, '4': 1, '5': 9, '10': 'newPath'},
    {'1': 'names', '3': 3, '4': 3, '5': 9, '10': 'names'},
  ],
};

/// Descriptor for `MoveFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveFileRequestDescriptor = $convert.base64Decode(
    'Cg9Nb3ZlRmlsZVJlcXVlc3QSEgoEcGF0aBgBIAEoCVIEcGF0aBIZCghuZXdfcGF0aBgCIAEoCV'
    'IHbmV3UGF0aBIUCgVuYW1lcxgDIAMoCVIFbmFtZXM=');

@$core.Deprecated('Use moveFileResponseDescriptor instead')
const MoveFileResponse$json = {
  '1': 'MoveFileResponse',
};

/// Descriptor for `MoveFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveFileResponseDescriptor = $convert.base64Decode(
    'ChBNb3ZlRmlsZVJlc3BvbnNl');

@$core.Deprecated('Use copyFileRequestDescriptor instead')
const CopyFileRequest$json = {
  '1': 'CopyFileRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'new_path', '3': 2, '4': 1, '5': 9, '10': 'newPath'},
    {'1': 'names', '3': 3, '4': 3, '5': 9, '10': 'names'},
  ],
};

/// Descriptor for `CopyFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copyFileRequestDescriptor = $convert.base64Decode(
    'Cg9Db3B5RmlsZVJlcXVlc3QSEgoEcGF0aBgBIAEoCVIEcGF0aBIZCghuZXdfcGF0aBgCIAEoCV'
    'IHbmV3UGF0aBIUCgVuYW1lcxgDIAMoCVIFbmFtZXM=');

@$core.Deprecated('Use copyFileResponseDescriptor instead')
const CopyFileResponse$json = {
  '1': 'CopyFileResponse',
};

/// Descriptor for `CopyFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List copyFileResponseDescriptor = $convert.base64Decode(
    'ChBDb3B5RmlsZVJlc3BvbnNl');

@$core.Deprecated('Use mkdirFileRequestDescriptor instead')
const MkdirFileRequest$json = {
  '1': 'MkdirFileRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `MkdirFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mkdirFileRequestDescriptor = $convert.base64Decode(
    'ChBNa2RpckZpbGVSZXF1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGgSEgoEbmFtZRgCIAEoCVIEbm'
    'FtZQ==');

@$core.Deprecated('Use mkdirFileResponseDescriptor instead')
const MkdirFileResponse$json = {
  '1': 'MkdirFileResponse',
};

/// Descriptor for `MkdirFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mkdirFileResponseDescriptor = $convert.base64Decode(
    'ChFNa2RpckZpbGVSZXNwb25zZQ==');

@$core.Deprecated('Use renameFileRequestDescriptor instead')
const RenameFileRequest$json = {
  '1': 'RenameFileRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'new_name', '3': 3, '4': 1, '5': 9, '10': 'newName'},
  ],
};

/// Descriptor for `RenameFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameFileRequestDescriptor = $convert.base64Decode(
    'ChFSZW5hbWVGaWxlUmVxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRoEhIKBG5hbWUYAiABKAlSBG'
    '5hbWUSGQoIbmV3X25hbWUYAyABKAlSB25ld05hbWU=');

@$core.Deprecated('Use renameFileResponseDescriptor instead')
const RenameFileResponse$json = {
  '1': 'RenameFileResponse',
};

/// Descriptor for `RenameFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renameFileResponseDescriptor = $convert.base64Decode(
    'ChJSZW5hbWVGaWxlUmVzcG9uc2U=');

@$core.Deprecated('Use removeFileRequestDescriptor instead')
const RemoveFileRequest$json = {
  '1': 'RemoveFileRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'names', '3': 3, '4': 3, '5': 9, '10': 'names'},
  ],
};

/// Descriptor for `RemoveFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFileRequestDescriptor = $convert.base64Decode(
    'ChFSZW1vdmVGaWxlUmVxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRoEhQKBW5hbWVzGAMgAygJUg'
    'VuYW1lcw==');

@$core.Deprecated('Use removeFileResponseDescriptor instead')
const RemoveFileResponse$json = {
  '1': 'RemoveFileResponse',
};

/// Descriptor for `RemoveFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeFileResponseDescriptor = $convert.base64Decode(
    'ChJSZW1vdmVGaWxlUmVzcG9uc2U=');

@$core.Deprecated('Use uploadFileRequestDescriptor instead')
const UploadFileRequest$json = {
  '1': 'UploadFileRequest',
};

/// Descriptor for `UploadFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadFileRequestDescriptor = $convert.base64Decode(
    'ChFVcGxvYWRGaWxlUmVxdWVzdA==');

@$core.Deprecated('Use previewFileRequestDescriptor instead')
const PreviewFileRequest$json = {
  '1': 'PreviewFileRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `PreviewFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewFileRequestDescriptor = $convert.base64Decode(
    'ChJQcmV2aWV3RmlsZVJlcXVlc3QSEgoEcGF0aBgBIAEoCVIEcGF0aA==');

@$core.Deprecated('Use previewFileResponseDescriptor instead')
const PreviewFileResponse$json = {
  '1': 'PreviewFileResponse',
  '2': [
    {'1': 'chunk', '3': 1, '4': 1, '5': 12, '10': 'chunk'},
  ],
};

/// Descriptor for `PreviewFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List previewFileResponseDescriptor = $convert.base64Decode(
    'ChNQcmV2aWV3RmlsZVJlc3BvbnNlEhQKBWNodW5rGAEgASgMUgVjaHVuaw==');

@$core.Deprecated('Use downloadFileRequestDescriptor instead')
const DownloadFileRequest$json = {
  '1': 'DownloadFileRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `DownloadFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadFileRequestDescriptor = $convert.base64Decode(
    'ChNEb3dubG9hZEZpbGVSZXF1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGg=');

@$core.Deprecated('Use downloadFileResponseDescriptor instead')
const DownloadFileResponse$json = {
  '1': 'DownloadFileResponse',
  '2': [
    {'1': 'chunk', '3': 1, '4': 1, '5': 12, '10': 'chunk'},
  ],
};

/// Descriptor for `DownloadFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadFileResponseDescriptor = $convert.base64Decode(
    'ChREb3dubG9hZEZpbGVSZXNwb25zZRIUCgVjaHVuaxgBIAEoDFIFY2h1bms=');


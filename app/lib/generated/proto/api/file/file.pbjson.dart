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
  '3': [File_UploadRequest$json, File_UploadResponse$json, File_ListRequest$json, File_ListResponse$json, File_MoveRequest$json, File_MoveResponse$json, File_CopyRequest$json, File_CopyResponse$json, File_MkdirRequest$json, File_MkdirResponse$json, File_RenameRequest$json, File_RenameResponse$json, File_RemoveRequest$json, File_RemoveResponse$json, File_PreviewRequest$json, File_PreviewResponse$json, File_DownloadRequest$json, File_DownloadResponse$json],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_UploadRequest$json = {
  '1': 'UploadRequest',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 5, '10': 'index'},
    {'1': 'size', '3': 5, '4': 1, '5': 3, '10': 'size'},
    {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
    {'1': 'filename', '3': 4, '4': 1, '5': 9, '10': 'filename'},
    {'1': 'chunk', '3': 2, '4': 1, '5': 12, '10': 'chunk'},
    {'1': 'preserve_filename', '3': 6, '4': 1, '5': 8, '10': 'preserveFilename'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_UploadResponse$json = {
  '1': 'UploadResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.file.File', '10': 'result'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'source_hash_algorithm', '3': 3, '4': 1, '5': 9, '10': 'sourceHashAlgorithm'},
    {'1': 'source_hash', '3': 4, '4': 1, '5': 9, '10': 'sourceHash'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'filter', '3': 1, '4': 3, '5': 11, '6': '.api.file.File.ListRequest.FilterEntry', '10': 'filter'},
  ],
  '3': [File_ListRequest_FilterEntry$json],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_ListRequest_FilterEntry$json = {
  '1': 'FilterEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use fileDescriptor instead')
const File_ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.file.File', '10': 'results'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_MoveRequest$json = {
  '1': 'MoveRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'new_path', '3': 2, '4': 1, '5': 9, '10': 'newPath'},
    {'1': 'names', '3': 3, '4': 3, '5': 9, '10': 'names'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_MoveResponse$json = {
  '1': 'MoveResponse',
};

@$core.Deprecated('Use fileDescriptor instead')
const File_CopyRequest$json = {
  '1': 'CopyRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'new_path', '3': 2, '4': 1, '5': 9, '10': 'newPath'},
    {'1': 'names', '3': 3, '4': 3, '5': 9, '10': 'names'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_CopyResponse$json = {
  '1': 'CopyResponse',
};

@$core.Deprecated('Use fileDescriptor instead')
const File_MkdirRequest$json = {
  '1': 'MkdirRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_MkdirResponse$json = {
  '1': 'MkdirResponse',
};

@$core.Deprecated('Use fileDescriptor instead')
const File_RenameRequest$json = {
  '1': 'RenameRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'new_name', '3': 3, '4': 1, '5': 9, '10': 'newName'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_RenameResponse$json = {
  '1': 'RenameResponse',
};

@$core.Deprecated('Use fileDescriptor instead')
const File_RemoveRequest$json = {
  '1': 'RemoveRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    {'1': 'names', '3': 3, '4': 3, '5': 9, '10': 'names'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_RemoveResponse$json = {
  '1': 'RemoveResponse',
};

@$core.Deprecated('Use fileDescriptor instead')
const File_PreviewRequest$json = {
  '1': 'PreviewRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_PreviewResponse$json = {
  '1': 'PreviewResponse',
  '2': [
    {'1': 'chunk', '3': 1, '4': 1, '5': 12, '10': 'chunk'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_DownloadRequest$json = {
  '1': 'DownloadRequest',
  '2': [
    {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_DownloadResponse$json = {
  '1': 'DownloadResponse',
  '2': [
    {'1': 'chunk', '3': 1, '4': 1, '5': 12, '10': 'chunk'},
  ],
};

/// Descriptor for `File`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileDescriptor = $convert.base64Decode(
    'CgRGaWxlEg4KAmlkGAEgASgFUgJpZBI5CgpjcmVhdGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYAyABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSEgoEbmFtZRgEIAEoCVIEbmFtZRISCgR0eX'
    'BlGAUgASgJUgR0eXBlEhIKBHNpemUYBiABKANSBHNpemUSEgoEaGFzaBgHIAEoCVIEaGFzaBIS'
    'CgRwYXRoGAggASgJUgRwYXRoEiIKBHJlcG8YCiABKAsyDi5hcGkuZmlsZS5SZXBvUgRyZXBvEh'
    'cKB3JlcG9faWQYCyABKAVSBnJlcG9JZBqsAQoNVXBsb2FkUmVxdWVzdBIUCgVpbmRleBgBIAEo'
    'BVIFaW5kZXgSEgoEc2l6ZRgFIAEoA1IEc2l6ZRISCgRwYXRoGAMgASgJUgRwYXRoEhoKCGZpbG'
    'VuYW1lGAQgASgJUghmaWxlbmFtZRIUCgVjaHVuaxgCIAEoDFIFY2h1bmsSKwoRcHJlc2VydmVf'
    'ZmlsZW5hbWUYBiABKAhSEHByZXNlcnZlRmlsZW5hbWUapwEKDlVwbG9hZFJlc3BvbnNlEiYKBn'
    'Jlc3VsdBgBIAEoCzIOLmFwaS5maWxlLkZpbGVSBnJlc3VsdBIYCgdtZXNzYWdlGAIgASgJUgdt'
    'ZXNzYWdlEjIKFXNvdXJjZV9oYXNoX2FsZ29yaXRobRgDIAEoCVITc291cmNlSGFzaEFsZ29yaX'
    'RobRIfCgtzb3VyY2VfaGFzaBgEIAEoCVIKc291cmNlSGFzaBqIAQoLTGlzdFJlcXVlc3QSPgoG'
    'ZmlsdGVyGAEgAygLMiYuYXBpLmZpbGUuRmlsZS5MaXN0UmVxdWVzdC5GaWx0ZXJFbnRyeVIGZm'
    'lsdGVyGjkKC0ZpbHRlckVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2'
    'YWx1ZToCOAEaOAoMTGlzdFJlc3BvbnNlEigKB3Jlc3VsdHMYASADKAsyDi5hcGkuZmlsZS5GaW'
    'xlUgdyZXN1bHRzGlIKC01vdmVSZXF1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGgSGQoIbmV3X3Bh'
    'dGgYAiABKAlSB25ld1BhdGgSFAoFbmFtZXMYAyADKAlSBW5hbWVzGg4KDE1vdmVSZXNwb25zZR'
    'pSCgtDb3B5UmVxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRoEhkKCG5ld19wYXRoGAIgASgJUgdu'
    'ZXdQYXRoEhQKBW5hbWVzGAMgAygJUgVuYW1lcxoOCgxDb3B5UmVzcG9uc2UaNgoMTWtkaXJSZX'
    'F1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGgSEgoEbmFtZRgCIAEoCVIEbmFtZRoPCg1Na2RpclJl'
    'c3BvbnNlGlIKDVJlbmFtZVJlcXVlc3QSEgoEcGF0aBgBIAEoCVIEcGF0aBISCgRuYW1lGAIgAS'
    'gJUgRuYW1lEhkKCG5ld19uYW1lGAMgASgJUgduZXdOYW1lGhAKDlJlbmFtZVJlc3BvbnNlGjkK'
    'DVJlbW92ZVJlcXVlc3QSEgoEcGF0aBgBIAEoCVIEcGF0aBIUCgVuYW1lcxgDIAMoCVIFbmFtZX'
    'MaEAoOUmVtb3ZlUmVzcG9uc2UaJAoOUHJldmlld1JlcXVlc3QSEgoEcGF0aBgBIAEoCVIEcGF0'
    'aBonCg9QcmV2aWV3UmVzcG9uc2USFAoFY2h1bmsYASABKAxSBWNodW5rGiUKD0Rvd25sb2FkUm'
    'VxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRoGigKEERvd25sb2FkUmVzcG9uc2USFAoFY2h1bmsY'
    'ASABKAxSBWNodW5r');


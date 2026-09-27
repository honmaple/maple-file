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
  '4': [File_UploadPolicy$json],
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
    {'1': 'upload_policy', '3': 6, '4': 1, '5': 14, '6': '.api.file.File.UploadPolicy', '10': 'uploadPolicy'},
  ],
};

@$core.Deprecated('Use fileDescriptor instead')
const File_UploadResponse$json = {
  '1': 'UploadResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.file.File', '10': 'result'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
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

@$core.Deprecated('Use fileDescriptor instead')
const File_UploadPolicy$json = {
  '1': 'UploadPolicy',
  '2': [
    {'1': 'UPLOAD_POLICY_INHERIT', '2': 0},
    {'1': 'UPLOAD_POLICY_PRESERVE', '2': 1},
    {'1': 'UPLOAD_POLICY_RENAME', '2': 2},
  ],
};

/// Descriptor for `File`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileDescriptor = $convert.base64Decode(
    'CgRGaWxlEg4KAmlkGAEgASgFUgJpZBI5CgpjcmVhdGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYAyABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSEgoEbmFtZRgEIAEoCVIEbmFtZRISCgR0eX'
    'BlGAUgASgJUgR0eXBlEhIKBHNpemUYBiABKANSBHNpemUSEgoEaGFzaBgHIAEoCVIEaGFzaBIS'
    'CgRwYXRoGAggASgJUgRwYXRoEiIKBHJlcG8YCiABKAsyDi5hcGkuZmlsZS5SZXBvUgRyZXBvEh'
    'cKB3JlcG9faWQYCyABKAVSBnJlcG9JZBrBAQoNVXBsb2FkUmVxdWVzdBIUCgVpbmRleBgBIAEo'
    'BVIFaW5kZXgSEgoEc2l6ZRgFIAEoA1IEc2l6ZRISCgRwYXRoGAMgASgJUgRwYXRoEhoKCGZpbG'
    'VuYW1lGAQgASgJUghmaWxlbmFtZRIUCgVjaHVuaxgCIAEoDFIFY2h1bmsSQAoNdXBsb2FkX3Bv'
    'bGljeRgGIAEoDjIbLmFwaS5maWxlLkZpbGUuVXBsb2FkUG9saWN5Ugx1cGxvYWRQb2xpY3kaUg'
    'oOVXBsb2FkUmVzcG9uc2USJgoGcmVzdWx0GAEgASgLMg4uYXBpLmZpbGUuRmlsZVIGcmVzdWx0'
    'EhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2UaiAEKC0xpc3RSZXF1ZXN0Ej4KBmZpbHRlchgBIA'
    'MoCzImLmFwaS5maWxlLkZpbGUuTGlzdFJlcXVlc3QuRmlsdGVyRW50cnlSBmZpbHRlcho5CgtG'
    'aWx0ZXJFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBGj'
    'gKDExpc3RSZXNwb25zZRIoCgdyZXN1bHRzGAEgAygLMg4uYXBpLmZpbGUuRmlsZVIHcmVzdWx0'
    'cxpSCgtNb3ZlUmVxdWVzdBISCgRwYXRoGAEgASgJUgRwYXRoEhkKCG5ld19wYXRoGAIgASgJUg'
    'duZXdQYXRoEhQKBW5hbWVzGAMgAygJUgVuYW1lcxoOCgxNb3ZlUmVzcG9uc2UaUgoLQ29weVJl'
    'cXVlc3QSEgoEcGF0aBgBIAEoCVIEcGF0aBIZCghuZXdfcGF0aBgCIAEoCVIHbmV3UGF0aBIUCg'
    'VuYW1lcxgDIAMoCVIFbmFtZXMaDgoMQ29weVJlc3BvbnNlGjYKDE1rZGlyUmVxdWVzdBISCgRw'
    'YXRoGAEgASgJUgRwYXRoEhIKBG5hbWUYAiABKAlSBG5hbWUaDwoNTWtkaXJSZXNwb25zZRpSCg'
    '1SZW5hbWVSZXF1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGgSEgoEbmFtZRgCIAEoCVIEbmFtZRIZ'
    'CghuZXdfbmFtZRgDIAEoCVIHbmV3TmFtZRoQCg5SZW5hbWVSZXNwb25zZRo5Cg1SZW1vdmVSZX'
    'F1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGgSFAoFbmFtZXMYAyADKAlSBW5hbWVzGhAKDlJlbW92'
    'ZVJlc3BvbnNlGiQKDlByZXZpZXdSZXF1ZXN0EhIKBHBhdGgYASABKAlSBHBhdGgaJwoPUHJldm'
    'lld1Jlc3BvbnNlEhQKBWNodW5rGAEgASgMUgVjaHVuaxolCg9Eb3dubG9hZFJlcXVlc3QSEgoE'
    'cGF0aBgBIAEoCVIEcGF0aBooChBEb3dubG9hZFJlc3BvbnNlEhQKBWNodW5rGAEgASgMUgVjaH'
    'VuayJfCgxVcGxvYWRQb2xpY3kSGQoVVVBMT0FEX1BPTElDWV9JTkhFUklUEAASGgoWVVBMT0FE'
    'X1BPTElDWV9QUkVTRVJWRRABEhgKFFVQTE9BRF9QT0xJQ1lfUkVOQU1FEAI=');


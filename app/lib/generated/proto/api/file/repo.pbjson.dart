//
//  Generated code. Do not modify.
//  source: api/file/repo.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use driverDescriptor instead')
const Driver$json = {
  '1': 'Driver',
  '2': [
    {'1': 'DRIVER_UNSPECIFIED', '2': 0},
    {'1': 'DRIVER_LOCAL', '2': 1},
    {'1': 'DRIVER_WEBDAV', '2': 2},
  ],
};

/// Descriptor for `Driver`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List driverDescriptor = $convert.base64Decode(
    'CgZEcml2ZXISFgoSRFJJVkVSX1VOU1BFQ0lGSUVEEAASEAoMRFJJVkVSX0xPQ0FMEAESEQoNRF'
    'JJVkVSX1dFQkRBVhAC');

@$core.Deprecated('Use repoDescriptor instead')
const Repo$json = {
  '1': 'Repo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'desc', '3': 5, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'path', '3': 6, '4': 1, '5': 9, '10': 'path'},
    {'1': 'driver', '3': 7, '4': 1, '5': 9, '10': 'driver'},
    {'1': 'option', '3': 8, '4': 1, '5': 9, '10': 'option'},
  ],
};

/// Descriptor for `Repo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List repoDescriptor = $convert.base64Decode(
    'CgRSZXBvEg4KAmlkGAEgASgFUgJpZBI5CgpjcmVhdGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYAyABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSEgoEbmFtZRgEIAEoCVIEbmFtZRISCgRkZX'
    'NjGAUgASgJUgRkZXNjEhIKBHBhdGgYBiABKAlSBHBhdGgSFgoGZHJpdmVyGAcgASgJUgZkcml2'
    'ZXISFgoGb3B0aW9uGAggASgJUgZvcHRpb24=');

@$core.Deprecated('Use listReposRequestDescriptor instead')
const ListReposRequest$json = {
  '1': 'ListReposRequest',
  '2': [
    {'1': 'page_num', '3': 1, '4': 1, '5': 5, '10': 'pageNum'},
    {'1': 'page_token', '3': 2, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListReposRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReposRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0UmVwb3NSZXF1ZXN0EhkKCHBhZ2VfbnVtGAEgASgFUgdwYWdlTnVtEh0KCnBhZ2VfdG'
    '9rZW4YAiABKAlSCXBhZ2VUb2tlbg==');

@$core.Deprecated('Use listReposResponseDescriptor instead')
const ListReposResponse$json = {
  '1': 'ListReposResponse',
  '2': [
    {'1': 'results', '3': 3, '4': 3, '5': 11, '6': '.api.file.Repo', '10': 'results'},
  ],
};

/// Descriptor for `ListReposResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReposResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0UmVwb3NSZXNwb25zZRIoCgdyZXN1bHRzGAMgAygLMg4uYXBpLmZpbGUuUmVwb1IHcm'
    'VzdWx0cw==');

@$core.Deprecated('Use createRepoRequestDescriptor instead')
const CreateRepoRequest$json = {
  '1': 'CreateRepoRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.file.Repo', '10': 'payload'},
  ],
};

/// Descriptor for `CreateRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRepoRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVSZXBvUmVxdWVzdBIoCgdwYXlsb2FkGAEgASgLMg4uYXBpLmZpbGUuUmVwb1IHcG'
    'F5bG9hZA==');

@$core.Deprecated('Use createRepoResponseDescriptor instead')
const CreateRepoResponse$json = {
  '1': 'CreateRepoResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.file.Repo', '10': 'result'},
  ],
};

/// Descriptor for `CreateRepoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRepoResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVSZXBvUmVzcG9uc2USJgoGcmVzdWx0GAEgASgLMg4uYXBpLmZpbGUuUmVwb1IGcm'
    'VzdWx0');

@$core.Deprecated('Use testRepoRequestDescriptor instead')
const TestRepoRequest$json = {
  '1': 'TestRepoRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.file.Repo', '10': 'payload'},
  ],
};

/// Descriptor for `TestRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testRepoRequestDescriptor = $convert.base64Decode(
    'Cg9UZXN0UmVwb1JlcXVlc3QSKAoHcGF5bG9hZBgBIAEoCzIOLmFwaS5maWxlLlJlcG9SB3BheW'
    'xvYWQ=');

@$core.Deprecated('Use testRepoResponseDescriptor instead')
const TestRepoResponse$json = {
  '1': 'TestRepoResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `TestRepoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testRepoResponseDescriptor = $convert.base64Decode(
    'ChBUZXN0UmVwb1Jlc3BvbnNlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3M=');

@$core.Deprecated('Use updateRepoRequestDescriptor instead')
const UpdateRepoRequest$json = {
  '1': 'UpdateRepoRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.file.Repo', '10': 'payload'},
  ],
};

/// Descriptor for `UpdateRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRepoRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVSZXBvUmVxdWVzdBIoCgdwYXlsb2FkGAEgASgLMg4uYXBpLmZpbGUuUmVwb1IHcG'
    'F5bG9hZA==');

@$core.Deprecated('Use updateRepoResponseDescriptor instead')
const UpdateRepoResponse$json = {
  '1': 'UpdateRepoResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.file.Repo', '10': 'result'},
  ],
};

/// Descriptor for `UpdateRepoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRepoResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVSZXBvUmVzcG9uc2USJgoGcmVzdWx0GAEgASgLMg4uYXBpLmZpbGUuUmVwb1IGcm'
    'VzdWx0');

@$core.Deprecated('Use deleteRepoRequestDescriptor instead')
const DeleteRepoRequest$json = {
  '1': 'DeleteRepoRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

/// Descriptor for `DeleteRepoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRepoRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVSZXBvUmVxdWVzdBIOCgJpZBgBIAEoBVICaWQ=');

@$core.Deprecated('Use deleteRepoResponseDescriptor instead')
const DeleteRepoResponse$json = {
  '1': 'DeleteRepoResponse',
};

/// Descriptor for `DeleteRepoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRepoResponseDescriptor = $convert.base64Decode(
    'ChJEZWxldGVSZXBvUmVzcG9uc2U=');


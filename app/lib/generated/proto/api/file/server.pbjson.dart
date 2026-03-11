//
//  Generated code. Do not modify.
//  source: api/file/server.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use serverDescriptor instead')
const Server$json = {
  '1': 'Server',
  '2': [
    {'1': 'addr', '3': 1, '4': 1, '5': 9, '10': 'addr'},
    {'1': 'running', '3': 2, '4': 1, '5': 8, '10': 'running'},
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
  '3': [Server_GetRequest$json, Server_GetResponse$json, Server_StartRequest$json, Server_StartResponse$json, Server_StopRequest$json, Server_StopResponse$json],
};

@$core.Deprecated('Use serverDescriptor instead')
const Server_GetRequest$json = {
  '1': 'GetRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
  ],
};

@$core.Deprecated('Use serverDescriptor instead')
const Server_GetResponse$json = {
  '1': 'GetResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.file.Server', '10': 'result'},
  ],
};

@$core.Deprecated('Use serverDescriptor instead')
const Server_StartRequest$json = {
  '1': 'StartRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'option', '3': 2, '4': 1, '5': 9, '10': 'option'},
  ],
};

@$core.Deprecated('Use serverDescriptor instead')
const Server_StartResponse$json = {
  '1': 'StartResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.file.Server', '10': 'result'},
  ],
};

@$core.Deprecated('Use serverDescriptor instead')
const Server_StopRequest$json = {
  '1': 'StopRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
  ],
};

@$core.Deprecated('Use serverDescriptor instead')
const Server_StopResponse$json = {
  '1': 'StopResponse',
};

/// Descriptor for `Server`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverDescriptor = $convert.base64Decode(
    'CgZTZXJ2ZXISEgoEYWRkchgBIAEoCVIEYWRkchIYCgdydW5uaW5nGAIgASgIUgdydW5uaW5nEh'
    'QKBWVycm9yGAMgASgJUgVlcnJvchogCgpHZXRSZXF1ZXN0EhIKBHR5cGUYASABKAlSBHR5cGUa'
    'NwoLR2V0UmVzcG9uc2USKAoGcmVzdWx0GAEgASgLMhAuYXBpLmZpbGUuU2VydmVyUgZyZXN1bH'
    'QaOgoMU3RhcnRSZXF1ZXN0EhIKBHR5cGUYASABKAlSBHR5cGUSFgoGb3B0aW9uGAIgASgJUgZv'
    'cHRpb24aOQoNU3RhcnRSZXNwb25zZRIoCgZyZXN1bHQYASABKAsyEC5hcGkuZmlsZS5TZXJ2ZX'
    'JSBnJlc3VsdBohCgtTdG9wUmVxdWVzdBISCgR0eXBlGAEgASgJUgR0eXBlGg4KDFN0b3BSZXNw'
    'b25zZQ==');


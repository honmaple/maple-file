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

@$core.Deprecated('Use externalServerDescriptor instead')
const ExternalServer$json = {
  '1': 'ExternalServer',
  '2': [
    {'1': 'addr', '3': 1, '4': 1, '5': 9, '10': 'addr'},
    {'1': 'running', '3': 2, '4': 1, '5': 8, '10': 'running'},
    {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
  '3': [ExternalServer_GetRequest$json, ExternalServer_GetResponse$json, ExternalServer_StartRequest$json, ExternalServer_StartResponse$json, ExternalServer_StopRequest$json, ExternalServer_StopResponse$json],
};

@$core.Deprecated('Use externalServerDescriptor instead')
const ExternalServer_GetRequest$json = {
  '1': 'GetRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
  ],
};

@$core.Deprecated('Use externalServerDescriptor instead')
const ExternalServer_GetResponse$json = {
  '1': 'GetResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.file.ExternalServer', '10': 'result'},
  ],
};

@$core.Deprecated('Use externalServerDescriptor instead')
const ExternalServer_StartRequest$json = {
  '1': 'StartRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
    {'1': 'option', '3': 2, '4': 1, '5': 9, '10': 'option'},
  ],
};

@$core.Deprecated('Use externalServerDescriptor instead')
const ExternalServer_StartResponse$json = {
  '1': 'StartResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.file.ExternalServer', '10': 'result'},
  ],
};

@$core.Deprecated('Use externalServerDescriptor instead')
const ExternalServer_StopRequest$json = {
  '1': 'StopRequest',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 9, '10': 'type'},
  ],
};

@$core.Deprecated('Use externalServerDescriptor instead')
const ExternalServer_StopResponse$json = {
  '1': 'StopResponse',
};

/// Descriptor for `ExternalServer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List externalServerDescriptor = $convert.base64Decode(
    'Cg5FeHRlcm5hbFNlcnZlchISCgRhZGRyGAEgASgJUgRhZGRyEhgKB3J1bm5pbmcYAiABKAhSB3'
    'J1bm5pbmcSFAoFZXJyb3IYAyABKAlSBWVycm9yGiAKCkdldFJlcXVlc3QSEgoEdHlwZRgBIAEo'
    'CVIEdHlwZRo/CgtHZXRSZXNwb25zZRIwCgZyZXN1bHQYASABKAsyGC5hcGkuZmlsZS5FeHRlcm'
    '5hbFNlcnZlclIGcmVzdWx0GjoKDFN0YXJ0UmVxdWVzdBISCgR0eXBlGAEgASgJUgR0eXBlEhYK'
    'Bm9wdGlvbhgCIAEoCVIGb3B0aW9uGkEKDVN0YXJ0UmVzcG9uc2USMAoGcmVzdWx0GAEgASgLMh'
    'guYXBpLmZpbGUuRXh0ZXJuYWxTZXJ2ZXJSBnJlc3VsdBohCgtTdG9wUmVxdWVzdBISCgR0eXBl'
    'GAEgASgJUgR0eXBlGg4KDFN0b3BSZXNwb25zZQ==');


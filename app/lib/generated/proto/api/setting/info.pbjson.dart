//
//  Generated code. Do not modify.
//  source: api/setting/info.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use infoDescriptor instead')
const Info$json = {
  '1': 'Info',
  '2': [
    {'1': 'os', '3': 1, '4': 1, '5': 9, '10': 'os'},
    {'1': 'arch', '3': 2, '4': 1, '5': 9, '10': 'arch'},
    {'1': 'runtime', '3': 3, '4': 1, '5': 9, '10': 'runtime'},
    {'1': 'version', '3': 4, '4': 1, '5': 9, '10': 'version'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `Info`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List infoDescriptor = $convert.base64Decode(
    'CgRJbmZvEg4KAm9zGAEgASgJUgJvcxISCgRhcmNoGAIgASgJUgRhcmNoEhgKB3J1bnRpbWUYAy'
    'ABKAlSB3J1bnRpbWUSGAoHdmVyc2lvbhgEIAEoCVIHdmVyc2lvbhIgCgtkZXNjcmlwdGlvbhgF'
    'IAEoCVILZGVzY3JpcHRpb24=');

@$core.Deprecated('Use infoRequestDescriptor instead')
const InfoRequest$json = {
  '1': 'InfoRequest',
};

/// Descriptor for `InfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List infoRequestDescriptor = $convert.base64Decode(
    'CgtJbmZvUmVxdWVzdA==');

@$core.Deprecated('Use infoResponseDescriptor instead')
const InfoResponse$json = {
  '1': 'InfoResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.setting.Info', '10': 'result'},
  ],
};

/// Descriptor for `InfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List infoResponseDescriptor = $convert.base64Decode(
    'CgxJbmZvUmVzcG9uc2USKQoGcmVzdWx0GAEgASgLMhEuYXBpLnNldHRpbmcuSW5mb1IGcmVzdW'
    'x0');


//
//  Generated code. Do not modify.
//  source: api/setting/setting.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use settingDescriptor instead')
const Setting$json = {
  '1': 'Setting',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'key', '3': 4, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 5, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `Setting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List settingDescriptor = $convert.base64Decode(
    'CgdTZXR0aW5nEg4KAmlkGAEgASgFUgJpZBI5CgpjcmVhdGVkX2F0GAIgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYAyABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSEAoDa2V5GAQgASgJUgNrZXkSFAoFdm'
    'FsdWUYBSABKAlSBXZhbHVl');

@$core.Deprecated('Use listSettingsRequestDescriptor instead')
const ListSettingsRequest$json = {
  '1': 'ListSettingsRequest',
};

/// Descriptor for `ListSettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSettingsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0U2V0dGluZ3NSZXF1ZXN0');

@$core.Deprecated('Use listSettingsResponseDescriptor instead')
const ListSettingsResponse$json = {
  '1': 'ListSettingsResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.setting.Setting', '10': 'results'},
  ],
};

/// Descriptor for `ListSettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSettingsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0U2V0dGluZ3NSZXNwb25zZRIuCgdyZXN1bHRzGAEgAygLMhQuYXBpLnNldHRpbmcuU2'
    'V0dGluZ1IHcmVzdWx0cw==');

@$core.Deprecated('Use getSettingRequestDescriptor instead')
const GetSettingRequest$json = {
  '1': 'GetSettingRequest',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
  ],
};

/// Descriptor for `GetSettingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingRequestDescriptor = $convert.base64Decode(
    'ChFHZXRTZXR0aW5nUmVxdWVzdBIQCgNrZXkYASABKAlSA2tleQ==');

@$core.Deprecated('Use getSettingResponseDescriptor instead')
const GetSettingResponse$json = {
  '1': 'GetSettingResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.setting.Setting', '10': 'result'},
  ],
};

/// Descriptor for `GetSettingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSettingResponseDescriptor = $convert.base64Decode(
    'ChJHZXRTZXR0aW5nUmVzcG9uc2USLAoGcmVzdWx0GAEgASgLMhQuYXBpLnNldHRpbmcuU2V0dG'
    'luZ1IGcmVzdWx0');

@$core.Deprecated('Use updateSettingRequestDescriptor instead')
const UpdateSettingRequest$json = {
  '1': 'UpdateSettingRequest',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `UpdateSettingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVTZXR0aW5nUmVxdWVzdBIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCV'
    'IFdmFsdWU=');

@$core.Deprecated('Use updateSettingResponseDescriptor instead')
const UpdateSettingResponse$json = {
  '1': 'UpdateSettingResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.setting.Setting', '10': 'result'},
  ],
};

/// Descriptor for `UpdateSettingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateSettingResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVTZXR0aW5nUmVzcG9uc2USLAoGcmVzdWx0GAEgASgLMhQuYXBpLnNldHRpbmcuU2'
    'V0dGluZ1IGcmVzdWx0');

@$core.Deprecated('Use resetSettingRequestDescriptor instead')
const ResetSettingRequest$json = {
  '1': 'ResetSettingRequest',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
  ],
};

/// Descriptor for `ResetSettingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetSettingRequestDescriptor = $convert.base64Decode(
    'ChNSZXNldFNldHRpbmdSZXF1ZXN0EhAKA2tleRgBIAEoCVIDa2V5');

@$core.Deprecated('Use resetSettingResponseDescriptor instead')
const ResetSettingResponse$json = {
  '1': 'ResetSettingResponse',
};

/// Descriptor for `ResetSettingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resetSettingResponseDescriptor = $convert.base64Decode(
    'ChRSZXNldFNldHRpbmdSZXNwb25zZQ==');


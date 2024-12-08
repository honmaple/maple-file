//
//  Generated code. Do not modify.
//  source: api/setting/service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'info.pb.dart' as $0;
import 'setting.pb.dart' as $1;

export 'service.pb.dart';

@$pb.GrpcServiceName('api.setting.SystemService')
class SystemServiceClient extends $grpc.Client {
  static final _$info = $grpc.ClientMethod<$0.InfoRequest, $0.InfoResponse>(
      '/api.setting.SystemService/Info',
      ($0.InfoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.InfoResponse.fromBuffer(value));
  static final _$listSettings = $grpc.ClientMethod<$1.ListSettingsRequest, $1.ListSettingsResponse>(
      '/api.setting.SystemService/ListSettings',
      ($1.ListSettingsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ListSettingsResponse.fromBuffer(value));
  static final _$resetSetting = $grpc.ClientMethod<$1.ResetSettingRequest, $1.ResetSettingResponse>(
      '/api.setting.SystemService/ResetSetting',
      ($1.ResetSettingRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ResetSettingResponse.fromBuffer(value));
  static final _$updateSetting = $grpc.ClientMethod<$1.UpdateSettingRequest, $1.UpdateSettingResponse>(
      '/api.setting.SystemService/UpdateSetting',
      ($1.UpdateSettingRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.UpdateSettingResponse.fromBuffer(value));
  static final _$getSetting = $grpc.ClientMethod<$1.GetSettingRequest, $1.GetSettingResponse>(
      '/api.setting.SystemService/GetSetting',
      ($1.GetSettingRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.GetSettingResponse.fromBuffer(value));

  SystemServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.InfoResponse> info($0.InfoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$info, request, options: options);
  }

  $grpc.ResponseFuture<$1.ListSettingsResponse> listSettings($1.ListSettingsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listSettings, request, options: options);
  }

  $grpc.ResponseFuture<$1.ResetSettingResponse> resetSetting($1.ResetSettingRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resetSetting, request, options: options);
  }

  $grpc.ResponseFuture<$1.UpdateSettingResponse> updateSetting($1.UpdateSettingRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateSetting, request, options: options);
  }

  $grpc.ResponseFuture<$1.GetSettingResponse> getSetting($1.GetSettingRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSetting, request, options: options);
  }
}

@$pb.GrpcServiceName('api.setting.SystemService')
abstract class SystemServiceBase extends $grpc.Service {
  $core.String get $name => 'api.setting.SystemService';

  SystemServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.InfoRequest, $0.InfoResponse>(
        'Info',
        info_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.InfoRequest.fromBuffer(value),
        ($0.InfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ListSettingsRequest, $1.ListSettingsResponse>(
        'ListSettings',
        listSettings_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ListSettingsRequest.fromBuffer(value),
        ($1.ListSettingsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ResetSettingRequest, $1.ResetSettingResponse>(
        'ResetSetting',
        resetSetting_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ResetSettingRequest.fromBuffer(value),
        ($1.ResetSettingResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.UpdateSettingRequest, $1.UpdateSettingResponse>(
        'UpdateSetting',
        updateSetting_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.UpdateSettingRequest.fromBuffer(value),
        ($1.UpdateSettingResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.GetSettingRequest, $1.GetSettingResponse>(
        'GetSetting',
        getSetting_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.GetSettingRequest.fromBuffer(value),
        ($1.GetSettingResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.InfoResponse> info_Pre($grpc.ServiceCall call, $async.Future<$0.InfoRequest> request) async {
    return info(call, await request);
  }

  $async.Future<$1.ListSettingsResponse> listSettings_Pre($grpc.ServiceCall call, $async.Future<$1.ListSettingsRequest> request) async {
    return listSettings(call, await request);
  }

  $async.Future<$1.ResetSettingResponse> resetSetting_Pre($grpc.ServiceCall call, $async.Future<$1.ResetSettingRequest> request) async {
    return resetSetting(call, await request);
  }

  $async.Future<$1.UpdateSettingResponse> updateSetting_Pre($grpc.ServiceCall call, $async.Future<$1.UpdateSettingRequest> request) async {
    return updateSetting(call, await request);
  }

  $async.Future<$1.GetSettingResponse> getSetting_Pre($grpc.ServiceCall call, $async.Future<$1.GetSettingRequest> request) async {
    return getSetting(call, await request);
  }

  $async.Future<$0.InfoResponse> info($grpc.ServiceCall call, $0.InfoRequest request);
  $async.Future<$1.ListSettingsResponse> listSettings($grpc.ServiceCall call, $1.ListSettingsRequest request);
  $async.Future<$1.ResetSettingResponse> resetSetting($grpc.ServiceCall call, $1.ResetSettingRequest request);
  $async.Future<$1.UpdateSettingResponse> updateSetting($grpc.ServiceCall call, $1.UpdateSettingRequest request);
  $async.Future<$1.GetSettingResponse> getSetting($grpc.ServiceCall call, $1.GetSettingRequest request);
}

//
//  Generated code. Do not modify.
//  source: api/syncing/syncing.proto
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

import 'syncing.pb.dart' as $0;

export 'syncing.pb.dart';

@$pb.GrpcServiceName('api.syncing.SyncService')
class SyncServiceClient extends $grpc.Client {
  static final _$listProfiles = $grpc.ClientMethod<$0.SyncProfile_ListRequest, $0.SyncProfile_ListResponse>(
      '/api.syncing.SyncService/ListProfiles',
      ($0.SyncProfile_ListRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncProfile_ListResponse.fromBuffer(value));
  static final _$createProfile = $grpc.ClientMethod<$0.SyncProfile_CreateRequest, $0.SyncProfile_CreateResponse>(
      '/api.syncing.SyncService/CreateProfile',
      ($0.SyncProfile_CreateRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncProfile_CreateResponse.fromBuffer(value));
  static final _$updateProfile = $grpc.ClientMethod<$0.SyncProfile_UpdateRequest, $0.SyncProfile_UpdateResponse>(
      '/api.syncing.SyncService/UpdateProfile',
      ($0.SyncProfile_UpdateRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncProfile_UpdateResponse.fromBuffer(value));
  static final _$deleteProfile = $grpc.ClientMethod<$0.SyncProfile_DeleteRequest, $0.SyncProfile_DeleteResponse>(
      '/api.syncing.SyncService/DeleteProfile',
      ($0.SyncProfile_DeleteRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncProfile_DeleteResponse.fromBuffer(value));
  static final _$listRecords = $grpc.ClientMethod<$0.SyncRecord_ListRequest, $0.SyncRecord_ListResponse>(
      '/api.syncing.SyncService/ListRecords',
      ($0.SyncRecord_ListRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncRecord_ListResponse.fromBuffer(value));
  static final _$upsertRecords = $grpc.ClientMethod<$0.SyncRecord_UpsertRequest, $0.SyncRecord_UpsertResponse>(
      '/api.syncing.SyncService/UpsertRecords',
      ($0.SyncRecord_UpsertRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncRecord_UpsertResponse.fromBuffer(value));
  static final _$listHistories = $grpc.ClientMethod<$0.SyncHistory_ListRequest, $0.SyncHistory_ListResponse>(
      '/api.syncing.SyncService/ListHistories',
      ($0.SyncHistory_ListRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncHistory_ListResponse.fromBuffer(value));
  static final _$createHistory = $grpc.ClientMethod<$0.SyncHistory_CreateRequest, $0.SyncHistory_CreateResponse>(
      '/api.syncing.SyncService/CreateHistory',
      ($0.SyncHistory_CreateRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncHistory_CreateResponse.fromBuffer(value));
  static final _$startHistory = $grpc.ClientMethod<$0.SyncHistory_StartRequest, $0.SyncHistory_StartResponse>(
      '/api.syncing.SyncService/StartHistory',
      ($0.SyncHistory_StartRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncHistory_StartResponse.fromBuffer(value));
  static final _$finishHistory = $grpc.ClientMethod<$0.SyncHistory_FinishRequest, $0.SyncHistory_FinishResponse>(
      '/api.syncing.SyncService/FinishHistory',
      ($0.SyncHistory_FinishRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncHistory_FinishResponse.fromBuffer(value));
  static final _$listHistoryIssues = $grpc.ClientMethod<$0.SyncHistoryIssue_ListRequest, $0.SyncHistoryIssue_ListResponse>(
      '/api.syncing.SyncService/ListHistoryIssues',
      ($0.SyncHistoryIssue_ListRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SyncHistoryIssue_ListResponse.fromBuffer(value));

  SyncServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.SyncProfile_ListResponse> listProfiles($0.SyncProfile_ListRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listProfiles, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncProfile_CreateResponse> createProfile($0.SyncProfile_CreateRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncProfile_UpdateResponse> updateProfile($0.SyncProfile_UpdateRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncProfile_DeleteResponse> deleteProfile($0.SyncProfile_DeleteRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncRecord_ListResponse> listRecords($0.SyncRecord_ListRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listRecords, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncRecord_UpsertResponse> upsertRecords($0.SyncRecord_UpsertRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$upsertRecords, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncHistory_ListResponse> listHistories($0.SyncHistory_ListRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listHistories, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncHistory_CreateResponse> createHistory($0.SyncHistory_CreateRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createHistory, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncHistory_StartResponse> startHistory($0.SyncHistory_StartRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$startHistory, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncHistory_FinishResponse> finishHistory($0.SyncHistory_FinishRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$finishHistory, request, options: options);
  }

  $grpc.ResponseFuture<$0.SyncHistoryIssue_ListResponse> listHistoryIssues($0.SyncHistoryIssue_ListRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listHistoryIssues, request, options: options);
  }
}

@$pb.GrpcServiceName('api.syncing.SyncService')
abstract class SyncServiceBase extends $grpc.Service {
  $core.String get $name => 'api.syncing.SyncService';

  SyncServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SyncProfile_ListRequest, $0.SyncProfile_ListResponse>(
        'ListProfiles',
        listProfiles_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncProfile_ListRequest.fromBuffer(value),
        ($0.SyncProfile_ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncProfile_CreateRequest, $0.SyncProfile_CreateResponse>(
        'CreateProfile',
        createProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncProfile_CreateRequest.fromBuffer(value),
        ($0.SyncProfile_CreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncProfile_UpdateRequest, $0.SyncProfile_UpdateResponse>(
        'UpdateProfile',
        updateProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncProfile_UpdateRequest.fromBuffer(value),
        ($0.SyncProfile_UpdateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncProfile_DeleteRequest, $0.SyncProfile_DeleteResponse>(
        'DeleteProfile',
        deleteProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncProfile_DeleteRequest.fromBuffer(value),
        ($0.SyncProfile_DeleteResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncRecord_ListRequest, $0.SyncRecord_ListResponse>(
        'ListRecords',
        listRecords_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncRecord_ListRequest.fromBuffer(value),
        ($0.SyncRecord_ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncRecord_UpsertRequest, $0.SyncRecord_UpsertResponse>(
        'UpsertRecords',
        upsertRecords_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncRecord_UpsertRequest.fromBuffer(value),
        ($0.SyncRecord_UpsertResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncHistory_ListRequest, $0.SyncHistory_ListResponse>(
        'ListHistories',
        listHistories_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncHistory_ListRequest.fromBuffer(value),
        ($0.SyncHistory_ListResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncHistory_CreateRequest, $0.SyncHistory_CreateResponse>(
        'CreateHistory',
        createHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncHistory_CreateRequest.fromBuffer(value),
        ($0.SyncHistory_CreateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncHistory_StartRequest, $0.SyncHistory_StartResponse>(
        'StartHistory',
        startHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncHistory_StartRequest.fromBuffer(value),
        ($0.SyncHistory_StartResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncHistory_FinishRequest, $0.SyncHistory_FinishResponse>(
        'FinishHistory',
        finishHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncHistory_FinishRequest.fromBuffer(value),
        ($0.SyncHistory_FinishResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncHistoryIssue_ListRequest, $0.SyncHistoryIssue_ListResponse>(
        'ListHistoryIssues',
        listHistoryIssues_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncHistoryIssue_ListRequest.fromBuffer(value),
        ($0.SyncHistoryIssue_ListResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.SyncProfile_ListResponse> listProfiles_Pre($grpc.ServiceCall call, $async.Future<$0.SyncProfile_ListRequest> request) async {
    return listProfiles(call, await request);
  }

  $async.Future<$0.SyncProfile_CreateResponse> createProfile_Pre($grpc.ServiceCall call, $async.Future<$0.SyncProfile_CreateRequest> request) async {
    return createProfile(call, await request);
  }

  $async.Future<$0.SyncProfile_UpdateResponse> updateProfile_Pre($grpc.ServiceCall call, $async.Future<$0.SyncProfile_UpdateRequest> request) async {
    return updateProfile(call, await request);
  }

  $async.Future<$0.SyncProfile_DeleteResponse> deleteProfile_Pre($grpc.ServiceCall call, $async.Future<$0.SyncProfile_DeleteRequest> request) async {
    return deleteProfile(call, await request);
  }

  $async.Future<$0.SyncRecord_ListResponse> listRecords_Pre($grpc.ServiceCall call, $async.Future<$0.SyncRecord_ListRequest> request) async {
    return listRecords(call, await request);
  }

  $async.Future<$0.SyncRecord_UpsertResponse> upsertRecords_Pre($grpc.ServiceCall call, $async.Future<$0.SyncRecord_UpsertRequest> request) async {
    return upsertRecords(call, await request);
  }

  $async.Future<$0.SyncHistory_ListResponse> listHistories_Pre($grpc.ServiceCall call, $async.Future<$0.SyncHistory_ListRequest> request) async {
    return listHistories(call, await request);
  }

  $async.Future<$0.SyncHistory_CreateResponse> createHistory_Pre($grpc.ServiceCall call, $async.Future<$0.SyncHistory_CreateRequest> request) async {
    return createHistory(call, await request);
  }

  $async.Future<$0.SyncHistory_StartResponse> startHistory_Pre($grpc.ServiceCall call, $async.Future<$0.SyncHistory_StartRequest> request) async {
    return startHistory(call, await request);
  }

  $async.Future<$0.SyncHistory_FinishResponse> finishHistory_Pre($grpc.ServiceCall call, $async.Future<$0.SyncHistory_FinishRequest> request) async {
    return finishHistory(call, await request);
  }

  $async.Future<$0.SyncHistoryIssue_ListResponse> listHistoryIssues_Pre($grpc.ServiceCall call, $async.Future<$0.SyncHistoryIssue_ListRequest> request) async {
    return listHistoryIssues(call, await request);
  }

  $async.Future<$0.SyncProfile_ListResponse> listProfiles($grpc.ServiceCall call, $0.SyncProfile_ListRequest request);
  $async.Future<$0.SyncProfile_CreateResponse> createProfile($grpc.ServiceCall call, $0.SyncProfile_CreateRequest request);
  $async.Future<$0.SyncProfile_UpdateResponse> updateProfile($grpc.ServiceCall call, $0.SyncProfile_UpdateRequest request);
  $async.Future<$0.SyncProfile_DeleteResponse> deleteProfile($grpc.ServiceCall call, $0.SyncProfile_DeleteRequest request);
  $async.Future<$0.SyncRecord_ListResponse> listRecords($grpc.ServiceCall call, $0.SyncRecord_ListRequest request);
  $async.Future<$0.SyncRecord_UpsertResponse> upsertRecords($grpc.ServiceCall call, $0.SyncRecord_UpsertRequest request);
  $async.Future<$0.SyncHistory_ListResponse> listHistories($grpc.ServiceCall call, $0.SyncHistory_ListRequest request);
  $async.Future<$0.SyncHistory_CreateResponse> createHistory($grpc.ServiceCall call, $0.SyncHistory_CreateRequest request);
  $async.Future<$0.SyncHistory_StartResponse> startHistory($grpc.ServiceCall call, $0.SyncHistory_StartRequest request);
  $async.Future<$0.SyncHistory_FinishResponse> finishHistory($grpc.ServiceCall call, $0.SyncHistory_FinishRequest request);
  $async.Future<$0.SyncHistoryIssue_ListResponse> listHistoryIssues($grpc.ServiceCall call, $0.SyncHistoryIssue_ListRequest request);
}

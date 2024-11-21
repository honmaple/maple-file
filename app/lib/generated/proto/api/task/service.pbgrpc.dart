//
//  Generated code. Do not modify.
//  source: api/task/service.proto
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

import 'task.pb.dart' as $0;

export 'service.pb.dart';

@$pb.GrpcServiceName('api.task.TaskService')
class TaskServiceClient extends $grpc.Client {
  static final _$listTasks = $grpc.ClientMethod<$0.ListTasksRequest, $0.ListTasksResponse>(
      '/api.task.TaskService/ListTasks',
      ($0.ListTasksRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ListTasksResponse.fromBuffer(value));
  static final _$retryTask = $grpc.ClientMethod<$0.RetryTaskRequest, $0.RetryTaskResponse>(
      '/api.task.TaskService/RetryTask',
      ($0.RetryTaskRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RetryTaskResponse.fromBuffer(value));
  static final _$cancelTask = $grpc.ClientMethod<$0.CancelTaskRequest, $0.CancelTaskResponse>(
      '/api.task.TaskService/CancelTask',
      ($0.CancelTaskRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.CancelTaskResponse.fromBuffer(value));
  static final _$removeTask = $grpc.ClientMethod<$0.RemoveTaskRequest, $0.RemoveTaskResponse>(
      '/api.task.TaskService/RemoveTask',
      ($0.RemoveTaskRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RemoveTaskResponse.fromBuffer(value));

  TaskServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.ListTasksResponse> listTasks($0.ListTasksRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listTasks, request, options: options);
  }

  $grpc.ResponseFuture<$0.RetryTaskResponse> retryTask($0.RetryTaskRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$retryTask, request, options: options);
  }

  $grpc.ResponseFuture<$0.CancelTaskResponse> cancelTask($0.CancelTaskRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$cancelTask, request, options: options);
  }

  $grpc.ResponseFuture<$0.RemoveTaskResponse> removeTask($0.RemoveTaskRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$removeTask, request, options: options);
  }
}

@$pb.GrpcServiceName('api.task.TaskService')
abstract class TaskServiceBase extends $grpc.Service {
  $core.String get $name => 'api.task.TaskService';

  TaskServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListTasksRequest, $0.ListTasksResponse>(
        'ListTasks',
        listTasks_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListTasksRequest.fromBuffer(value),
        ($0.ListTasksResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RetryTaskRequest, $0.RetryTaskResponse>(
        'RetryTask',
        retryTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RetryTaskRequest.fromBuffer(value),
        ($0.RetryTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelTaskRequest, $0.CancelTaskResponse>(
        'CancelTask',
        cancelTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CancelTaskRequest.fromBuffer(value),
        ($0.CancelTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveTaskRequest, $0.RemoveTaskResponse>(
        'RemoveTask',
        removeTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RemoveTaskRequest.fromBuffer(value),
        ($0.RemoveTaskResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListTasksResponse> listTasks_Pre($grpc.ServiceCall call, $async.Future<$0.ListTasksRequest> request) async {
    return listTasks(call, await request);
  }

  $async.Future<$0.RetryTaskResponse> retryTask_Pre($grpc.ServiceCall call, $async.Future<$0.RetryTaskRequest> request) async {
    return retryTask(call, await request);
  }

  $async.Future<$0.CancelTaskResponse> cancelTask_Pre($grpc.ServiceCall call, $async.Future<$0.CancelTaskRequest> request) async {
    return cancelTask(call, await request);
  }

  $async.Future<$0.RemoveTaskResponse> removeTask_Pre($grpc.ServiceCall call, $async.Future<$0.RemoveTaskRequest> request) async {
    return removeTask(call, await request);
  }

  $async.Future<$0.ListTasksResponse> listTasks($grpc.ServiceCall call, $0.ListTasksRequest request);
  $async.Future<$0.RetryTaskResponse> retryTask($grpc.ServiceCall call, $0.RetryTaskRequest request);
  $async.Future<$0.CancelTaskResponse> cancelTask($grpc.ServiceCall call, $0.CancelTaskRequest request);
  $async.Future<$0.RemoveTaskResponse> removeTask($grpc.ServiceCall call, $0.RemoveTaskRequest request);
}

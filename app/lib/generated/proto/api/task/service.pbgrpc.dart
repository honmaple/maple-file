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

import 'persist.pb.dart' as $1;
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
  static final _$listPersistTasks = $grpc.ClientMethod<$1.ListPersistTasksRequest, $1.ListPersistTasksResponse>(
      '/api.task.TaskService/ListPersistTasks',
      ($1.ListPersistTasksRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ListPersistTasksResponse.fromBuffer(value));
  static final _$createPersistTask = $grpc.ClientMethod<$1.CreatePersistTaskRequest, $1.CreatePersistTaskResponse>(
      '/api.task.TaskService/CreatePersistTask',
      ($1.CreatePersistTaskRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.CreatePersistTaskResponse.fromBuffer(value));
  static final _$updatePersistTask = $grpc.ClientMethod<$1.UpdatePersistTaskRequest, $1.UpdatePersistTaskResponse>(
      '/api.task.TaskService/UpdatePersistTask',
      ($1.UpdatePersistTaskRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.UpdatePersistTaskResponse.fromBuffer(value));
  static final _$deletePersistTask = $grpc.ClientMethod<$1.DeletePersistTaskRequest, $1.DeletePersistTaskResponse>(
      '/api.task.TaskService/DeletePersistTask',
      ($1.DeletePersistTaskRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.DeletePersistTaskResponse.fromBuffer(value));
  static final _$executePersistTask = $grpc.ClientMethod<$1.ExecutePersistTaskRequest, $1.ExecutePersistTaskResponse>(
      '/api.task.TaskService/ExecutePersistTask',
      ($1.ExecutePersistTaskRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ExecutePersistTaskResponse.fromBuffer(value));

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

  $grpc.ResponseFuture<$1.ListPersistTasksResponse> listPersistTasks($1.ListPersistTasksRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listPersistTasks, request, options: options);
  }

  $grpc.ResponseFuture<$1.CreatePersistTaskResponse> createPersistTask($1.CreatePersistTaskRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createPersistTask, request, options: options);
  }

  $grpc.ResponseFuture<$1.UpdatePersistTaskResponse> updatePersistTask($1.UpdatePersistTaskRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updatePersistTask, request, options: options);
  }

  $grpc.ResponseFuture<$1.DeletePersistTaskResponse> deletePersistTask($1.DeletePersistTaskRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deletePersistTask, request, options: options);
  }

  $grpc.ResponseFuture<$1.ExecutePersistTaskResponse> executePersistTask($1.ExecutePersistTaskRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$executePersistTask, request, options: options);
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
    $addMethod($grpc.ServiceMethod<$1.ListPersistTasksRequest, $1.ListPersistTasksResponse>(
        'ListPersistTasks',
        listPersistTasks_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ListPersistTasksRequest.fromBuffer(value),
        ($1.ListPersistTasksResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.CreatePersistTaskRequest, $1.CreatePersistTaskResponse>(
        'CreatePersistTask',
        createPersistTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.CreatePersistTaskRequest.fromBuffer(value),
        ($1.CreatePersistTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.UpdatePersistTaskRequest, $1.UpdatePersistTaskResponse>(
        'UpdatePersistTask',
        updatePersistTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.UpdatePersistTaskRequest.fromBuffer(value),
        ($1.UpdatePersistTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.DeletePersistTaskRequest, $1.DeletePersistTaskResponse>(
        'DeletePersistTask',
        deletePersistTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.DeletePersistTaskRequest.fromBuffer(value),
        ($1.DeletePersistTaskResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ExecutePersistTaskRequest, $1.ExecutePersistTaskResponse>(
        'ExecutePersistTask',
        executePersistTask_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ExecutePersistTaskRequest.fromBuffer(value),
        ($1.ExecutePersistTaskResponse value) => value.writeToBuffer()));
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

  $async.Future<$1.ListPersistTasksResponse> listPersistTasks_Pre($grpc.ServiceCall call, $async.Future<$1.ListPersistTasksRequest> request) async {
    return listPersistTasks(call, await request);
  }

  $async.Future<$1.CreatePersistTaskResponse> createPersistTask_Pre($grpc.ServiceCall call, $async.Future<$1.CreatePersistTaskRequest> request) async {
    return createPersistTask(call, await request);
  }

  $async.Future<$1.UpdatePersistTaskResponse> updatePersistTask_Pre($grpc.ServiceCall call, $async.Future<$1.UpdatePersistTaskRequest> request) async {
    return updatePersistTask(call, await request);
  }

  $async.Future<$1.DeletePersistTaskResponse> deletePersistTask_Pre($grpc.ServiceCall call, $async.Future<$1.DeletePersistTaskRequest> request) async {
    return deletePersistTask(call, await request);
  }

  $async.Future<$1.ExecutePersistTaskResponse> executePersistTask_Pre($grpc.ServiceCall call, $async.Future<$1.ExecutePersistTaskRequest> request) async {
    return executePersistTask(call, await request);
  }

  $async.Future<$0.ListTasksResponse> listTasks($grpc.ServiceCall call, $0.ListTasksRequest request);
  $async.Future<$0.RetryTaskResponse> retryTask($grpc.ServiceCall call, $0.RetryTaskRequest request);
  $async.Future<$0.CancelTaskResponse> cancelTask($grpc.ServiceCall call, $0.CancelTaskRequest request);
  $async.Future<$0.RemoveTaskResponse> removeTask($grpc.ServiceCall call, $0.RemoveTaskRequest request);
  $async.Future<$1.ListPersistTasksResponse> listPersistTasks($grpc.ServiceCall call, $1.ListPersistTasksRequest request);
  $async.Future<$1.CreatePersistTaskResponse> createPersistTask($grpc.ServiceCall call, $1.CreatePersistTaskRequest request);
  $async.Future<$1.UpdatePersistTaskResponse> updatePersistTask($grpc.ServiceCall call, $1.UpdatePersistTaskRequest request);
  $async.Future<$1.DeletePersistTaskResponse> deletePersistTask($grpc.ServiceCall call, $1.DeletePersistTaskRequest request);
  $async.Future<$1.ExecutePersistTaskResponse> executePersistTask($grpc.ServiceCall call, $1.ExecutePersistTaskRequest request);
}

//
//  Generated code. Do not modify.
//  source: api/file/server.proto
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

import 'server.pb.dart' as $0;

export 'server.pb.dart';

@$pb.GrpcServiceName('api.file.ServerService')
class ServerServiceClient extends $grpc.Client {
  static final _$startServer = $grpc.ClientMethod<$0.Server_StartRequest, $0.Server_StartResponse>(
      '/api.file.ServerService/StartServer',
      ($0.Server_StartRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Server_StartResponse.fromBuffer(value));
  static final _$stopServer = $grpc.ClientMethod<$0.Server_StopRequest, $0.Server_StopResponse>(
      '/api.file.ServerService/StopServer',
      ($0.Server_StopRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Server_StopResponse.fromBuffer(value));
  static final _$serverStatus = $grpc.ClientMethod<$0.Server_GetRequest, $0.Server_GetResponse>(
      '/api.file.ServerService/ServerStatus',
      ($0.Server_GetRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Server_GetResponse.fromBuffer(value));

  ServerServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.Server_StartResponse> startServer($0.Server_StartRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$startServer, request, options: options);
  }

  $grpc.ResponseFuture<$0.Server_StopResponse> stopServer($0.Server_StopRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$stopServer, request, options: options);
  }

  $grpc.ResponseFuture<$0.Server_GetResponse> serverStatus($0.Server_GetRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$serverStatus, request, options: options);
  }
}

@$pb.GrpcServiceName('api.file.ServerService')
abstract class ServerServiceBase extends $grpc.Service {
  $core.String get $name => 'api.file.ServerService';

  ServerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Server_StartRequest, $0.Server_StartResponse>(
        'StartServer',
        startServer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Server_StartRequest.fromBuffer(value),
        ($0.Server_StartResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Server_StopRequest, $0.Server_StopResponse>(
        'StopServer',
        stopServer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Server_StopRequest.fromBuffer(value),
        ($0.Server_StopResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Server_GetRequest, $0.Server_GetResponse>(
        'ServerStatus',
        serverStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Server_GetRequest.fromBuffer(value),
        ($0.Server_GetResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.Server_StartResponse> startServer_Pre($grpc.ServiceCall call, $async.Future<$0.Server_StartRequest> request) async {
    return startServer(call, await request);
  }

  $async.Future<$0.Server_StopResponse> stopServer_Pre($grpc.ServiceCall call, $async.Future<$0.Server_StopRequest> request) async {
    return stopServer(call, await request);
  }

  $async.Future<$0.Server_GetResponse> serverStatus_Pre($grpc.ServiceCall call, $async.Future<$0.Server_GetRequest> request) async {
    return serverStatus(call, await request);
  }

  $async.Future<$0.Server_StartResponse> startServer($grpc.ServiceCall call, $0.Server_StartRequest request);
  $async.Future<$0.Server_StopResponse> stopServer($grpc.ServiceCall call, $0.Server_StopRequest request);
  $async.Future<$0.Server_GetResponse> serverStatus($grpc.ServiceCall call, $0.Server_GetRequest request);
}

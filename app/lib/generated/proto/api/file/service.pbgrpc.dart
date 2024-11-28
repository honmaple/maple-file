//
//  Generated code. Do not modify.
//  source: api/file/service.proto
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

import 'file.pb.dart' as $0;
import 'repo.pb.dart' as $1;

export 'service.pb.dart';

@$pb.GrpcServiceName('api.file.FileService')
class FileServiceClient extends $grpc.Client {
  static final _$list = $grpc.ClientMethod<$0.ListFilesRequest, $0.ListFilesResponse>(
      '/api.file.FileService/List',
      ($0.ListFilesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ListFilesResponse.fromBuffer(value));
  static final _$move = $grpc.ClientMethod<$0.MoveFileRequest, $0.MoveFileResponse>(
      '/api.file.FileService/Move',
      ($0.MoveFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MoveFileResponse.fromBuffer(value));
  static final _$copy = $grpc.ClientMethod<$0.CopyFileRequest, $0.CopyFileResponse>(
      '/api.file.FileService/Copy',
      ($0.CopyFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.CopyFileResponse.fromBuffer(value));
  static final _$mkdir = $grpc.ClientMethod<$0.MkdirFileRequest, $0.MkdirFileResponse>(
      '/api.file.FileService/Mkdir',
      ($0.MkdirFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.MkdirFileResponse.fromBuffer(value));
  static final _$rename = $grpc.ClientMethod<$0.RenameFileRequest, $0.RenameFileResponse>(
      '/api.file.FileService/Rename',
      ($0.RenameFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RenameFileResponse.fromBuffer(value));
  static final _$remove = $grpc.ClientMethod<$0.RemoveFileRequest, $0.RemoveFileResponse>(
      '/api.file.FileService/Remove',
      ($0.RemoveFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RemoveFileResponse.fromBuffer(value));
  static final _$upload = $grpc.ClientMethod<$0.FileRequest, $0.FileResponse>(
      '/api.file.FileService/Upload',
      ($0.FileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.FileResponse.fromBuffer(value));
  static final _$download = $grpc.ClientMethod<$0.DownloadFileRequest, $0.DownloadFileResponse>(
      '/api.file.FileService/Download',
      ($0.DownloadFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.DownloadFileResponse.fromBuffer(value));
  static final _$preview = $grpc.ClientMethod<$0.PreviewFileRequest, $0.PreviewFileResponse>(
      '/api.file.FileService/Preview',
      ($0.PreviewFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PreviewFileResponse.fromBuffer(value));
  static final _$listRepos = $grpc.ClientMethod<$1.ListReposRequest, $1.ListReposResponse>(
      '/api.file.FileService/ListRepos',
      ($1.ListReposRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ListReposResponse.fromBuffer(value));
  static final _$createRepo = $grpc.ClientMethod<$1.CreateRepoRequest, $1.CreateRepoResponse>(
      '/api.file.FileService/CreateRepo',
      ($1.CreateRepoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.CreateRepoResponse.fromBuffer(value));
  static final _$updateRepo = $grpc.ClientMethod<$1.UpdateRepoRequest, $1.UpdateRepoResponse>(
      '/api.file.FileService/UpdateRepo',
      ($1.UpdateRepoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.UpdateRepoResponse.fromBuffer(value));
  static final _$deleteRepo = $grpc.ClientMethod<$1.DeleteRepoRequest, $1.DeleteRepoResponse>(
      '/api.file.FileService/DeleteRepo',
      ($1.DeleteRepoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.DeleteRepoResponse.fromBuffer(value));
  static final _$testRepo = $grpc.ClientMethod<$1.TestRepoRequest, $1.TestRepoResponse>(
      '/api.file.FileService/TestRepo',
      ($1.TestRepoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.TestRepoResponse.fromBuffer(value));

  FileServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.ListFilesResponse> list($0.ListFilesRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$0.MoveFileResponse> move($0.MoveFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$move, request, options: options);
  }

  $grpc.ResponseFuture<$0.CopyFileResponse> copy($0.CopyFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$copy, request, options: options);
  }

  $grpc.ResponseFuture<$0.MkdirFileResponse> mkdir($0.MkdirFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$mkdir, request, options: options);
  }

  $grpc.ResponseFuture<$0.RenameFileResponse> rename($0.RenameFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$rename, request, options: options);
  }

  $grpc.ResponseFuture<$0.RemoveFileResponse> remove($0.RemoveFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$remove, request, options: options);
  }

  $grpc.ResponseFuture<$0.FileResponse> upload($async.Stream<$0.FileRequest> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$upload, request, options: options).single;
  }

  $grpc.ResponseStream<$0.DownloadFileResponse> download($0.DownloadFileRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$download, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$0.PreviewFileResponse> preview($0.PreviewFileRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$preview, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$1.ListReposResponse> listRepos($1.ListReposRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listRepos, request, options: options);
  }

  $grpc.ResponseFuture<$1.CreateRepoResponse> createRepo($1.CreateRepoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createRepo, request, options: options);
  }

  $grpc.ResponseFuture<$1.UpdateRepoResponse> updateRepo($1.UpdateRepoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateRepo, request, options: options);
  }

  $grpc.ResponseFuture<$1.DeleteRepoResponse> deleteRepo($1.DeleteRepoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteRepo, request, options: options);
  }

  $grpc.ResponseFuture<$1.TestRepoResponse> testRepo($1.TestRepoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$testRepo, request, options: options);
  }
}

@$pb.GrpcServiceName('api.file.FileService')
abstract class FileServiceBase extends $grpc.Service {
  $core.String get $name => 'api.file.FileService';

  FileServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ListFilesRequest, $0.ListFilesResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListFilesRequest.fromBuffer(value),
        ($0.ListFilesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MoveFileRequest, $0.MoveFileResponse>(
        'Move',
        move_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MoveFileRequest.fromBuffer(value),
        ($0.MoveFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CopyFileRequest, $0.CopyFileResponse>(
        'Copy',
        copy_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CopyFileRequest.fromBuffer(value),
        ($0.CopyFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.MkdirFileRequest, $0.MkdirFileResponse>(
        'Mkdir',
        mkdir_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.MkdirFileRequest.fromBuffer(value),
        ($0.MkdirFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RenameFileRequest, $0.RenameFileResponse>(
        'Rename',
        rename_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RenameFileRequest.fromBuffer(value),
        ($0.RenameFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemoveFileRequest, $0.RemoveFileResponse>(
        'Remove',
        remove_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RemoveFileRequest.fromBuffer(value),
        ($0.RemoveFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FileRequest, $0.FileResponse>(
        'Upload',
        upload,
        true,
        false,
        ($core.List<$core.int> value) => $0.FileRequest.fromBuffer(value),
        ($0.FileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DownloadFileRequest, $0.DownloadFileResponse>(
        'Download',
        download_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.DownloadFileRequest.fromBuffer(value),
        ($0.DownloadFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PreviewFileRequest, $0.PreviewFileResponse>(
        'Preview',
        preview_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.PreviewFileRequest.fromBuffer(value),
        ($0.PreviewFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.ListReposRequest, $1.ListReposResponse>(
        'ListRepos',
        listRepos_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ListReposRequest.fromBuffer(value),
        ($1.ListReposResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.CreateRepoRequest, $1.CreateRepoResponse>(
        'CreateRepo',
        createRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.CreateRepoRequest.fromBuffer(value),
        ($1.CreateRepoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.UpdateRepoRequest, $1.UpdateRepoResponse>(
        'UpdateRepo',
        updateRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.UpdateRepoRequest.fromBuffer(value),
        ($1.UpdateRepoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.DeleteRepoRequest, $1.DeleteRepoResponse>(
        'DeleteRepo',
        deleteRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.DeleteRepoRequest.fromBuffer(value),
        ($1.DeleteRepoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.TestRepoRequest, $1.TestRepoResponse>(
        'TestRepo',
        testRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.TestRepoRequest.fromBuffer(value),
        ($1.TestRepoResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListFilesResponse> list_Pre($grpc.ServiceCall call, $async.Future<$0.ListFilesRequest> request) async {
    return list(call, await request);
  }

  $async.Future<$0.MoveFileResponse> move_Pre($grpc.ServiceCall call, $async.Future<$0.MoveFileRequest> request) async {
    return move(call, await request);
  }

  $async.Future<$0.CopyFileResponse> copy_Pre($grpc.ServiceCall call, $async.Future<$0.CopyFileRequest> request) async {
    return copy(call, await request);
  }

  $async.Future<$0.MkdirFileResponse> mkdir_Pre($grpc.ServiceCall call, $async.Future<$0.MkdirFileRequest> request) async {
    return mkdir(call, await request);
  }

  $async.Future<$0.RenameFileResponse> rename_Pre($grpc.ServiceCall call, $async.Future<$0.RenameFileRequest> request) async {
    return rename(call, await request);
  }

  $async.Future<$0.RemoveFileResponse> remove_Pre($grpc.ServiceCall call, $async.Future<$0.RemoveFileRequest> request) async {
    return remove(call, await request);
  }

  $async.Stream<$0.DownloadFileResponse> download_Pre($grpc.ServiceCall call, $async.Future<$0.DownloadFileRequest> request) async* {
    yield* download(call, await request);
  }

  $async.Stream<$0.PreviewFileResponse> preview_Pre($grpc.ServiceCall call, $async.Future<$0.PreviewFileRequest> request) async* {
    yield* preview(call, await request);
  }

  $async.Future<$1.ListReposResponse> listRepos_Pre($grpc.ServiceCall call, $async.Future<$1.ListReposRequest> request) async {
    return listRepos(call, await request);
  }

  $async.Future<$1.CreateRepoResponse> createRepo_Pre($grpc.ServiceCall call, $async.Future<$1.CreateRepoRequest> request) async {
    return createRepo(call, await request);
  }

  $async.Future<$1.UpdateRepoResponse> updateRepo_Pre($grpc.ServiceCall call, $async.Future<$1.UpdateRepoRequest> request) async {
    return updateRepo(call, await request);
  }

  $async.Future<$1.DeleteRepoResponse> deleteRepo_Pre($grpc.ServiceCall call, $async.Future<$1.DeleteRepoRequest> request) async {
    return deleteRepo(call, await request);
  }

  $async.Future<$1.TestRepoResponse> testRepo_Pre($grpc.ServiceCall call, $async.Future<$1.TestRepoRequest> request) async {
    return testRepo(call, await request);
  }

  $async.Future<$0.ListFilesResponse> list($grpc.ServiceCall call, $0.ListFilesRequest request);
  $async.Future<$0.MoveFileResponse> move($grpc.ServiceCall call, $0.MoveFileRequest request);
  $async.Future<$0.CopyFileResponse> copy($grpc.ServiceCall call, $0.CopyFileRequest request);
  $async.Future<$0.MkdirFileResponse> mkdir($grpc.ServiceCall call, $0.MkdirFileRequest request);
  $async.Future<$0.RenameFileResponse> rename($grpc.ServiceCall call, $0.RenameFileRequest request);
  $async.Future<$0.RemoveFileResponse> remove($grpc.ServiceCall call, $0.RemoveFileRequest request);
  $async.Future<$0.FileResponse> upload($grpc.ServiceCall call, $async.Stream<$0.FileRequest> request);
  $async.Stream<$0.DownloadFileResponse> download($grpc.ServiceCall call, $0.DownloadFileRequest request);
  $async.Stream<$0.PreviewFileResponse> preview($grpc.ServiceCall call, $0.PreviewFileRequest request);
  $async.Future<$1.ListReposResponse> listRepos($grpc.ServiceCall call, $1.ListReposRequest request);
  $async.Future<$1.CreateRepoResponse> createRepo($grpc.ServiceCall call, $1.CreateRepoRequest request);
  $async.Future<$1.UpdateRepoResponse> updateRepo($grpc.ServiceCall call, $1.UpdateRepoRequest request);
  $async.Future<$1.DeleteRepoResponse> deleteRepo($grpc.ServiceCall call, $1.DeleteRepoRequest request);
  $async.Future<$1.TestRepoResponse> testRepo($grpc.ServiceCall call, $1.TestRepoRequest request);
}

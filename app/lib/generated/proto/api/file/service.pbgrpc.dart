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

import 'file.pb.dart' as $1;
import 'repo.pb.dart' as $2;

export 'service.pb.dart';

@$pb.GrpcServiceName('api.file.FileService')
class FileServiceClient extends $grpc.Client {
  static final _$list = $grpc.ClientMethod<$1.ListFilesRequest, $1.ListFilesResponse>(
      '/api.file.FileService/List',
      ($1.ListFilesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.ListFilesResponse.fromBuffer(value));
  static final _$move = $grpc.ClientMethod<$1.MoveFileRequest, $1.MoveFileResponse>(
      '/api.file.FileService/Move',
      ($1.MoveFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.MoveFileResponse.fromBuffer(value));
  static final _$copy = $grpc.ClientMethod<$1.CopyFileRequest, $1.CopyFileResponse>(
      '/api.file.FileService/Copy',
      ($1.CopyFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.CopyFileResponse.fromBuffer(value));
  static final _$mkdir = $grpc.ClientMethod<$1.MkdirFileRequest, $1.MkdirFileResponse>(
      '/api.file.FileService/Mkdir',
      ($1.MkdirFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.MkdirFileResponse.fromBuffer(value));
  static final _$rename = $grpc.ClientMethod<$1.RenameFileRequest, $1.RenameFileResponse>(
      '/api.file.FileService/Rename',
      ($1.RenameFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.RenameFileResponse.fromBuffer(value));
  static final _$remove = $grpc.ClientMethod<$1.RemoveFileRequest, $1.RemoveFileResponse>(
      '/api.file.FileService/Remove',
      ($1.RemoveFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.RemoveFileResponse.fromBuffer(value));
  static final _$upload = $grpc.ClientMethod<$1.FileRequest, $1.FileResponse>(
      '/api.file.FileService/Upload',
      ($1.FileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.FileResponse.fromBuffer(value));
  static final _$download = $grpc.ClientMethod<$1.DownloadFileRequest, $1.DownloadFileResponse>(
      '/api.file.FileService/Download',
      ($1.DownloadFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.DownloadFileResponse.fromBuffer(value));
  static final _$preview = $grpc.ClientMethod<$1.PreviewFileRequest, $1.PreviewFileResponse>(
      '/api.file.FileService/Preview',
      ($1.PreviewFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.PreviewFileResponse.fromBuffer(value));
  static final _$listRepos = $grpc.ClientMethod<$2.ListReposRequest, $2.ListReposResponse>(
      '/api.file.FileService/ListRepos',
      ($2.ListReposRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.ListReposResponse.fromBuffer(value));
  static final _$createRepo = $grpc.ClientMethod<$2.CreateRepoRequest, $2.CreateRepoResponse>(
      '/api.file.FileService/CreateRepo',
      ($2.CreateRepoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.CreateRepoResponse.fromBuffer(value));
  static final _$updateRepo = $grpc.ClientMethod<$2.UpdateRepoRequest, $2.UpdateRepoResponse>(
      '/api.file.FileService/UpdateRepo',
      ($2.UpdateRepoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.UpdateRepoResponse.fromBuffer(value));
  static final _$deleteRepo = $grpc.ClientMethod<$2.DeleteRepoRequest, $2.DeleteRepoResponse>(
      '/api.file.FileService/DeleteRepo',
      ($2.DeleteRepoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.DeleteRepoResponse.fromBuffer(value));
  static final _$testRepo = $grpc.ClientMethod<$2.TestRepoRequest, $2.TestRepoResponse>(
      '/api.file.FileService/TestRepo',
      ($2.TestRepoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.TestRepoResponse.fromBuffer(value));

  FileServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$1.ListFilesResponse> list($1.ListFilesRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$list, request, options: options);
  }

  $grpc.ResponseFuture<$1.MoveFileResponse> move($1.MoveFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$move, request, options: options);
  }

  $grpc.ResponseFuture<$1.CopyFileResponse> copy($1.CopyFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$copy, request, options: options);
  }

  $grpc.ResponseFuture<$1.MkdirFileResponse> mkdir($1.MkdirFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$mkdir, request, options: options);
  }

  $grpc.ResponseFuture<$1.RenameFileResponse> rename($1.RenameFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$rename, request, options: options);
  }

  $grpc.ResponseFuture<$1.RemoveFileResponse> remove($1.RemoveFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$remove, request, options: options);
  }

  $grpc.ResponseFuture<$1.FileResponse> upload($async.Stream<$1.FileRequest> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$upload, request, options: options).single;
  }

  $grpc.ResponseStream<$1.DownloadFileResponse> download($1.DownloadFileRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$download, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseStream<$1.PreviewFileResponse> preview($1.PreviewFileRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$preview, $async.Stream.fromIterable([request]), options: options);
  }

  $grpc.ResponseFuture<$2.ListReposResponse> listRepos($2.ListReposRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listRepos, request, options: options);
  }

  $grpc.ResponseFuture<$2.CreateRepoResponse> createRepo($2.CreateRepoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createRepo, request, options: options);
  }

  $grpc.ResponseFuture<$2.UpdateRepoResponse> updateRepo($2.UpdateRepoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateRepo, request, options: options);
  }

  $grpc.ResponseFuture<$2.DeleteRepoResponse> deleteRepo($2.DeleteRepoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteRepo, request, options: options);
  }

  $grpc.ResponseFuture<$2.TestRepoResponse> testRepo($2.TestRepoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$testRepo, request, options: options);
  }
}

@$pb.GrpcServiceName('api.file.FileService')
abstract class FileServiceBase extends $grpc.Service {
  $core.String get $name => 'api.file.FileService';

  FileServiceBase() {
    $addMethod($grpc.ServiceMethod<$1.ListFilesRequest, $1.ListFilesResponse>(
        'List',
        list_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.ListFilesRequest.fromBuffer(value),
        ($1.ListFilesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MoveFileRequest, $1.MoveFileResponse>(
        'Move',
        move_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.MoveFileRequest.fromBuffer(value),
        ($1.MoveFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.CopyFileRequest, $1.CopyFileResponse>(
        'Copy',
        copy_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.CopyFileRequest.fromBuffer(value),
        ($1.CopyFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.MkdirFileRequest, $1.MkdirFileResponse>(
        'Mkdir',
        mkdir_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.MkdirFileRequest.fromBuffer(value),
        ($1.MkdirFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.RenameFileRequest, $1.RenameFileResponse>(
        'Rename',
        rename_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.RenameFileRequest.fromBuffer(value),
        ($1.RenameFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.RemoveFileRequest, $1.RemoveFileResponse>(
        'Remove',
        remove_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.RemoveFileRequest.fromBuffer(value),
        ($1.RemoveFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.FileRequest, $1.FileResponse>(
        'Upload',
        upload,
        true,
        false,
        ($core.List<$core.int> value) => $1.FileRequest.fromBuffer(value),
        ($1.FileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.DownloadFileRequest, $1.DownloadFileResponse>(
        'Download',
        download_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $1.DownloadFileRequest.fromBuffer(value),
        ($1.DownloadFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.PreviewFileRequest, $1.PreviewFileResponse>(
        'Preview',
        preview_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $1.PreviewFileRequest.fromBuffer(value),
        ($1.PreviewFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.ListReposRequest, $2.ListReposResponse>(
        'ListRepos',
        listRepos_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.ListReposRequest.fromBuffer(value),
        ($2.ListReposResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.CreateRepoRequest, $2.CreateRepoResponse>(
        'CreateRepo',
        createRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.CreateRepoRequest.fromBuffer(value),
        ($2.CreateRepoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.UpdateRepoRequest, $2.UpdateRepoResponse>(
        'UpdateRepo',
        updateRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.UpdateRepoRequest.fromBuffer(value),
        ($2.UpdateRepoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.DeleteRepoRequest, $2.DeleteRepoResponse>(
        'DeleteRepo',
        deleteRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.DeleteRepoRequest.fromBuffer(value),
        ($2.DeleteRepoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.TestRepoRequest, $2.TestRepoResponse>(
        'TestRepo',
        testRepo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.TestRepoRequest.fromBuffer(value),
        ($2.TestRepoResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.ListFilesResponse> list_Pre($grpc.ServiceCall call, $async.Future<$1.ListFilesRequest> request) async {
    return list(call, await request);
  }

  $async.Future<$1.MoveFileResponse> move_Pre($grpc.ServiceCall call, $async.Future<$1.MoveFileRequest> request) async {
    return move(call, await request);
  }

  $async.Future<$1.CopyFileResponse> copy_Pre($grpc.ServiceCall call, $async.Future<$1.CopyFileRequest> request) async {
    return copy(call, await request);
  }

  $async.Future<$1.MkdirFileResponse> mkdir_Pre($grpc.ServiceCall call, $async.Future<$1.MkdirFileRequest> request) async {
    return mkdir(call, await request);
  }

  $async.Future<$1.RenameFileResponse> rename_Pre($grpc.ServiceCall call, $async.Future<$1.RenameFileRequest> request) async {
    return rename(call, await request);
  }

  $async.Future<$1.RemoveFileResponse> remove_Pre($grpc.ServiceCall call, $async.Future<$1.RemoveFileRequest> request) async {
    return remove(call, await request);
  }

  $async.Stream<$1.DownloadFileResponse> download_Pre($grpc.ServiceCall call, $async.Future<$1.DownloadFileRequest> request) async* {
    yield* download(call, await request);
  }

  $async.Stream<$1.PreviewFileResponse> preview_Pre($grpc.ServiceCall call, $async.Future<$1.PreviewFileRequest> request) async* {
    yield* preview(call, await request);
  }

  $async.Future<$2.ListReposResponse> listRepos_Pre($grpc.ServiceCall call, $async.Future<$2.ListReposRequest> request) async {
    return listRepos(call, await request);
  }

  $async.Future<$2.CreateRepoResponse> createRepo_Pre($grpc.ServiceCall call, $async.Future<$2.CreateRepoRequest> request) async {
    return createRepo(call, await request);
  }

  $async.Future<$2.UpdateRepoResponse> updateRepo_Pre($grpc.ServiceCall call, $async.Future<$2.UpdateRepoRequest> request) async {
    return updateRepo(call, await request);
  }

  $async.Future<$2.DeleteRepoResponse> deleteRepo_Pre($grpc.ServiceCall call, $async.Future<$2.DeleteRepoRequest> request) async {
    return deleteRepo(call, await request);
  }

  $async.Future<$2.TestRepoResponse> testRepo_Pre($grpc.ServiceCall call, $async.Future<$2.TestRepoRequest> request) async {
    return testRepo(call, await request);
  }

  $async.Future<$1.ListFilesResponse> list($grpc.ServiceCall call, $1.ListFilesRequest request);
  $async.Future<$1.MoveFileResponse> move($grpc.ServiceCall call, $1.MoveFileRequest request);
  $async.Future<$1.CopyFileResponse> copy($grpc.ServiceCall call, $1.CopyFileRequest request);
  $async.Future<$1.MkdirFileResponse> mkdir($grpc.ServiceCall call, $1.MkdirFileRequest request);
  $async.Future<$1.RenameFileResponse> rename($grpc.ServiceCall call, $1.RenameFileRequest request);
  $async.Future<$1.RemoveFileResponse> remove($grpc.ServiceCall call, $1.RemoveFileRequest request);
  $async.Future<$1.FileResponse> upload($grpc.ServiceCall call, $async.Stream<$1.FileRequest> request);
  $async.Stream<$1.DownloadFileResponse> download($grpc.ServiceCall call, $1.DownloadFileRequest request);
  $async.Stream<$1.PreviewFileResponse> preview($grpc.ServiceCall call, $1.PreviewFileRequest request);
  $async.Future<$2.ListReposResponse> listRepos($grpc.ServiceCall call, $2.ListReposRequest request);
  $async.Future<$2.CreateRepoResponse> createRepo($grpc.ServiceCall call, $2.CreateRepoRequest request);
  $async.Future<$2.UpdateRepoResponse> updateRepo($grpc.ServiceCall call, $2.UpdateRepoRequest request);
  $async.Future<$2.DeleteRepoResponse> deleteRepo($grpc.ServiceCall call, $2.DeleteRepoRequest request);
  $async.Future<$2.TestRepoResponse> testRepo($grpc.ServiceCall call, $2.TestRepoRequest request);
}

//
//  Generated code. Do not modify.
//  source: api/file/file.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $2;
import 'repo.pb.dart' as $1;

class File extends $pb.GeneratedMessage {
  factory File({
    $core.int? id,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
    $core.String? name,
    $core.String? type,
    $core.int? size,
    $core.String? hash,
    $core.String? path,
    $1.Repo? repo,
    $core.int? repoId,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (name != null) {
      $result.name = name;
    }
    if (type != null) {
      $result.type = type;
    }
    if (size != null) {
      $result.size = size;
    }
    if (hash != null) {
      $result.hash = hash;
    }
    if (path != null) {
      $result.path = path;
    }
    if (repo != null) {
      $result.repo = repo;
    }
    if (repoId != null) {
      $result.repoId = repoId;
    }
    return $result;
  }
  File._() : super();
  factory File.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'createdAt', subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(3, _omitFieldNames ? '' : 'updatedAt', subBuilder: $2.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'type')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'size', $pb.PbFieldType.O3)
    ..aOS(7, _omitFieldNames ? '' : 'hash')
    ..aOS(8, _omitFieldNames ? '' : 'path')
    ..aOM<$1.Repo>(10, _omitFieldNames ? '' : 'repo', subBuilder: $1.Repo.create)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'repoId', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File clone() => File()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File copyWith(void Function(File) updates) => super.copyWith((message) => updates(message as File)) as File;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File create() => File._();
  File createEmptyInstance() => create();
  static $pb.PbList<File> createRepeated() => $pb.PbList<File>();
  @$core.pragma('dart2js:noInline')
  static File getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File>(create);
  static File? _defaultInstance;

  /// @gotags: gorm:"primary_key;auto_increment"
  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(2)
  $2.Timestamp get createdAt => $_getN(1);
  @$pb.TagNumber(2)
  set createdAt($2.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureCreatedAt() => $_ensure(1);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(3)
  $2.Timestamp get updatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set updatedAt($2.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatedAt() => clearField(3);
  @$pb.TagNumber(3)
  $2.Timestamp ensureUpdatedAt() => $_ensure(2);

  /// @gotags: gorm:"not null;"
  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get type => $_getSZ(4);
  @$pb.TagNumber(5)
  set type($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get size => $_getIZ(5);
  @$pb.TagNumber(6)
  set size($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSize() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get hash => $_getSZ(6);
  @$pb.TagNumber(7)
  set hash($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasHash() => $_has(6);
  @$pb.TagNumber(7)
  void clearHash() => clearField(7);

  /// @gotags: gorm:"not null;"
  @$pb.TagNumber(8)
  $core.String get path => $_getSZ(7);
  @$pb.TagNumber(8)
  set path($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPath() => $_has(7);
  @$pb.TagNumber(8)
  void clearPath() => clearField(8);

  @$pb.TagNumber(10)
  $1.Repo get repo => $_getN(8);
  @$pb.TagNumber(10)
  set repo($1.Repo v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasRepo() => $_has(8);
  @$pb.TagNumber(10)
  void clearRepo() => clearField(10);
  @$pb.TagNumber(10)
  $1.Repo ensureRepo() => $_ensure(8);

  /// @gotags: gorm:"not null"
  @$pb.TagNumber(11)
  $core.int get repoId => $_getIZ(9);
  @$pb.TagNumber(11)
  set repoId($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(11)
  $core.bool hasRepoId() => $_has(9);
  @$pb.TagNumber(11)
  void clearRepoId() => clearField(11);
}

class FileRequest extends $pb.GeneratedMessage {
  factory FileRequest({
    $core.int? index,
    $core.List<$core.int>? chunk,
    $core.String? path,
    $core.String? filename,
    $core.int? size,
  }) {
    final $result = create();
    if (index != null) {
      $result.index = index;
    }
    if (chunk != null) {
      $result.chunk = chunk;
    }
    if (path != null) {
      $result.path = path;
    }
    if (filename != null) {
      $result.filename = filename;
    }
    if (size != null) {
      $result.size = size;
    }
    return $result;
  }
  FileRequest._() : super();
  factory FileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'index', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'chunk', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'path')
    ..aOS(4, _omitFieldNames ? '' : 'filename')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'size', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileRequest clone() => FileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileRequest copyWith(void Function(FileRequest) updates) => super.copyWith((message) => updates(message as FileRequest)) as FileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileRequest create() => FileRequest._();
  FileRequest createEmptyInstance() => create();
  static $pb.PbList<FileRequest> createRepeated() => $pb.PbList<FileRequest>();
  @$core.pragma('dart2js:noInline')
  static FileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileRequest>(create);
  static FileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get chunk => $_getN(1);
  @$pb.TagNumber(2)
  set chunk($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChunk() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunk() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get path => $_getSZ(2);
  @$pb.TagNumber(3)
  set path($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPath() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get filename => $_getSZ(3);
  @$pb.TagNumber(4)
  set filename($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFilename() => $_has(3);
  @$pb.TagNumber(4)
  void clearFilename() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get size => $_getIZ(4);
  @$pb.TagNumber(5)
  set size($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearSize() => clearField(5);
}

class FileResponse extends $pb.GeneratedMessage {
  factory FileResponse({
    File? result,
    $core.String? message,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  FileResponse._() : super();
  factory FileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<File>(1, _omitFieldNames ? '' : 'result', subBuilder: File.create)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileResponse clone() => FileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileResponse copyWith(void Function(FileResponse) updates) => super.copyWith((message) => updates(message as FileResponse)) as FileResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileResponse create() => FileResponse._();
  FileResponse createEmptyInstance() => create();
  static $pb.PbList<FileResponse> createRepeated() => $pb.PbList<FileResponse>();
  @$core.pragma('dart2js:noInline')
  static FileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileResponse>(create);
  static FileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  File get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(File v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  File ensureResult() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class ListFilesRequest extends $pb.GeneratedMessage {
  factory ListFilesRequest({
    $core.int? pageNum,
    $core.String? pageToken,
    $core.String? path,
  }) {
    final $result = create();
    if (pageNum != null) {
      $result.pageNum = pageNum;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    if (path != null) {
      $result.path = path;
    }
    return $result;
  }
  ListFilesRequest._() : super();
  factory ListFilesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFilesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListFilesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'pageNum', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'pageToken')
    ..aOS(3, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFilesRequest clone() => ListFilesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFilesRequest copyWith(void Function(ListFilesRequest) updates) => super.copyWith((message) => updates(message as ListFilesRequest)) as ListFilesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFilesRequest create() => ListFilesRequest._();
  ListFilesRequest createEmptyInstance() => create();
  static $pb.PbList<ListFilesRequest> createRepeated() => $pb.PbList<ListFilesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListFilesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFilesRequest>(create);
  static ListFilesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageNum => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageNum($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPageNum() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageNum() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get path => $_getSZ(2);
  @$pb.TagNumber(3)
  set path($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPath() => clearField(3);
}

class ListFilesResponse extends $pb.GeneratedMessage {
  factory ListFilesResponse({
    $core.Iterable<File>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  ListFilesResponse._() : super();
  factory ListFilesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFilesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListFilesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..pc<File>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: File.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFilesResponse clone() => ListFilesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFilesResponse copyWith(void Function(ListFilesResponse) updates) => super.copyWith((message) => updates(message as ListFilesResponse)) as ListFilesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFilesResponse create() => ListFilesResponse._();
  ListFilesResponse createEmptyInstance() => create();
  static $pb.PbList<ListFilesResponse> createRepeated() => $pb.PbList<ListFilesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListFilesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFilesResponse>(create);
  static ListFilesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<File> get results => $_getList(0);
}

class MoveFileRequest extends $pb.GeneratedMessage {
  factory MoveFileRequest({
    $core.String? path,
    $core.String? newPath,
    $core.Iterable<$core.String>? names,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (newPath != null) {
      $result.newPath = newPath;
    }
    if (names != null) {
      $result.names.addAll(names);
    }
    return $result;
  }
  MoveFileRequest._() : super();
  factory MoveFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MoveFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MoveFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'newPath')
    ..pPS(3, _omitFieldNames ? '' : 'names')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MoveFileRequest clone() => MoveFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MoveFileRequest copyWith(void Function(MoveFileRequest) updates) => super.copyWith((message) => updates(message as MoveFileRequest)) as MoveFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveFileRequest create() => MoveFileRequest._();
  MoveFileRequest createEmptyInstance() => create();
  static $pb.PbList<MoveFileRequest> createRepeated() => $pb.PbList<MoveFileRequest>();
  @$core.pragma('dart2js:noInline')
  static MoveFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveFileRequest>(create);
  static MoveFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get newPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set newPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNewPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get names => $_getList(2);
}

class MoveFileResponse extends $pb.GeneratedMessage {
  factory MoveFileResponse() => create();
  MoveFileResponse._() : super();
  factory MoveFileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MoveFileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MoveFileResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MoveFileResponse clone() => MoveFileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MoveFileResponse copyWith(void Function(MoveFileResponse) updates) => super.copyWith((message) => updates(message as MoveFileResponse)) as MoveFileResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveFileResponse create() => MoveFileResponse._();
  MoveFileResponse createEmptyInstance() => create();
  static $pb.PbList<MoveFileResponse> createRepeated() => $pb.PbList<MoveFileResponse>();
  @$core.pragma('dart2js:noInline')
  static MoveFileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveFileResponse>(create);
  static MoveFileResponse? _defaultInstance;
}

class CopyFileRequest extends $pb.GeneratedMessage {
  factory CopyFileRequest({
    $core.String? path,
    $core.String? newPath,
    $core.Iterable<$core.String>? names,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (newPath != null) {
      $result.newPath = newPath;
    }
    if (names != null) {
      $result.names.addAll(names);
    }
    return $result;
  }
  CopyFileRequest._() : super();
  factory CopyFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CopyFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CopyFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'newPath')
    ..pPS(3, _omitFieldNames ? '' : 'names')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CopyFileRequest clone() => CopyFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CopyFileRequest copyWith(void Function(CopyFileRequest) updates) => super.copyWith((message) => updates(message as CopyFileRequest)) as CopyFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CopyFileRequest create() => CopyFileRequest._();
  CopyFileRequest createEmptyInstance() => create();
  static $pb.PbList<CopyFileRequest> createRepeated() => $pb.PbList<CopyFileRequest>();
  @$core.pragma('dart2js:noInline')
  static CopyFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CopyFileRequest>(create);
  static CopyFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get newPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set newPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNewPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get names => $_getList(2);
}

class CopyFileResponse extends $pb.GeneratedMessage {
  factory CopyFileResponse() => create();
  CopyFileResponse._() : super();
  factory CopyFileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CopyFileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CopyFileResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CopyFileResponse clone() => CopyFileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CopyFileResponse copyWith(void Function(CopyFileResponse) updates) => super.copyWith((message) => updates(message as CopyFileResponse)) as CopyFileResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CopyFileResponse create() => CopyFileResponse._();
  CopyFileResponse createEmptyInstance() => create();
  static $pb.PbList<CopyFileResponse> createRepeated() => $pb.PbList<CopyFileResponse>();
  @$core.pragma('dart2js:noInline')
  static CopyFileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CopyFileResponse>(create);
  static CopyFileResponse? _defaultInstance;
}

class MkdirFileRequest extends $pb.GeneratedMessage {
  factory MkdirFileRequest({
    $core.String? path,
    $core.String? name,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  MkdirFileRequest._() : super();
  factory MkdirFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MkdirFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MkdirFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MkdirFileRequest clone() => MkdirFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MkdirFileRequest copyWith(void Function(MkdirFileRequest) updates) => super.copyWith((message) => updates(message as MkdirFileRequest)) as MkdirFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MkdirFileRequest create() => MkdirFileRequest._();
  MkdirFileRequest createEmptyInstance() => create();
  static $pb.PbList<MkdirFileRequest> createRepeated() => $pb.PbList<MkdirFileRequest>();
  @$core.pragma('dart2js:noInline')
  static MkdirFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MkdirFileRequest>(create);
  static MkdirFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class MkdirFileResponse extends $pb.GeneratedMessage {
  factory MkdirFileResponse() => create();
  MkdirFileResponse._() : super();
  factory MkdirFileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MkdirFileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MkdirFileResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MkdirFileResponse clone() => MkdirFileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MkdirFileResponse copyWith(void Function(MkdirFileResponse) updates) => super.copyWith((message) => updates(message as MkdirFileResponse)) as MkdirFileResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MkdirFileResponse create() => MkdirFileResponse._();
  MkdirFileResponse createEmptyInstance() => create();
  static $pb.PbList<MkdirFileResponse> createRepeated() => $pb.PbList<MkdirFileResponse>();
  @$core.pragma('dart2js:noInline')
  static MkdirFileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MkdirFileResponse>(create);
  static MkdirFileResponse? _defaultInstance;
}

class RenameFileRequest extends $pb.GeneratedMessage {
  factory RenameFileRequest({
    $core.String? path,
    $core.String? name,
    $core.String? newName,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (name != null) {
      $result.name = name;
    }
    if (newName != null) {
      $result.newName = newName;
    }
    return $result;
  }
  RenameFileRequest._() : super();
  factory RenameFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RenameFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RenameFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'newName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RenameFileRequest clone() => RenameFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RenameFileRequest copyWith(void Function(RenameFileRequest) updates) => super.copyWith((message) => updates(message as RenameFileRequest)) as RenameFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameFileRequest create() => RenameFileRequest._();
  RenameFileRequest createEmptyInstance() => create();
  static $pb.PbList<RenameFileRequest> createRepeated() => $pb.PbList<RenameFileRequest>();
  @$core.pragma('dart2js:noInline')
  static RenameFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RenameFileRequest>(create);
  static RenameFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get newName => $_getSZ(2);
  @$pb.TagNumber(3)
  set newName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNewName() => $_has(2);
  @$pb.TagNumber(3)
  void clearNewName() => clearField(3);
}

class RenameFileResponse extends $pb.GeneratedMessage {
  factory RenameFileResponse() => create();
  RenameFileResponse._() : super();
  factory RenameFileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RenameFileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RenameFileResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RenameFileResponse clone() => RenameFileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RenameFileResponse copyWith(void Function(RenameFileResponse) updates) => super.copyWith((message) => updates(message as RenameFileResponse)) as RenameFileResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenameFileResponse create() => RenameFileResponse._();
  RenameFileResponse createEmptyInstance() => create();
  static $pb.PbList<RenameFileResponse> createRepeated() => $pb.PbList<RenameFileResponse>();
  @$core.pragma('dart2js:noInline')
  static RenameFileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RenameFileResponse>(create);
  static RenameFileResponse? _defaultInstance;
}

class RemoveFileRequest extends $pb.GeneratedMessage {
  factory RemoveFileRequest({
    $core.String? path,
    $core.Iterable<$core.String>? names,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    if (names != null) {
      $result.names.addAll(names);
    }
    return $result;
  }
  RemoveFileRequest._() : super();
  factory RemoveFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..pPS(3, _omitFieldNames ? '' : 'names')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveFileRequest clone() => RemoveFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveFileRequest copyWith(void Function(RemoveFileRequest) updates) => super.copyWith((message) => updates(message as RemoveFileRequest)) as RemoveFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveFileRequest create() => RemoveFileRequest._();
  RemoveFileRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveFileRequest> createRepeated() => $pb.PbList<RemoveFileRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveFileRequest>(create);
  static RemoveFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(3)
  $core.List<$core.String> get names => $_getList(1);
}

class RemoveFileResponse extends $pb.GeneratedMessage {
  factory RemoveFileResponse() => create();
  RemoveFileResponse._() : super();
  factory RemoveFileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveFileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveFileResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveFileResponse clone() => RemoveFileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveFileResponse copyWith(void Function(RemoveFileResponse) updates) => super.copyWith((message) => updates(message as RemoveFileResponse)) as RemoveFileResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveFileResponse create() => RemoveFileResponse._();
  RemoveFileResponse createEmptyInstance() => create();
  static $pb.PbList<RemoveFileResponse> createRepeated() => $pb.PbList<RemoveFileResponse>();
  @$core.pragma('dart2js:noInline')
  static RemoveFileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveFileResponse>(create);
  static RemoveFileResponse? _defaultInstance;
}

class UploadFileRequest extends $pb.GeneratedMessage {
  factory UploadFileRequest() => create();
  UploadFileRequest._() : super();
  factory UploadFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadFileRequest clone() => UploadFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadFileRequest copyWith(void Function(UploadFileRequest) updates) => super.copyWith((message) => updates(message as UploadFileRequest)) as UploadFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadFileRequest create() => UploadFileRequest._();
  UploadFileRequest createEmptyInstance() => create();
  static $pb.PbList<UploadFileRequest> createRepeated() => $pb.PbList<UploadFileRequest>();
  @$core.pragma('dart2js:noInline')
  static UploadFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadFileRequest>(create);
  static UploadFileRequest? _defaultInstance;
}

class PreviewFileRequest extends $pb.GeneratedMessage {
  factory PreviewFileRequest({
    $core.String? path,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    return $result;
  }
  PreviewFileRequest._() : super();
  factory PreviewFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PreviewFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PreviewFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PreviewFileRequest clone() => PreviewFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PreviewFileRequest copyWith(void Function(PreviewFileRequest) updates) => super.copyWith((message) => updates(message as PreviewFileRequest)) as PreviewFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreviewFileRequest create() => PreviewFileRequest._();
  PreviewFileRequest createEmptyInstance() => create();
  static $pb.PbList<PreviewFileRequest> createRepeated() => $pb.PbList<PreviewFileRequest>();
  @$core.pragma('dart2js:noInline')
  static PreviewFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PreviewFileRequest>(create);
  static PreviewFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);
}

class PreviewFileResponse extends $pb.GeneratedMessage {
  factory PreviewFileResponse({
    $core.List<$core.int>? chunk,
  }) {
    final $result = create();
    if (chunk != null) {
      $result.chunk = chunk;
    }
    return $result;
  }
  PreviewFileResponse._() : super();
  factory PreviewFileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PreviewFileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PreviewFileResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chunk', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PreviewFileResponse clone() => PreviewFileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PreviewFileResponse copyWith(void Function(PreviewFileResponse) updates) => super.copyWith((message) => updates(message as PreviewFileResponse)) as PreviewFileResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreviewFileResponse create() => PreviewFileResponse._();
  PreviewFileResponse createEmptyInstance() => create();
  static $pb.PbList<PreviewFileResponse> createRepeated() => $pb.PbList<PreviewFileResponse>();
  @$core.pragma('dart2js:noInline')
  static PreviewFileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PreviewFileResponse>(create);
  static PreviewFileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chunk => $_getN(0);
  @$pb.TagNumber(1)
  set chunk($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChunk() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunk() => clearField(1);
}

class DownloadFileRequest extends $pb.GeneratedMessage {
  factory DownloadFileRequest({
    $core.String? path,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    return $result;
  }
  DownloadFileRequest._() : super();
  factory DownloadFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DownloadFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DownloadFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DownloadFileRequest clone() => DownloadFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DownloadFileRequest copyWith(void Function(DownloadFileRequest) updates) => super.copyWith((message) => updates(message as DownloadFileRequest)) as DownloadFileRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadFileRequest create() => DownloadFileRequest._();
  DownloadFileRequest createEmptyInstance() => create();
  static $pb.PbList<DownloadFileRequest> createRepeated() => $pb.PbList<DownloadFileRequest>();
  @$core.pragma('dart2js:noInline')
  static DownloadFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DownloadFileRequest>(create);
  static DownloadFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);
}

class DownloadFileResponse extends $pb.GeneratedMessage {
  factory DownloadFileResponse({
    $core.List<$core.int>? chunk,
  }) {
    final $result = create();
    if (chunk != null) {
      $result.chunk = chunk;
    }
    return $result;
  }
  DownloadFileResponse._() : super();
  factory DownloadFileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DownloadFileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DownloadFileResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chunk', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DownloadFileResponse clone() => DownloadFileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DownloadFileResponse copyWith(void Function(DownloadFileResponse) updates) => super.copyWith((message) => updates(message as DownloadFileResponse)) as DownloadFileResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadFileResponse create() => DownloadFileResponse._();
  DownloadFileResponse createEmptyInstance() => create();
  static $pb.PbList<DownloadFileResponse> createRepeated() => $pb.PbList<DownloadFileResponse>();
  @$core.pragma('dart2js:noInline')
  static DownloadFileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DownloadFileResponse>(create);
  static DownloadFileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chunk => $_getN(0);
  @$pb.TagNumber(1)
  set chunk($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChunk() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunk() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');

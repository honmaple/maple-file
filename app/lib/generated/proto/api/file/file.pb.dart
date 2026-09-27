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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $3;
import 'file.pbenum.dart';
import 'repo.pb.dart' as $0;

export 'file.pbenum.dart';

class File_UploadRequest extends $pb.GeneratedMessage {
  factory File_UploadRequest({
    $core.int? index,
    $core.List<$core.int>? chunk,
    $core.String? path,
    $core.String? filename,
    $fixnum.Int64? size,
    File_UploadPolicy? uploadPolicy,
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
    if (uploadPolicy != null) {
      $result.uploadPolicy = uploadPolicy;
    }
    return $result;
  }
  File_UploadRequest._() : super();
  factory File_UploadRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_UploadRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.UploadRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'index', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'chunk', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'path')
    ..aOS(4, _omitFieldNames ? '' : 'filename')
    ..aInt64(5, _omitFieldNames ? '' : 'size')
    ..e<File_UploadPolicy>(6, _omitFieldNames ? '' : 'uploadPolicy', $pb.PbFieldType.OE, defaultOrMaker: File_UploadPolicy.UPLOAD_POLICY_INHERIT, valueOf: File_UploadPolicy.valueOf, enumValues: File_UploadPolicy.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_UploadRequest clone() => File_UploadRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_UploadRequest copyWith(void Function(File_UploadRequest) updates) => super.copyWith((message) => updates(message as File_UploadRequest)) as File_UploadRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_UploadRequest create() => File_UploadRequest._();
  File_UploadRequest createEmptyInstance() => create();
  static $pb.PbList<File_UploadRequest> createRepeated() => $pb.PbList<File_UploadRequest>();
  @$core.pragma('dart2js:noInline')
  static File_UploadRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_UploadRequest>(create);
  static File_UploadRequest? _defaultInstance;

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
  $fixnum.Int64 get size => $_getI64(4);
  @$pb.TagNumber(5)
  set size($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearSize() => clearField(5);

  /// Overrides the global upload policy when it is not INHERIT.
  @$pb.TagNumber(6)
  File_UploadPolicy get uploadPolicy => $_getN(5);
  @$pb.TagNumber(6)
  set uploadPolicy(File_UploadPolicy v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasUploadPolicy() => $_has(5);
  @$pb.TagNumber(6)
  void clearUploadPolicy() => clearField(6);
}

class File_UploadResponse extends $pb.GeneratedMessage {
  factory File_UploadResponse({
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
  File_UploadResponse._() : super();
  factory File_UploadResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_UploadResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.UploadResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<File>(1, _omitFieldNames ? '' : 'result', subBuilder: File.create)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_UploadResponse clone() => File_UploadResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_UploadResponse copyWith(void Function(File_UploadResponse) updates) => super.copyWith((message) => updates(message as File_UploadResponse)) as File_UploadResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_UploadResponse create() => File_UploadResponse._();
  File_UploadResponse createEmptyInstance() => create();
  static $pb.PbList<File_UploadResponse> createRepeated() => $pb.PbList<File_UploadResponse>();
  @$core.pragma('dart2js:noInline')
  static File_UploadResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_UploadResponse>(create);
  static File_UploadResponse? _defaultInstance;

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

class File_ListRequest extends $pb.GeneratedMessage {
  factory File_ListRequest({
    $core.Map<$core.String, $core.String>? filter,
  }) {
    final $result = create();
    if (filter != null) {
      $result.filter.addAll(filter);
    }
    return $result;
  }
  File_ListRequest._() : super();
  factory File_ListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_ListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.ListRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'filter', entryClassName: 'File.ListRequest.FilterEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('api.file'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_ListRequest clone() => File_ListRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_ListRequest copyWith(void Function(File_ListRequest) updates) => super.copyWith((message) => updates(message as File_ListRequest)) as File_ListRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_ListRequest create() => File_ListRequest._();
  File_ListRequest createEmptyInstance() => create();
  static $pb.PbList<File_ListRequest> createRepeated() => $pb.PbList<File_ListRequest>();
  @$core.pragma('dart2js:noInline')
  static File_ListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_ListRequest>(create);
  static File_ListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $core.String> get filter => $_getMap(0);
}

class File_ListResponse extends $pb.GeneratedMessage {
  factory File_ListResponse({
    $core.Iterable<File>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  File_ListResponse._() : super();
  factory File_ListResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_ListResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.ListResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..pc<File>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: File.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_ListResponse clone() => File_ListResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_ListResponse copyWith(void Function(File_ListResponse) updates) => super.copyWith((message) => updates(message as File_ListResponse)) as File_ListResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_ListResponse create() => File_ListResponse._();
  File_ListResponse createEmptyInstance() => create();
  static $pb.PbList<File_ListResponse> createRepeated() => $pb.PbList<File_ListResponse>();
  @$core.pragma('dart2js:noInline')
  static File_ListResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_ListResponse>(create);
  static File_ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<File> get results => $_getList(0);
}

class File_MoveRequest extends $pb.GeneratedMessage {
  factory File_MoveRequest({
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
  File_MoveRequest._() : super();
  factory File_MoveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_MoveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.MoveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'newPath')
    ..pPS(3, _omitFieldNames ? '' : 'names')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_MoveRequest clone() => File_MoveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_MoveRequest copyWith(void Function(File_MoveRequest) updates) => super.copyWith((message) => updates(message as File_MoveRequest)) as File_MoveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_MoveRequest create() => File_MoveRequest._();
  File_MoveRequest createEmptyInstance() => create();
  static $pb.PbList<File_MoveRequest> createRepeated() => $pb.PbList<File_MoveRequest>();
  @$core.pragma('dart2js:noInline')
  static File_MoveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_MoveRequest>(create);
  static File_MoveRequest? _defaultInstance;

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

class File_MoveResponse extends $pb.GeneratedMessage {
  factory File_MoveResponse() => create();
  File_MoveResponse._() : super();
  factory File_MoveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_MoveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.MoveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_MoveResponse clone() => File_MoveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_MoveResponse copyWith(void Function(File_MoveResponse) updates) => super.copyWith((message) => updates(message as File_MoveResponse)) as File_MoveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_MoveResponse create() => File_MoveResponse._();
  File_MoveResponse createEmptyInstance() => create();
  static $pb.PbList<File_MoveResponse> createRepeated() => $pb.PbList<File_MoveResponse>();
  @$core.pragma('dart2js:noInline')
  static File_MoveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_MoveResponse>(create);
  static File_MoveResponse? _defaultInstance;
}

class File_CopyRequest extends $pb.GeneratedMessage {
  factory File_CopyRequest({
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
  File_CopyRequest._() : super();
  factory File_CopyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_CopyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.CopyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'newPath')
    ..pPS(3, _omitFieldNames ? '' : 'names')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_CopyRequest clone() => File_CopyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_CopyRequest copyWith(void Function(File_CopyRequest) updates) => super.copyWith((message) => updates(message as File_CopyRequest)) as File_CopyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_CopyRequest create() => File_CopyRequest._();
  File_CopyRequest createEmptyInstance() => create();
  static $pb.PbList<File_CopyRequest> createRepeated() => $pb.PbList<File_CopyRequest>();
  @$core.pragma('dart2js:noInline')
  static File_CopyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_CopyRequest>(create);
  static File_CopyRequest? _defaultInstance;

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

class File_CopyResponse extends $pb.GeneratedMessage {
  factory File_CopyResponse() => create();
  File_CopyResponse._() : super();
  factory File_CopyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_CopyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.CopyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_CopyResponse clone() => File_CopyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_CopyResponse copyWith(void Function(File_CopyResponse) updates) => super.copyWith((message) => updates(message as File_CopyResponse)) as File_CopyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_CopyResponse create() => File_CopyResponse._();
  File_CopyResponse createEmptyInstance() => create();
  static $pb.PbList<File_CopyResponse> createRepeated() => $pb.PbList<File_CopyResponse>();
  @$core.pragma('dart2js:noInline')
  static File_CopyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_CopyResponse>(create);
  static File_CopyResponse? _defaultInstance;
}

class File_MkdirRequest extends $pb.GeneratedMessage {
  factory File_MkdirRequest({
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
  File_MkdirRequest._() : super();
  factory File_MkdirRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_MkdirRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.MkdirRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_MkdirRequest clone() => File_MkdirRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_MkdirRequest copyWith(void Function(File_MkdirRequest) updates) => super.copyWith((message) => updates(message as File_MkdirRequest)) as File_MkdirRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_MkdirRequest create() => File_MkdirRequest._();
  File_MkdirRequest createEmptyInstance() => create();
  static $pb.PbList<File_MkdirRequest> createRepeated() => $pb.PbList<File_MkdirRequest>();
  @$core.pragma('dart2js:noInline')
  static File_MkdirRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_MkdirRequest>(create);
  static File_MkdirRequest? _defaultInstance;

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

class File_MkdirResponse extends $pb.GeneratedMessage {
  factory File_MkdirResponse() => create();
  File_MkdirResponse._() : super();
  factory File_MkdirResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_MkdirResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.MkdirResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_MkdirResponse clone() => File_MkdirResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_MkdirResponse copyWith(void Function(File_MkdirResponse) updates) => super.copyWith((message) => updates(message as File_MkdirResponse)) as File_MkdirResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_MkdirResponse create() => File_MkdirResponse._();
  File_MkdirResponse createEmptyInstance() => create();
  static $pb.PbList<File_MkdirResponse> createRepeated() => $pb.PbList<File_MkdirResponse>();
  @$core.pragma('dart2js:noInline')
  static File_MkdirResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_MkdirResponse>(create);
  static File_MkdirResponse? _defaultInstance;
}

class File_RenameRequest extends $pb.GeneratedMessage {
  factory File_RenameRequest({
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
  File_RenameRequest._() : super();
  factory File_RenameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_RenameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.RenameRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'newName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_RenameRequest clone() => File_RenameRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_RenameRequest copyWith(void Function(File_RenameRequest) updates) => super.copyWith((message) => updates(message as File_RenameRequest)) as File_RenameRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_RenameRequest create() => File_RenameRequest._();
  File_RenameRequest createEmptyInstance() => create();
  static $pb.PbList<File_RenameRequest> createRepeated() => $pb.PbList<File_RenameRequest>();
  @$core.pragma('dart2js:noInline')
  static File_RenameRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_RenameRequest>(create);
  static File_RenameRequest? _defaultInstance;

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

class File_RenameResponse extends $pb.GeneratedMessage {
  factory File_RenameResponse() => create();
  File_RenameResponse._() : super();
  factory File_RenameResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_RenameResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.RenameResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_RenameResponse clone() => File_RenameResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_RenameResponse copyWith(void Function(File_RenameResponse) updates) => super.copyWith((message) => updates(message as File_RenameResponse)) as File_RenameResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_RenameResponse create() => File_RenameResponse._();
  File_RenameResponse createEmptyInstance() => create();
  static $pb.PbList<File_RenameResponse> createRepeated() => $pb.PbList<File_RenameResponse>();
  @$core.pragma('dart2js:noInline')
  static File_RenameResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_RenameResponse>(create);
  static File_RenameResponse? _defaultInstance;
}

class File_RemoveRequest extends $pb.GeneratedMessage {
  factory File_RemoveRequest({
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
  File_RemoveRequest._() : super();
  factory File_RemoveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_RemoveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.RemoveRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..pPS(3, _omitFieldNames ? '' : 'names')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_RemoveRequest clone() => File_RemoveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_RemoveRequest copyWith(void Function(File_RemoveRequest) updates) => super.copyWith((message) => updates(message as File_RemoveRequest)) as File_RemoveRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_RemoveRequest create() => File_RemoveRequest._();
  File_RemoveRequest createEmptyInstance() => create();
  static $pb.PbList<File_RemoveRequest> createRepeated() => $pb.PbList<File_RemoveRequest>();
  @$core.pragma('dart2js:noInline')
  static File_RemoveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_RemoveRequest>(create);
  static File_RemoveRequest? _defaultInstance;

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

class File_RemoveResponse extends $pb.GeneratedMessage {
  factory File_RemoveResponse() => create();
  File_RemoveResponse._() : super();
  factory File_RemoveResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_RemoveResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.RemoveResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_RemoveResponse clone() => File_RemoveResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_RemoveResponse copyWith(void Function(File_RemoveResponse) updates) => super.copyWith((message) => updates(message as File_RemoveResponse)) as File_RemoveResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_RemoveResponse create() => File_RemoveResponse._();
  File_RemoveResponse createEmptyInstance() => create();
  static $pb.PbList<File_RemoveResponse> createRepeated() => $pb.PbList<File_RemoveResponse>();
  @$core.pragma('dart2js:noInline')
  static File_RemoveResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_RemoveResponse>(create);
  static File_RemoveResponse? _defaultInstance;
}

class File_PreviewRequest extends $pb.GeneratedMessage {
  factory File_PreviewRequest({
    $core.String? path,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    return $result;
  }
  File_PreviewRequest._() : super();
  factory File_PreviewRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_PreviewRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.PreviewRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_PreviewRequest clone() => File_PreviewRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_PreviewRequest copyWith(void Function(File_PreviewRequest) updates) => super.copyWith((message) => updates(message as File_PreviewRequest)) as File_PreviewRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_PreviewRequest create() => File_PreviewRequest._();
  File_PreviewRequest createEmptyInstance() => create();
  static $pb.PbList<File_PreviewRequest> createRepeated() => $pb.PbList<File_PreviewRequest>();
  @$core.pragma('dart2js:noInline')
  static File_PreviewRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_PreviewRequest>(create);
  static File_PreviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);
}

class File_PreviewResponse extends $pb.GeneratedMessage {
  factory File_PreviewResponse({
    $core.List<$core.int>? chunk,
  }) {
    final $result = create();
    if (chunk != null) {
      $result.chunk = chunk;
    }
    return $result;
  }
  File_PreviewResponse._() : super();
  factory File_PreviewResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_PreviewResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.PreviewResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chunk', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_PreviewResponse clone() => File_PreviewResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_PreviewResponse copyWith(void Function(File_PreviewResponse) updates) => super.copyWith((message) => updates(message as File_PreviewResponse)) as File_PreviewResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_PreviewResponse create() => File_PreviewResponse._();
  File_PreviewResponse createEmptyInstance() => create();
  static $pb.PbList<File_PreviewResponse> createRepeated() => $pb.PbList<File_PreviewResponse>();
  @$core.pragma('dart2js:noInline')
  static File_PreviewResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_PreviewResponse>(create);
  static File_PreviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chunk => $_getN(0);
  @$pb.TagNumber(1)
  set chunk($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChunk() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunk() => clearField(1);
}

class File_DownloadRequest extends $pb.GeneratedMessage {
  factory File_DownloadRequest({
    $core.String? path,
  }) {
    final $result = create();
    if (path != null) {
      $result.path = path;
    }
    return $result;
  }
  File_DownloadRequest._() : super();
  factory File_DownloadRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_DownloadRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.DownloadRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'path')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_DownloadRequest clone() => File_DownloadRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_DownloadRequest copyWith(void Function(File_DownloadRequest) updates) => super.copyWith((message) => updates(message as File_DownloadRequest)) as File_DownloadRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_DownloadRequest create() => File_DownloadRequest._();
  File_DownloadRequest createEmptyInstance() => create();
  static $pb.PbList<File_DownloadRequest> createRepeated() => $pb.PbList<File_DownloadRequest>();
  @$core.pragma('dart2js:noInline')
  static File_DownloadRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_DownloadRequest>(create);
  static File_DownloadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);
}

class File_DownloadResponse extends $pb.GeneratedMessage {
  factory File_DownloadResponse({
    $core.List<$core.int>? chunk,
  }) {
    final $result = create();
    if (chunk != null) {
      $result.chunk = chunk;
    }
    return $result;
  }
  File_DownloadResponse._() : super();
  factory File_DownloadResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File_DownloadResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'File.DownloadResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'chunk', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File_DownloadResponse clone() => File_DownloadResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File_DownloadResponse copyWith(void Function(File_DownloadResponse) updates) => super.copyWith((message) => updates(message as File_DownloadResponse)) as File_DownloadResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File_DownloadResponse create() => File_DownloadResponse._();
  File_DownloadResponse createEmptyInstance() => create();
  static $pb.PbList<File_DownloadResponse> createRepeated() => $pb.PbList<File_DownloadResponse>();
  @$core.pragma('dart2js:noInline')
  static File_DownloadResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File_DownloadResponse>(create);
  static File_DownloadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get chunk => $_getN(0);
  @$pb.TagNumber(1)
  set chunk($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChunk() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunk() => clearField(1);
}

class File extends $pb.GeneratedMessage {
  factory File({
    $core.int? id,
    $3.Timestamp? createdAt,
    $3.Timestamp? updatedAt,
    $core.String? name,
    $core.String? type,
    $fixnum.Int64? size,
    $core.String? hash,
    $core.String? path,
    $0.Repo? repo,
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
    ..aOM<$3.Timestamp>(2, _omitFieldNames ? '' : 'createdAt', subBuilder: $3.Timestamp.create)
    ..aOM<$3.Timestamp>(3, _omitFieldNames ? '' : 'updatedAt', subBuilder: $3.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'type')
    ..aInt64(6, _omitFieldNames ? '' : 'size')
    ..aOS(7, _omitFieldNames ? '' : 'hash')
    ..aOS(8, _omitFieldNames ? '' : 'path')
    ..aOM<$0.Repo>(10, _omitFieldNames ? '' : 'repo', subBuilder: $0.Repo.create)
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
  $3.Timestamp get createdAt => $_getN(1);
  @$pb.TagNumber(2)
  set createdAt($3.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => clearField(2);
  @$pb.TagNumber(2)
  $3.Timestamp ensureCreatedAt() => $_ensure(1);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(3)
  $3.Timestamp get updatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set updatedAt($3.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatedAt() => clearField(3);
  @$pb.TagNumber(3)
  $3.Timestamp ensureUpdatedAt() => $_ensure(2);

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
  $fixnum.Int64 get size => $_getI64(5);
  @$pb.TagNumber(6)
  set size($fixnum.Int64 v) { $_setInt64(5, v); }
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
  $0.Repo get repo => $_getN(8);
  @$pb.TagNumber(10)
  set repo($0.Repo v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasRepo() => $_has(8);
  @$pb.TagNumber(10)
  void clearRepo() => clearField(10);
  @$pb.TagNumber(10)
  $0.Repo ensureRepo() => $_ensure(8);

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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');

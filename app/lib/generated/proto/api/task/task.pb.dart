//
//  Generated code. Do not modify.
//  source: api/task/task.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $1;
import 'task.pbenum.dart';

export 'task.pbenum.dart';

class Task extends $pb.GeneratedMessage {
  factory Task({
    $core.String? id,
    $1.Timestamp? startTime,
    $1.Timestamp? endTime,
    $core.String? name,
    $core.double? progress,
    $core.String? progressState,
    $core.String? kind,
    $core.String? option,
    TaskState? state,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (startTime != null) {
      $result.startTime = startTime;
    }
    if (endTime != null) {
      $result.endTime = endTime;
    }
    if (name != null) {
      $result.name = name;
    }
    if (progress != null) {
      $result.progress = progress;
    }
    if (progressState != null) {
      $result.progressState = progressState;
    }
    if (kind != null) {
      $result.kind = kind;
    }
    if (option != null) {
      $result.option = option;
    }
    if (state != null) {
      $result.state = state;
    }
    return $result;
  }
  Task._() : super();
  factory Task.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Task.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Task', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'startTime', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'endTime', subBuilder: $1.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'progress', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'progressState')
    ..aOS(9, _omitFieldNames ? '' : 'kind')
    ..aOS(10, _omitFieldNames ? '' : 'option')
    ..e<TaskState>(11, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: TaskState.TASK_STATE_UNSPECIFIED, valueOf: TaskState.valueOf, enumValues: TaskState.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Task clone() => Task()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Task copyWith(void Function(Task) updates) => super.copyWith((message) => updates(message as Task)) as Task;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Task create() => Task._();
  Task createEmptyInstance() => create();
  static $pb.PbList<Task> createRepeated() => $pb.PbList<Task>();
  @$core.pragma('dart2js:noInline')
  static Task getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Task>(create);
  static Task? _defaultInstance;

  /// @gotags: gorm:"not null;unique"
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(2)
  $1.Timestamp get startTime => $_getN(1);
  @$pb.TagNumber(2)
  set startTime($1.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStartTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTime() => clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureStartTime() => $_ensure(1);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(3)
  $1.Timestamp get endTime => $_getN(2);
  @$pb.TagNumber(3)
  set endTime($1.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEndTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndTime() => clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureEndTime() => $_ensure(2);

  /// @gotags: gorm:"not null;"
  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(5)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(5)
  void clearName() => clearField(5);

  @$pb.TagNumber(7)
  $core.double get progress => $_getN(4);
  @$pb.TagNumber(7)
  set progress($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(7)
  $core.bool hasProgress() => $_has(4);
  @$pb.TagNumber(7)
  void clearProgress() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get progressState => $_getSZ(5);
  @$pb.TagNumber(8)
  set progressState($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(8)
  $core.bool hasProgressState() => $_has(5);
  @$pb.TagNumber(8)
  void clearProgressState() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get kind => $_getSZ(6);
  @$pb.TagNumber(9)
  set kind($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(9)
  $core.bool hasKind() => $_has(6);
  @$pb.TagNumber(9)
  void clearKind() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get option => $_getSZ(7);
  @$pb.TagNumber(10)
  set option($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(10)
  $core.bool hasOption() => $_has(7);
  @$pb.TagNumber(10)
  void clearOption() => clearField(10);

  @$pb.TagNumber(11)
  TaskState get state => $_getN(8);
  @$pb.TagNumber(11)
  set state(TaskState v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(11)
  void clearState() => clearField(11);
}

class ListTasksRequest extends $pb.GeneratedMessage {
  factory ListTasksRequest({
    $core.int? pageNum,
    $core.String? pageToken,
    $core.String? state,
  }) {
    final $result = create();
    if (pageNum != null) {
      $result.pageNum = pageNum;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    if (state != null) {
      $result.state = state;
    }
    return $result;
  }
  ListTasksRequest._() : super();
  factory ListTasksRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTasksRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListTasksRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'pageNum', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'pageToken')
    ..aOS(3, _omitFieldNames ? '' : 'state')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTasksRequest clone() => ListTasksRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTasksRequest copyWith(void Function(ListTasksRequest) updates) => super.copyWith((message) => updates(message as ListTasksRequest)) as ListTasksRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTasksRequest create() => ListTasksRequest._();
  ListTasksRequest createEmptyInstance() => create();
  static $pb.PbList<ListTasksRequest> createRepeated() => $pb.PbList<ListTasksRequest>();
  @$core.pragma('dart2js:noInline')
  static ListTasksRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTasksRequest>(create);
  static ListTasksRequest? _defaultInstance;

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
  $core.String get state => $_getSZ(2);
  @$pb.TagNumber(3)
  set state($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => clearField(3);
}

class ListTasksResponse extends $pb.GeneratedMessage {
  factory ListTasksResponse({
    $core.Iterable<Task>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  ListTasksResponse._() : super();
  factory ListTasksResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTasksResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListTasksResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..pc<Task>(3, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: Task.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTasksResponse clone() => ListTasksResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTasksResponse copyWith(void Function(ListTasksResponse) updates) => super.copyWith((message) => updates(message as ListTasksResponse)) as ListTasksResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTasksResponse create() => ListTasksResponse._();
  ListTasksResponse createEmptyInstance() => create();
  static $pb.PbList<ListTasksResponse> createRepeated() => $pb.PbList<ListTasksResponse>();
  @$core.pragma('dart2js:noInline')
  static ListTasksResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTasksResponse>(create);
  static ListTasksResponse? _defaultInstance;

  @$pb.TagNumber(3)
  $core.List<Task> get results => $_getList(0);
}

class RetryTaskRequest extends $pb.GeneratedMessage {
  factory RetryTaskRequest({
    $core.Iterable<$core.String>? tasks,
  }) {
    final $result = create();
    if (tasks != null) {
      $result.tasks.addAll(tasks);
    }
    return $result;
  }
  RetryTaskRequest._() : super();
  factory RetryTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RetryTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RetryTaskRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'tasks')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RetryTaskRequest clone() => RetryTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RetryTaskRequest copyWith(void Function(RetryTaskRequest) updates) => super.copyWith((message) => updates(message as RetryTaskRequest)) as RetryTaskRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetryTaskRequest create() => RetryTaskRequest._();
  RetryTaskRequest createEmptyInstance() => create();
  static $pb.PbList<RetryTaskRequest> createRepeated() => $pb.PbList<RetryTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static RetryTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetryTaskRequest>(create);
  static RetryTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get tasks => $_getList(0);
}

class RetryTaskResponse extends $pb.GeneratedMessage {
  factory RetryTaskResponse() => create();
  RetryTaskResponse._() : super();
  factory RetryTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RetryTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RetryTaskResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RetryTaskResponse clone() => RetryTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RetryTaskResponse copyWith(void Function(RetryTaskResponse) updates) => super.copyWith((message) => updates(message as RetryTaskResponse)) as RetryTaskResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetryTaskResponse create() => RetryTaskResponse._();
  RetryTaskResponse createEmptyInstance() => create();
  static $pb.PbList<RetryTaskResponse> createRepeated() => $pb.PbList<RetryTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static RetryTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetryTaskResponse>(create);
  static RetryTaskResponse? _defaultInstance;
}

class CancelTaskRequest extends $pb.GeneratedMessage {
  factory CancelTaskRequest({
    $core.Iterable<$core.String>? tasks,
  }) {
    final $result = create();
    if (tasks != null) {
      $result.tasks.addAll(tasks);
    }
    return $result;
  }
  CancelTaskRequest._() : super();
  factory CancelTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelTaskRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'tasks')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelTaskRequest clone() => CancelTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelTaskRequest copyWith(void Function(CancelTaskRequest) updates) => super.copyWith((message) => updates(message as CancelTaskRequest)) as CancelTaskRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelTaskRequest create() => CancelTaskRequest._();
  CancelTaskRequest createEmptyInstance() => create();
  static $pb.PbList<CancelTaskRequest> createRepeated() => $pb.PbList<CancelTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static CancelTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelTaskRequest>(create);
  static CancelTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get tasks => $_getList(0);
}

class CancelTaskResponse extends $pb.GeneratedMessage {
  factory CancelTaskResponse() => create();
  CancelTaskResponse._() : super();
  factory CancelTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelTaskResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelTaskResponse clone() => CancelTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelTaskResponse copyWith(void Function(CancelTaskResponse) updates) => super.copyWith((message) => updates(message as CancelTaskResponse)) as CancelTaskResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelTaskResponse create() => CancelTaskResponse._();
  CancelTaskResponse createEmptyInstance() => create();
  static $pb.PbList<CancelTaskResponse> createRepeated() => $pb.PbList<CancelTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static CancelTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelTaskResponse>(create);
  static CancelTaskResponse? _defaultInstance;
}

class RemoveTaskRequest extends $pb.GeneratedMessage {
  factory RemoveTaskRequest({
    $core.Iterable<$core.String>? tasks,
  }) {
    final $result = create();
    if (tasks != null) {
      $result.tasks.addAll(tasks);
    }
    return $result;
  }
  RemoveTaskRequest._() : super();
  factory RemoveTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveTaskRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'tasks')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveTaskRequest clone() => RemoveTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveTaskRequest copyWith(void Function(RemoveTaskRequest) updates) => super.copyWith((message) => updates(message as RemoveTaskRequest)) as RemoveTaskRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveTaskRequest create() => RemoveTaskRequest._();
  RemoveTaskRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveTaskRequest> createRepeated() => $pb.PbList<RemoveTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveTaskRequest>(create);
  static RemoveTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get tasks => $_getList(0);
}

class RemoveTaskResponse extends $pb.GeneratedMessage {
  factory RemoveTaskResponse() => create();
  RemoveTaskResponse._() : super();
  factory RemoveTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveTaskResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveTaskResponse clone() => RemoveTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveTaskResponse copyWith(void Function(RemoveTaskResponse) updates) => super.copyWith((message) => updates(message as RemoveTaskResponse)) as RemoveTaskResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveTaskResponse create() => RemoveTaskResponse._();
  RemoveTaskResponse createEmptyInstance() => create();
  static $pb.PbList<RemoveTaskResponse> createRepeated() => $pb.PbList<RemoveTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static RemoveTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveTaskResponse>(create);
  static RemoveTaskResponse? _defaultInstance;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');

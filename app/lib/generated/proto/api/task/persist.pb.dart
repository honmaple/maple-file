//
//  Generated code. Do not modify.
//  source: api/task/persist.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $2;

class PersistTask extends $pb.GeneratedMessage {
  factory PersistTask({
    $core.int? id,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
    $core.String? name,
    $core.bool? status,
    $core.String? type,
    $core.String? option,
    $core.String? cronOption,
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
    if (status != null) {
      $result.status = status;
    }
    if (type != null) {
      $result.type = type;
    }
    if (option != null) {
      $result.option = option;
    }
    if (cronOption != null) {
      $result.cronOption = cronOption;
    }
    return $result;
  }
  PersistTask._() : super();
  factory PersistTask.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PersistTask.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PersistTask', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'createdAt', subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(3, _omitFieldNames ? '' : 'updatedAt', subBuilder: $2.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOB(5, _omitFieldNames ? '' : 'status')
    ..aOS(6, _omitFieldNames ? '' : 'type')
    ..aOS(7, _omitFieldNames ? '' : 'option')
    ..aOS(8, _omitFieldNames ? '' : 'cronOption')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PersistTask clone() => PersistTask()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PersistTask copyWith(void Function(PersistTask) updates) => super.copyWith((message) => updates(message as PersistTask)) as PersistTask;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PersistTask create() => PersistTask._();
  PersistTask createEmptyInstance() => create();
  static $pb.PbList<PersistTask> createRepeated() => $pb.PbList<PersistTask>();
  @$core.pragma('dart2js:noInline')
  static PersistTask getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PersistTask>(create);
  static PersistTask? _defaultInstance;

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

  /// @gotags: gorm:"not null;unique"
  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get status => $_getBF(4);
  @$pb.TagNumber(5)
  set status($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get type => $_getSZ(5);
  @$pb.TagNumber(6)
  set type($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasType() => $_has(5);
  @$pb.TagNumber(6)
  void clearType() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get option => $_getSZ(6);
  @$pb.TagNumber(7)
  set option($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasOption() => $_has(6);
  @$pb.TagNumber(7)
  void clearOption() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get cronOption => $_getSZ(7);
  @$pb.TagNumber(8)
  set cronOption($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCronOption() => $_has(7);
  @$pb.TagNumber(8)
  void clearCronOption() => clearField(8);
}

class ListPersistTasksRequest extends $pb.GeneratedMessage {
  factory ListPersistTasksRequest({
    $core.Map<$core.String, $core.String>? filter,
  }) {
    final $result = create();
    if (filter != null) {
      $result.filter.addAll(filter);
    }
    return $result;
  }
  ListPersistTasksRequest._() : super();
  factory ListPersistTasksRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPersistTasksRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPersistTasksRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'filter', entryClassName: 'ListPersistTasksRequest.FilterEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('api.task'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPersistTasksRequest clone() => ListPersistTasksRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPersistTasksRequest copyWith(void Function(ListPersistTasksRequest) updates) => super.copyWith((message) => updates(message as ListPersistTasksRequest)) as ListPersistTasksRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPersistTasksRequest create() => ListPersistTasksRequest._();
  ListPersistTasksRequest createEmptyInstance() => create();
  static $pb.PbList<ListPersistTasksRequest> createRepeated() => $pb.PbList<ListPersistTasksRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPersistTasksRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPersistTasksRequest>(create);
  static ListPersistTasksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $core.String> get filter => $_getMap(0);
}

class ListPersistTasksResponse extends $pb.GeneratedMessage {
  factory ListPersistTasksResponse({
    $core.Iterable<PersistTask>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  ListPersistTasksResponse._() : super();
  factory ListPersistTasksResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPersistTasksResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPersistTasksResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..pc<PersistTask>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: PersistTask.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPersistTasksResponse clone() => ListPersistTasksResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPersistTasksResponse copyWith(void Function(ListPersistTasksResponse) updates) => super.copyWith((message) => updates(message as ListPersistTasksResponse)) as ListPersistTasksResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPersistTasksResponse create() => ListPersistTasksResponse._();
  ListPersistTasksResponse createEmptyInstance() => create();
  static $pb.PbList<ListPersistTasksResponse> createRepeated() => $pb.PbList<ListPersistTasksResponse>();
  @$core.pragma('dart2js:noInline')
  static ListPersistTasksResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPersistTasksResponse>(create);
  static ListPersistTasksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<PersistTask> get results => $_getList(0);
}

class CreatePersistTaskRequest extends $pb.GeneratedMessage {
  factory CreatePersistTaskRequest({
    PersistTask? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  CreatePersistTaskRequest._() : super();
  factory CreatePersistTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreatePersistTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreatePersistTaskRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..aOM<PersistTask>(1, _omitFieldNames ? '' : 'payload', subBuilder: PersistTask.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreatePersistTaskRequest clone() => CreatePersistTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreatePersistTaskRequest copyWith(void Function(CreatePersistTaskRequest) updates) => super.copyWith((message) => updates(message as CreatePersistTaskRequest)) as CreatePersistTaskRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePersistTaskRequest create() => CreatePersistTaskRequest._();
  CreatePersistTaskRequest createEmptyInstance() => create();
  static $pb.PbList<CreatePersistTaskRequest> createRepeated() => $pb.PbList<CreatePersistTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static CreatePersistTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatePersistTaskRequest>(create);
  static CreatePersistTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  PersistTask get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(PersistTask v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  PersistTask ensurePayload() => $_ensure(0);
}

class CreatePersistTaskResponse extends $pb.GeneratedMessage {
  factory CreatePersistTaskResponse({
    PersistTask? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  CreatePersistTaskResponse._() : super();
  factory CreatePersistTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreatePersistTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreatePersistTaskResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..aOM<PersistTask>(1, _omitFieldNames ? '' : 'result', subBuilder: PersistTask.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreatePersistTaskResponse clone() => CreatePersistTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreatePersistTaskResponse copyWith(void Function(CreatePersistTaskResponse) updates) => super.copyWith((message) => updates(message as CreatePersistTaskResponse)) as CreatePersistTaskResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreatePersistTaskResponse create() => CreatePersistTaskResponse._();
  CreatePersistTaskResponse createEmptyInstance() => create();
  static $pb.PbList<CreatePersistTaskResponse> createRepeated() => $pb.PbList<CreatePersistTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static CreatePersistTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreatePersistTaskResponse>(create);
  static CreatePersistTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PersistTask get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(PersistTask v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  PersistTask ensureResult() => $_ensure(0);
}

class UpdatePersistTaskRequest extends $pb.GeneratedMessage {
  factory UpdatePersistTaskRequest({
    PersistTask? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  UpdatePersistTaskRequest._() : super();
  factory UpdatePersistTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdatePersistTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdatePersistTaskRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..aOM<PersistTask>(1, _omitFieldNames ? '' : 'payload', subBuilder: PersistTask.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdatePersistTaskRequest clone() => UpdatePersistTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdatePersistTaskRequest copyWith(void Function(UpdatePersistTaskRequest) updates) => super.copyWith((message) => updates(message as UpdatePersistTaskRequest)) as UpdatePersistTaskRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePersistTaskRequest create() => UpdatePersistTaskRequest._();
  UpdatePersistTaskRequest createEmptyInstance() => create();
  static $pb.PbList<UpdatePersistTaskRequest> createRepeated() => $pb.PbList<UpdatePersistTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdatePersistTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdatePersistTaskRequest>(create);
  static UpdatePersistTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  PersistTask get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(PersistTask v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  PersistTask ensurePayload() => $_ensure(0);
}

class UpdatePersistTaskResponse extends $pb.GeneratedMessage {
  factory UpdatePersistTaskResponse({
    PersistTask? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  UpdatePersistTaskResponse._() : super();
  factory UpdatePersistTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdatePersistTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdatePersistTaskResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..aOM<PersistTask>(1, _omitFieldNames ? '' : 'result', subBuilder: PersistTask.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdatePersistTaskResponse clone() => UpdatePersistTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdatePersistTaskResponse copyWith(void Function(UpdatePersistTaskResponse) updates) => super.copyWith((message) => updates(message as UpdatePersistTaskResponse)) as UpdatePersistTaskResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdatePersistTaskResponse create() => UpdatePersistTaskResponse._();
  UpdatePersistTaskResponse createEmptyInstance() => create();
  static $pb.PbList<UpdatePersistTaskResponse> createRepeated() => $pb.PbList<UpdatePersistTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdatePersistTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdatePersistTaskResponse>(create);
  static UpdatePersistTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PersistTask get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(PersistTask v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  PersistTask ensureResult() => $_ensure(0);
}

class DeletePersistTaskRequest extends $pb.GeneratedMessage {
  factory DeletePersistTaskRequest({
    $core.int? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeletePersistTaskRequest._() : super();
  factory DeletePersistTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeletePersistTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeletePersistTaskRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeletePersistTaskRequest clone() => DeletePersistTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeletePersistTaskRequest copyWith(void Function(DeletePersistTaskRequest) updates) => super.copyWith((message) => updates(message as DeletePersistTaskRequest)) as DeletePersistTaskRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePersistTaskRequest create() => DeletePersistTaskRequest._();
  DeletePersistTaskRequest createEmptyInstance() => create();
  static $pb.PbList<DeletePersistTaskRequest> createRepeated() => $pb.PbList<DeletePersistTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static DeletePersistTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeletePersistTaskRequest>(create);
  static DeletePersistTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DeletePersistTaskResponse extends $pb.GeneratedMessage {
  factory DeletePersistTaskResponse() => create();
  DeletePersistTaskResponse._() : super();
  factory DeletePersistTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeletePersistTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeletePersistTaskResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeletePersistTaskResponse clone() => DeletePersistTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeletePersistTaskResponse copyWith(void Function(DeletePersistTaskResponse) updates) => super.copyWith((message) => updates(message as DeletePersistTaskResponse)) as DeletePersistTaskResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeletePersistTaskResponse create() => DeletePersistTaskResponse._();
  DeletePersistTaskResponse createEmptyInstance() => create();
  static $pb.PbList<DeletePersistTaskResponse> createRepeated() => $pb.PbList<DeletePersistTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static DeletePersistTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeletePersistTaskResponse>(create);
  static DeletePersistTaskResponse? _defaultInstance;
}

class ExecutePersistTaskRequest extends $pb.GeneratedMessage {
  factory ExecutePersistTaskRequest({
    $core.int? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  ExecutePersistTaskRequest._() : super();
  factory ExecutePersistTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExecutePersistTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExecutePersistTaskRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExecutePersistTaskRequest clone() => ExecutePersistTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExecutePersistTaskRequest copyWith(void Function(ExecutePersistTaskRequest) updates) => super.copyWith((message) => updates(message as ExecutePersistTaskRequest)) as ExecutePersistTaskRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecutePersistTaskRequest create() => ExecutePersistTaskRequest._();
  ExecutePersistTaskRequest createEmptyInstance() => create();
  static $pb.PbList<ExecutePersistTaskRequest> createRepeated() => $pb.PbList<ExecutePersistTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static ExecutePersistTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExecutePersistTaskRequest>(create);
  static ExecutePersistTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ExecutePersistTaskResponse extends $pb.GeneratedMessage {
  factory ExecutePersistTaskResponse() => create();
  ExecutePersistTaskResponse._() : super();
  factory ExecutePersistTaskResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExecutePersistTaskResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExecutePersistTaskResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.task'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExecutePersistTaskResponse clone() => ExecutePersistTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExecutePersistTaskResponse copyWith(void Function(ExecutePersistTaskResponse) updates) => super.copyWith((message) => updates(message as ExecutePersistTaskResponse)) as ExecutePersistTaskResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExecutePersistTaskResponse create() => ExecutePersistTaskResponse._();
  ExecutePersistTaskResponse createEmptyInstance() => create();
  static $pb.PbList<ExecutePersistTaskResponse> createRepeated() => $pb.PbList<ExecutePersistTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static ExecutePersistTaskResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExecutePersistTaskResponse>(create);
  static ExecutePersistTaskResponse? _defaultInstance;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');

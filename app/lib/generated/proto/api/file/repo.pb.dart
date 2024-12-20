//
//  Generated code. Do not modify.
//  source: api/file/repo.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $2;

class Repo extends $pb.GeneratedMessage {
  factory Repo({
    $core.int? id,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
    $core.String? name,
    $core.String? path,
    $core.bool? status,
    $core.String? driver,
    $core.String? option,
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
    if (path != null) {
      $result.path = path;
    }
    if (status != null) {
      $result.status = status;
    }
    if (driver != null) {
      $result.driver = driver;
    }
    if (option != null) {
      $result.option = option;
    }
    return $result;
  }
  Repo._() : super();
  factory Repo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Repo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Repo', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'createdAt', subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(3, _omitFieldNames ? '' : 'updatedAt', subBuilder: $2.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'path')
    ..aOB(6, _omitFieldNames ? '' : 'status')
    ..aOS(7, _omitFieldNames ? '' : 'driver')
    ..aOS(8, _omitFieldNames ? '' : 'option')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Repo clone() => Repo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Repo copyWith(void Function(Repo) updates) => super.copyWith((message) => updates(message as Repo)) as Repo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Repo create() => Repo._();
  Repo createEmptyInstance() => create();
  static $pb.PbList<Repo> createRepeated() => $pb.PbList<Repo>();
  @$core.pragma('dart2js:noInline')
  static Repo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Repo>(create);
  static Repo? _defaultInstance;

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
  $core.String get path => $_getSZ(4);
  @$pb.TagNumber(5)
  set path($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPath() => $_has(4);
  @$pb.TagNumber(5)
  void clearPath() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get status => $_getBF(5);
  @$pb.TagNumber(6)
  set status($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get driver => $_getSZ(6);
  @$pb.TagNumber(7)
  set driver($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDriver() => $_has(6);
  @$pb.TagNumber(7)
  void clearDriver() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get option => $_getSZ(7);
  @$pb.TagNumber(8)
  set option($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasOption() => $_has(7);
  @$pb.TagNumber(8)
  void clearOption() => clearField(8);
}

class ListReposRequest extends $pb.GeneratedMessage {
  factory ListReposRequest({
    $core.Map<$core.String, $core.String>? filter,
  }) {
    final $result = create();
    if (filter != null) {
      $result.filter.addAll(filter);
    }
    return $result;
  }
  ListReposRequest._() : super();
  factory ListReposRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListReposRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListReposRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..m<$core.String, $core.String>(1, _omitFieldNames ? '' : 'filter', entryClassName: 'ListReposRequest.FilterEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('api.file'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListReposRequest clone() => ListReposRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListReposRequest copyWith(void Function(ListReposRequest) updates) => super.copyWith((message) => updates(message as ListReposRequest)) as ListReposRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReposRequest create() => ListReposRequest._();
  ListReposRequest createEmptyInstance() => create();
  static $pb.PbList<ListReposRequest> createRepeated() => $pb.PbList<ListReposRequest>();
  @$core.pragma('dart2js:noInline')
  static ListReposRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListReposRequest>(create);
  static ListReposRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.Map<$core.String, $core.String> get filter => $_getMap(0);
}

class ListReposResponse extends $pb.GeneratedMessage {
  factory ListReposResponse({
    $core.Iterable<Repo>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  ListReposResponse._() : super();
  factory ListReposResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListReposResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListReposResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..pc<Repo>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: Repo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListReposResponse clone() => ListReposResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListReposResponse copyWith(void Function(ListReposResponse) updates) => super.copyWith((message) => updates(message as ListReposResponse)) as ListReposResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReposResponse create() => ListReposResponse._();
  ListReposResponse createEmptyInstance() => create();
  static $pb.PbList<ListReposResponse> createRepeated() => $pb.PbList<ListReposResponse>();
  @$core.pragma('dart2js:noInline')
  static ListReposResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListReposResponse>(create);
  static ListReposResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Repo> get results => $_getList(0);
}

class CreateRepoRequest extends $pb.GeneratedMessage {
  factory CreateRepoRequest({
    Repo? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  CreateRepoRequest._() : super();
  factory CreateRepoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRepoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRepoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<Repo>(1, _omitFieldNames ? '' : 'payload', subBuilder: Repo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRepoRequest clone() => CreateRepoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRepoRequest copyWith(void Function(CreateRepoRequest) updates) => super.copyWith((message) => updates(message as CreateRepoRequest)) as CreateRepoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRepoRequest create() => CreateRepoRequest._();
  CreateRepoRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRepoRequest> createRepeated() => $pb.PbList<CreateRepoRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateRepoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRepoRequest>(create);
  static CreateRepoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Repo get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(Repo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  Repo ensurePayload() => $_ensure(0);
}

class CreateRepoResponse extends $pb.GeneratedMessage {
  factory CreateRepoResponse({
    Repo? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  CreateRepoResponse._() : super();
  factory CreateRepoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRepoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRepoResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<Repo>(1, _omitFieldNames ? '' : 'result', subBuilder: Repo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRepoResponse clone() => CreateRepoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRepoResponse copyWith(void Function(CreateRepoResponse) updates) => super.copyWith((message) => updates(message as CreateRepoResponse)) as CreateRepoResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRepoResponse create() => CreateRepoResponse._();
  CreateRepoResponse createEmptyInstance() => create();
  static $pb.PbList<CreateRepoResponse> createRepeated() => $pb.PbList<CreateRepoResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateRepoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRepoResponse>(create);
  static CreateRepoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Repo get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(Repo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  Repo ensureResult() => $_ensure(0);
}

class TestRepoRequest extends $pb.GeneratedMessage {
  factory TestRepoRequest({
    Repo? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  TestRepoRequest._() : super();
  factory TestRepoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TestRepoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TestRepoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<Repo>(1, _omitFieldNames ? '' : 'payload', subBuilder: Repo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TestRepoRequest clone() => TestRepoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TestRepoRequest copyWith(void Function(TestRepoRequest) updates) => super.copyWith((message) => updates(message as TestRepoRequest)) as TestRepoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestRepoRequest create() => TestRepoRequest._();
  TestRepoRequest createEmptyInstance() => create();
  static $pb.PbList<TestRepoRequest> createRepeated() => $pb.PbList<TestRepoRequest>();
  @$core.pragma('dart2js:noInline')
  static TestRepoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TestRepoRequest>(create);
  static TestRepoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Repo get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(Repo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  Repo ensurePayload() => $_ensure(0);
}

class TestRepoResponse extends $pb.GeneratedMessage {
  factory TestRepoResponse({
    $core.bool? success,
  }) {
    final $result = create();
    if (success != null) {
      $result.success = success;
    }
    return $result;
  }
  TestRepoResponse._() : super();
  factory TestRepoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TestRepoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TestRepoResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TestRepoResponse clone() => TestRepoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TestRepoResponse copyWith(void Function(TestRepoResponse) updates) => super.copyWith((message) => updates(message as TestRepoResponse)) as TestRepoResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestRepoResponse create() => TestRepoResponse._();
  TestRepoResponse createEmptyInstance() => create();
  static $pb.PbList<TestRepoResponse> createRepeated() => $pb.PbList<TestRepoResponse>();
  @$core.pragma('dart2js:noInline')
  static TestRepoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TestRepoResponse>(create);
  static TestRepoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => clearField(1);
}

class UpdateRepoRequest extends $pb.GeneratedMessage {
  factory UpdateRepoRequest({
    Repo? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  UpdateRepoRequest._() : super();
  factory UpdateRepoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateRepoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateRepoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<Repo>(1, _omitFieldNames ? '' : 'payload', subBuilder: Repo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateRepoRequest clone() => UpdateRepoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateRepoRequest copyWith(void Function(UpdateRepoRequest) updates) => super.copyWith((message) => updates(message as UpdateRepoRequest)) as UpdateRepoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRepoRequest create() => UpdateRepoRequest._();
  UpdateRepoRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateRepoRequest> createRepeated() => $pb.PbList<UpdateRepoRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateRepoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateRepoRequest>(create);
  static UpdateRepoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Repo get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(Repo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  Repo ensurePayload() => $_ensure(0);
}

class UpdateRepoResponse extends $pb.GeneratedMessage {
  factory UpdateRepoResponse({
    Repo? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  UpdateRepoResponse._() : super();
  factory UpdateRepoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateRepoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateRepoResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<Repo>(1, _omitFieldNames ? '' : 'result', subBuilder: Repo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateRepoResponse clone() => UpdateRepoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateRepoResponse copyWith(void Function(UpdateRepoResponse) updates) => super.copyWith((message) => updates(message as UpdateRepoResponse)) as UpdateRepoResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRepoResponse create() => UpdateRepoResponse._();
  UpdateRepoResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateRepoResponse> createRepeated() => $pb.PbList<UpdateRepoResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateRepoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateRepoResponse>(create);
  static UpdateRepoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Repo get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(Repo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  Repo ensureResult() => $_ensure(0);
}

class DeleteRepoRequest extends $pb.GeneratedMessage {
  factory DeleteRepoRequest({
    $core.int? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteRepoRequest._() : super();
  factory DeleteRepoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteRepoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteRepoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteRepoRequest clone() => DeleteRepoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteRepoRequest copyWith(void Function(DeleteRepoRequest) updates) => super.copyWith((message) => updates(message as DeleteRepoRequest)) as DeleteRepoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRepoRequest create() => DeleteRepoRequest._();
  DeleteRepoRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteRepoRequest> createRepeated() => $pb.PbList<DeleteRepoRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteRepoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteRepoRequest>(create);
  static DeleteRepoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class DeleteRepoResponse extends $pb.GeneratedMessage {
  factory DeleteRepoResponse() => create();
  DeleteRepoResponse._() : super();
  factory DeleteRepoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteRepoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteRepoResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteRepoResponse clone() => DeleteRepoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteRepoResponse copyWith(void Function(DeleteRepoResponse) updates) => super.copyWith((message) => updates(message as DeleteRepoResponse)) as DeleteRepoResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRepoResponse create() => DeleteRepoResponse._();
  DeleteRepoResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteRepoResponse> createRepeated() => $pb.PbList<DeleteRepoResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteRepoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteRepoResponse>(create);
  static DeleteRepoResponse? _defaultInstance;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');

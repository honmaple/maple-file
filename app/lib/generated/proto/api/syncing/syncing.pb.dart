//
//  Generated code. Do not modify.
//  source: api/syncing/syncing.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $1;
import 'syncing.pbenum.dart';

export 'syncing.pbenum.dart';

class SyncProfile_ListRequest extends $pb.GeneratedMessage {
  factory SyncProfile_ListRequest() => create();
  SyncProfile_ListRequest._() : super();
  factory SyncProfile_ListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProfile_ListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProfile.ListRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProfile_ListRequest clone() => SyncProfile_ListRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProfile_ListRequest copyWith(void Function(SyncProfile_ListRequest) updates) => super.copyWith((message) => updates(message as SyncProfile_ListRequest)) as SyncProfile_ListRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProfile_ListRequest create() => SyncProfile_ListRequest._();
  SyncProfile_ListRequest createEmptyInstance() => create();
  static $pb.PbList<SyncProfile_ListRequest> createRepeated() => $pb.PbList<SyncProfile_ListRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncProfile_ListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProfile_ListRequest>(create);
  static SyncProfile_ListRequest? _defaultInstance;
}

class SyncProfile_ListResponse extends $pb.GeneratedMessage {
  factory SyncProfile_ListResponse({
    $core.Iterable<SyncProfile>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  SyncProfile_ListResponse._() : super();
  factory SyncProfile_ListResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProfile_ListResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProfile.ListResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..pc<SyncProfile>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: SyncProfile.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProfile_ListResponse clone() => SyncProfile_ListResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProfile_ListResponse copyWith(void Function(SyncProfile_ListResponse) updates) => super.copyWith((message) => updates(message as SyncProfile_ListResponse)) as SyncProfile_ListResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProfile_ListResponse create() => SyncProfile_ListResponse._();
  SyncProfile_ListResponse createEmptyInstance() => create();
  static $pb.PbList<SyncProfile_ListResponse> createRepeated() => $pb.PbList<SyncProfile_ListResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncProfile_ListResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProfile_ListResponse>(create);
  static SyncProfile_ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SyncProfile> get results => $_getList(0);
}

class SyncProfile_CreateRequest extends $pb.GeneratedMessage {
  factory SyncProfile_CreateRequest({
    SyncProfile? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  SyncProfile_CreateRequest._() : super();
  factory SyncProfile_CreateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProfile_CreateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProfile.CreateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncProfile>(1, _omitFieldNames ? '' : 'payload', subBuilder: SyncProfile.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProfile_CreateRequest clone() => SyncProfile_CreateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProfile_CreateRequest copyWith(void Function(SyncProfile_CreateRequest) updates) => super.copyWith((message) => updates(message as SyncProfile_CreateRequest)) as SyncProfile_CreateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProfile_CreateRequest create() => SyncProfile_CreateRequest._();
  SyncProfile_CreateRequest createEmptyInstance() => create();
  static $pb.PbList<SyncProfile_CreateRequest> createRepeated() => $pb.PbList<SyncProfile_CreateRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncProfile_CreateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProfile_CreateRequest>(create);
  static SyncProfile_CreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  SyncProfile get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(SyncProfile v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  SyncProfile ensurePayload() => $_ensure(0);
}

class SyncProfile_CreateResponse extends $pb.GeneratedMessage {
  factory SyncProfile_CreateResponse({
    SyncProfile? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  SyncProfile_CreateResponse._() : super();
  factory SyncProfile_CreateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProfile_CreateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProfile.CreateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncProfile>(1, _omitFieldNames ? '' : 'result', subBuilder: SyncProfile.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProfile_CreateResponse clone() => SyncProfile_CreateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProfile_CreateResponse copyWith(void Function(SyncProfile_CreateResponse) updates) => super.copyWith((message) => updates(message as SyncProfile_CreateResponse)) as SyncProfile_CreateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProfile_CreateResponse create() => SyncProfile_CreateResponse._();
  SyncProfile_CreateResponse createEmptyInstance() => create();
  static $pb.PbList<SyncProfile_CreateResponse> createRepeated() => $pb.PbList<SyncProfile_CreateResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncProfile_CreateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProfile_CreateResponse>(create);
  static SyncProfile_CreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SyncProfile get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(SyncProfile v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  SyncProfile ensureResult() => $_ensure(0);
}

class SyncProfile_UpdateRequest extends $pb.GeneratedMessage {
  factory SyncProfile_UpdateRequest({
    SyncProfile? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  SyncProfile_UpdateRequest._() : super();
  factory SyncProfile_UpdateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProfile_UpdateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProfile.UpdateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncProfile>(1, _omitFieldNames ? '' : 'payload', subBuilder: SyncProfile.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProfile_UpdateRequest clone() => SyncProfile_UpdateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProfile_UpdateRequest copyWith(void Function(SyncProfile_UpdateRequest) updates) => super.copyWith((message) => updates(message as SyncProfile_UpdateRequest)) as SyncProfile_UpdateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProfile_UpdateRequest create() => SyncProfile_UpdateRequest._();
  SyncProfile_UpdateRequest createEmptyInstance() => create();
  static $pb.PbList<SyncProfile_UpdateRequest> createRepeated() => $pb.PbList<SyncProfile_UpdateRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncProfile_UpdateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProfile_UpdateRequest>(create);
  static SyncProfile_UpdateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  SyncProfile get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(SyncProfile v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  SyncProfile ensurePayload() => $_ensure(0);
}

class SyncProfile_UpdateResponse extends $pb.GeneratedMessage {
  factory SyncProfile_UpdateResponse({
    SyncProfile? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  SyncProfile_UpdateResponse._() : super();
  factory SyncProfile_UpdateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProfile_UpdateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProfile.UpdateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncProfile>(1, _omitFieldNames ? '' : 'result', subBuilder: SyncProfile.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProfile_UpdateResponse clone() => SyncProfile_UpdateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProfile_UpdateResponse copyWith(void Function(SyncProfile_UpdateResponse) updates) => super.copyWith((message) => updates(message as SyncProfile_UpdateResponse)) as SyncProfile_UpdateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProfile_UpdateResponse create() => SyncProfile_UpdateResponse._();
  SyncProfile_UpdateResponse createEmptyInstance() => create();
  static $pb.PbList<SyncProfile_UpdateResponse> createRepeated() => $pb.PbList<SyncProfile_UpdateResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncProfile_UpdateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProfile_UpdateResponse>(create);
  static SyncProfile_UpdateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SyncProfile get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(SyncProfile v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  SyncProfile ensureResult() => $_ensure(0);
}

class SyncProfile_DeleteRequest extends $pb.GeneratedMessage {
  factory SyncProfile_DeleteRequest({
    $core.int? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  SyncProfile_DeleteRequest._() : super();
  factory SyncProfile_DeleteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProfile_DeleteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProfile.DeleteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProfile_DeleteRequest clone() => SyncProfile_DeleteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProfile_DeleteRequest copyWith(void Function(SyncProfile_DeleteRequest) updates) => super.copyWith((message) => updates(message as SyncProfile_DeleteRequest)) as SyncProfile_DeleteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProfile_DeleteRequest create() => SyncProfile_DeleteRequest._();
  SyncProfile_DeleteRequest createEmptyInstance() => create();
  static $pb.PbList<SyncProfile_DeleteRequest> createRepeated() => $pb.PbList<SyncProfile_DeleteRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncProfile_DeleteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProfile_DeleteRequest>(create);
  static SyncProfile_DeleteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class SyncProfile_DeleteResponse extends $pb.GeneratedMessage {
  factory SyncProfile_DeleteResponse() => create();
  SyncProfile_DeleteResponse._() : super();
  factory SyncProfile_DeleteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProfile_DeleteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProfile.DeleteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProfile_DeleteResponse clone() => SyncProfile_DeleteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProfile_DeleteResponse copyWith(void Function(SyncProfile_DeleteResponse) updates) => super.copyWith((message) => updates(message as SyncProfile_DeleteResponse)) as SyncProfile_DeleteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProfile_DeleteResponse create() => SyncProfile_DeleteResponse._();
  SyncProfile_DeleteResponse createEmptyInstance() => create();
  static $pb.PbList<SyncProfile_DeleteResponse> createRepeated() => $pb.PbList<SyncProfile_DeleteResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncProfile_DeleteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProfile_DeleteResponse>(create);
  static SyncProfile_DeleteResponse? _defaultInstance;
}

class SyncProfile extends $pb.GeneratedMessage {
  factory SyncProfile({
    $core.int? id,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $core.String? name,
    $core.bool? enabled,
    SyncProfile_Mode? mode,
    $core.String? sourceType,
    $core.String? sourceConfig,
    $core.String? targetType,
    $core.String? targetConfig,
    $core.String? policyConfig,
    $fixnum.Int64? configVersion,
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
    if (enabled != null) {
      $result.enabled = enabled;
    }
    if (mode != null) {
      $result.mode = mode;
    }
    if (sourceType != null) {
      $result.sourceType = sourceType;
    }
    if (sourceConfig != null) {
      $result.sourceConfig = sourceConfig;
    }
    if (targetType != null) {
      $result.targetType = targetType;
    }
    if (targetConfig != null) {
      $result.targetConfig = targetConfig;
    }
    if (policyConfig != null) {
      $result.policyConfig = policyConfig;
    }
    if (configVersion != null) {
      $result.configVersion = configVersion;
    }
    return $result;
  }
  SyncProfile._() : super();
  factory SyncProfile.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProfile.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProfile', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'createdAt', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'updatedAt', subBuilder: $1.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOB(5, _omitFieldNames ? '' : 'enabled')
    ..e<SyncProfile_Mode>(6, _omitFieldNames ? '' : 'mode', $pb.PbFieldType.OE, defaultOrMaker: SyncProfile_Mode.MODE_UNSPECIFIED, valueOf: SyncProfile_Mode.valueOf, enumValues: SyncProfile_Mode.values)
    ..aOS(7, _omitFieldNames ? '' : 'sourceType')
    ..aOS(8, _omitFieldNames ? '' : 'sourceConfig')
    ..aOS(9, _omitFieldNames ? '' : 'targetType')
    ..aOS(10, _omitFieldNames ? '' : 'targetConfig')
    ..aOS(11, _omitFieldNames ? '' : 'policyConfig')
    ..aInt64(12, _omitFieldNames ? '' : 'configVersion')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProfile clone() => SyncProfile()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProfile copyWith(void Function(SyncProfile) updates) => super.copyWith((message) => updates(message as SyncProfile)) as SyncProfile;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProfile create() => SyncProfile._();
  SyncProfile createEmptyInstance() => create();
  static $pb.PbList<SyncProfile> createRepeated() => $pb.PbList<SyncProfile>();
  @$core.pragma('dart2js:noInline')
  static SyncProfile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProfile>(create);
  static SyncProfile? _defaultInstance;

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
  $1.Timestamp get createdAt => $_getN(1);
  @$pb.TagNumber(2)
  set createdAt($1.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureCreatedAt() => $_ensure(1);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(3)
  $1.Timestamp get updatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set updatedAt($1.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatedAt() => clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureUpdatedAt() => $_ensure(2);

  /// @gotags: gorm:"not null;unique"
  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  /// Enables future automatic backup or synchronization scheduling. Manual runs
  /// are always allowed regardless of this value.
  @$pb.TagNumber(5)
  $core.bool get enabled => $_getBF(4);
  @$pb.TagNumber(5)
  set enabled($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearEnabled() => clearField(5);

  @$pb.TagNumber(6)
  SyncProfile_Mode get mode => $_getN(5);
  @$pb.TagNumber(6)
  set mode(SyncProfile_Mode v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearMode() => clearField(6);

  /// Current values: album, local_directory. Determines source_config schema.
  /// @gotags: gorm:"not null;index"
  @$pb.TagNumber(7)
  $core.String get sourceType => $_getSZ(6);
  @$pb.TagNumber(7)
  set sourceType($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSourceType() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceType() => clearField(7);

  /// JSON object. Album uses {"album_ids":[...]}; local_directory uses
  /// {"path":"/absolute/path","bookmark":"..."}.
  /// @gotags: gorm:"not null"
  @$pb.TagNumber(8)
  $core.String get sourceConfig => $_getSZ(7);
  @$pb.TagNumber(8)
  set sourceConfig($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSourceConfig() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceConfig() => clearField(8);

  /// Current value: repo_directory.
  /// @gotags: gorm:"not null"
  @$pb.TagNumber(9)
  $core.String get targetType => $_getSZ(8);
  @$pb.TagNumber(9)
  set targetType($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTargetType() => $_has(8);
  @$pb.TagNumber(9)
  void clearTargetType() => clearField(9);

  /// JSON object. All current targets use path. Album also stores layout and
  /// append_device_model.
  /// @gotags: gorm:"not null"
  @$pb.TagNumber(10)
  $core.String get targetConfig => $_getSZ(9);
  @$pb.TagNumber(10)
  set targetConfig($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasTargetConfig() => $_has(9);
  @$pb.TagNumber(10)
  void clearTargetConfig() => clearField(10);

  /// Mode-specific execution policy. Current executors require {}.
  /// @gotags: gorm:"not null"
  @$pb.TagNumber(11)
  $core.String get policyConfig => $_getSZ(10);
  @$pb.TagNumber(11)
  set policyConfig($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasPolicyConfig() => $_has(10);
  @$pb.TagNumber(11)
  void clearPolicyConfig() => clearField(11);

  /// Destination mapping generation. Starts at 1 and increases when target_type
  /// or target_config changes. Name, enabled, source_config, and policy_config do
  /// not increase it. A local_directory source path change deletes old records.
  /// A file record is reusable only when its config_version matches this value.
  /// @gotags: gorm:"not null;default:1"
  @$pb.TagNumber(12)
  $fixnum.Int64 get configVersion => $_getI64(11);
  @$pb.TagNumber(12)
  set configVersion($fixnum.Int64 v) { $_setInt64(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasConfigVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearConfigVersion() => clearField(12);
}

class SyncRecord_ListRequest extends $pb.GeneratedMessage {
  factory SyncRecord_ListRequest({
    $core.Iterable<$core.String>? sourceKeys,
    $core.int? profileId,
    $core.String? sourcePath,
  }) {
    final $result = create();
    if (sourceKeys != null) {
      $result.sourceKeys.addAll(sourceKeys);
    }
    if (profileId != null) {
      $result.profileId = profileId;
    }
    if (sourcePath != null) {
      $result.sourcePath = sourcePath;
    }
    return $result;
  }
  SyncRecord_ListRequest._() : super();
  factory SyncRecord_ListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncRecord_ListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncRecord.ListRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'sourceKeys')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'profileId', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'sourcePath')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncRecord_ListRequest clone() => SyncRecord_ListRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncRecord_ListRequest copyWith(void Function(SyncRecord_ListRequest) updates) => super.copyWith((message) => updates(message as SyncRecord_ListRequest)) as SyncRecord_ListRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncRecord_ListRequest create() => SyncRecord_ListRequest._();
  SyncRecord_ListRequest createEmptyInstance() => create();
  static $pb.PbList<SyncRecord_ListRequest> createRepeated() => $pb.PbList<SyncRecord_ListRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncRecord_ListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncRecord_ListRequest>(create);
  static SyncRecord_ListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get sourceKeys => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get profileId => $_getIZ(1);
  @$pb.TagNumber(2)
  set profileId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProfileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProfileId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourcePath => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourcePath($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSourcePath() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourcePath() => clearField(3);
}

class SyncRecord_ListResponse extends $pb.GeneratedMessage {
  factory SyncRecord_ListResponse({
    $core.Iterable<SyncRecord>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  SyncRecord_ListResponse._() : super();
  factory SyncRecord_ListResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncRecord_ListResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncRecord.ListResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..pc<SyncRecord>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: SyncRecord.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncRecord_ListResponse clone() => SyncRecord_ListResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncRecord_ListResponse copyWith(void Function(SyncRecord_ListResponse) updates) => super.copyWith((message) => updates(message as SyncRecord_ListResponse)) as SyncRecord_ListResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncRecord_ListResponse create() => SyncRecord_ListResponse._();
  SyncRecord_ListResponse createEmptyInstance() => create();
  static $pb.PbList<SyncRecord_ListResponse> createRepeated() => $pb.PbList<SyncRecord_ListResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncRecord_ListResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncRecord_ListResponse>(create);
  static SyncRecord_ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SyncRecord> get results => $_getList(0);
}

class SyncRecord_UpsertRequest extends $pb.GeneratedMessage {
  factory SyncRecord_UpsertRequest({
    $core.Iterable<SyncRecord>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  SyncRecord_UpsertRequest._() : super();
  factory SyncRecord_UpsertRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncRecord_UpsertRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncRecord.UpsertRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..pc<SyncRecord>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: SyncRecord.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncRecord_UpsertRequest clone() => SyncRecord_UpsertRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncRecord_UpsertRequest copyWith(void Function(SyncRecord_UpsertRequest) updates) => super.copyWith((message) => updates(message as SyncRecord_UpsertRequest)) as SyncRecord_UpsertRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncRecord_UpsertRequest create() => SyncRecord_UpsertRequest._();
  SyncRecord_UpsertRequest createEmptyInstance() => create();
  static $pb.PbList<SyncRecord_UpsertRequest> createRepeated() => $pb.PbList<SyncRecord_UpsertRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncRecord_UpsertRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncRecord_UpsertRequest>(create);
  static SyncRecord_UpsertRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SyncRecord> get results => $_getList(0);
}

class SyncRecord_UpsertResponse extends $pb.GeneratedMessage {
  factory SyncRecord_UpsertResponse() => create();
  SyncRecord_UpsertResponse._() : super();
  factory SyncRecord_UpsertResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncRecord_UpsertResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncRecord.UpsertResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncRecord_UpsertResponse clone() => SyncRecord_UpsertResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncRecord_UpsertResponse copyWith(void Function(SyncRecord_UpsertResponse) updates) => super.copyWith((message) => updates(message as SyncRecord_UpsertResponse)) as SyncRecord_UpsertResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncRecord_UpsertResponse create() => SyncRecord_UpsertResponse._();
  SyncRecord_UpsertResponse createEmptyInstance() => create();
  static $pb.PbList<SyncRecord_UpsertResponse> createRepeated() => $pb.PbList<SyncRecord_UpsertResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncRecord_UpsertResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncRecord_UpsertResponse>(create);
  static SyncRecord_UpsertResponse? _defaultInstance;
}

class SyncRecord extends $pb.GeneratedMessage {
  factory SyncRecord({
    $fixnum.Int64? id,
    $core.int? profileId,
    SyncRecord_State? state,
    $fixnum.Int64? configVersion,
    $core.String? sourcePath,
    $core.String? sourceKey,
    $fixnum.Int64? sourceSize,
    $core.String? sourceHash,
    $core.String? sourceHashAlgorithm,
    $core.String? sourceRevision,
    $1.Timestamp? sourceModifiedAt,
    $core.String? targetPath,
    $fixnum.Int64? targetSize,
    $core.String? targetHash,
    $core.String? targetHashAlgorithm,
    $core.String? targetRevision,
    $1.Timestamp? targetModifiedAt,
    $1.Timestamp? syncedAt,
    $1.Timestamp? tombstoneAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (profileId != null) {
      $result.profileId = profileId;
    }
    if (state != null) {
      $result.state = state;
    }
    if (configVersion != null) {
      $result.configVersion = configVersion;
    }
    if (sourcePath != null) {
      $result.sourcePath = sourcePath;
    }
    if (sourceKey != null) {
      $result.sourceKey = sourceKey;
    }
    if (sourceSize != null) {
      $result.sourceSize = sourceSize;
    }
    if (sourceHash != null) {
      $result.sourceHash = sourceHash;
    }
    if (sourceHashAlgorithm != null) {
      $result.sourceHashAlgorithm = sourceHashAlgorithm;
    }
    if (sourceRevision != null) {
      $result.sourceRevision = sourceRevision;
    }
    if (sourceModifiedAt != null) {
      $result.sourceModifiedAt = sourceModifiedAt;
    }
    if (targetPath != null) {
      $result.targetPath = targetPath;
    }
    if (targetSize != null) {
      $result.targetSize = targetSize;
    }
    if (targetHash != null) {
      $result.targetHash = targetHash;
    }
    if (targetHashAlgorithm != null) {
      $result.targetHashAlgorithm = targetHashAlgorithm;
    }
    if (targetRevision != null) {
      $result.targetRevision = targetRevision;
    }
    if (targetModifiedAt != null) {
      $result.targetModifiedAt = targetModifiedAt;
    }
    if (syncedAt != null) {
      $result.syncedAt = syncedAt;
    }
    if (tombstoneAt != null) {
      $result.tombstoneAt = tombstoneAt;
    }
    return $result;
  }
  SyncRecord._() : super();
  factory SyncRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncRecord', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'profileId', $pb.PbFieldType.O3)
    ..e<SyncRecord_State>(3, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: SyncRecord_State.STATE_UNSPECIFIED, valueOf: SyncRecord_State.valueOf, enumValues: SyncRecord_State.values)
    ..aInt64(4, _omitFieldNames ? '' : 'configVersion')
    ..aOS(5, _omitFieldNames ? '' : 'sourcePath')
    ..aOS(6, _omitFieldNames ? '' : 'sourceKey')
    ..aInt64(7, _omitFieldNames ? '' : 'sourceSize')
    ..aOS(8, _omitFieldNames ? '' : 'sourceHash')
    ..aOS(9, _omitFieldNames ? '' : 'sourceHashAlgorithm')
    ..aOS(10, _omitFieldNames ? '' : 'sourceRevision')
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'sourceModifiedAt', subBuilder: $1.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'targetPath')
    ..aInt64(13, _omitFieldNames ? '' : 'targetSize')
    ..aOS(14, _omitFieldNames ? '' : 'targetHash')
    ..aOS(15, _omitFieldNames ? '' : 'targetHashAlgorithm')
    ..aOS(16, _omitFieldNames ? '' : 'targetRevision')
    ..aOM<$1.Timestamp>(17, _omitFieldNames ? '' : 'targetModifiedAt', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(18, _omitFieldNames ? '' : 'syncedAt', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(19, _omitFieldNames ? '' : 'tombstoneAt', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncRecord clone() => SyncRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncRecord copyWith(void Function(SyncRecord) updates) => super.copyWith((message) => updates(message as SyncRecord)) as SyncRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncRecord create() => SyncRecord._();
  SyncRecord createEmptyInstance() => create();
  static $pb.PbList<SyncRecord> createRepeated() => $pb.PbList<SyncRecord>();
  @$core.pragma('dart2js:noInline')
  static SyncRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncRecord>(create);
  static SyncRecord? _defaultInstance;

  /// @gotags: gorm:"primary_key;auto_increment"
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// @gotags: gorm:"not null;uniqueIndex:idx_sync_record_source_entry,priority:1"
  @$pb.TagNumber(2)
  $core.int get profileId => $_getIZ(1);
  @$pb.TagNumber(2)
  set profileId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProfileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProfileId() => clearField(2);

  @$pb.TagNumber(3)
  SyncRecord_State get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(SyncRecord_State v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => clearField(3);

  /// SyncProfile.config_version when this source item last completed successfully.
  /// An older version cannot be used as a skip baseline.
  @$pb.TagNumber(4)
  $fixnum.Int64 get configVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set configVersion($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasConfigVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearConfigVersion() => clearField(4);

  /// Source container identifier. Album backup uses the album ID;
  /// local_directory uses the file's normalized absolute parent directory.
  /// @gotags: gorm:"not null;uniqueIndex:idx_sync_record_source_entry,priority:2"
  @$pb.TagNumber(5)
  $core.String get sourcePath => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourcePath($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSourcePath() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourcePath() => clearField(5);

  /// Stable item identifier within source_path. Album backup uses the asset ID;
  /// local_directory uses the file name without path separators.
  /// @gotags: gorm:"not null;uniqueIndex:idx_sync_record_source_entry,priority:3"
  @$pb.TagNumber(6)
  $core.String get sourceKey => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceKey($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSourceKey() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceKey() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get sourceSize => $_getI64(6);
  @$pb.TagNumber(7)
  set sourceSize($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSourceSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceSize() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get sourceHash => $_getSZ(7);
  @$pb.TagNumber(8)
  set sourceHash($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSourceHash() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceHash() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get sourceHashAlgorithm => $_getSZ(8);
  @$pb.TagNumber(9)
  set sourceHashAlgorithm($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSourceHashAlgorithm() => $_has(8);
  @$pb.TagNumber(9)
  void clearSourceHashAlgorithm() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get sourceRevision => $_getSZ(9);
  @$pb.TagNumber(10)
  set sourceRevision($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSourceRevision() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceRevision() => clearField(10);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(11)
  $1.Timestamp get sourceModifiedAt => $_getN(10);
  @$pb.TagNumber(11)
  set sourceModifiedAt($1.Timestamp v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasSourceModifiedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearSourceModifiedAt() => clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureSourceModifiedAt() => $_ensure(10);

  /// Full path of the uploaded destination file.
  /// @gotags: gorm:"not null"
  @$pb.TagNumber(12)
  $core.String get targetPath => $_getSZ(11);
  @$pb.TagNumber(12)
  set targetPath($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasTargetPath() => $_has(11);
  @$pb.TagNumber(12)
  void clearTargetPath() => clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get targetSize => $_getI64(12);
  @$pb.TagNumber(13)
  set targetSize($fixnum.Int64 v) { $_setInt64(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasTargetSize() => $_has(12);
  @$pb.TagNumber(13)
  void clearTargetSize() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get targetHash => $_getSZ(13);
  @$pb.TagNumber(14)
  set targetHash($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasTargetHash() => $_has(13);
  @$pb.TagNumber(14)
  void clearTargetHash() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get targetHashAlgorithm => $_getSZ(14);
  @$pb.TagNumber(15)
  set targetHashAlgorithm($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasTargetHashAlgorithm() => $_has(14);
  @$pb.TagNumber(15)
  void clearTargetHashAlgorithm() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get targetRevision => $_getSZ(15);
  @$pb.TagNumber(16)
  set targetRevision($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasTargetRevision() => $_has(15);
  @$pb.TagNumber(16)
  void clearTargetRevision() => clearField(16);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(17)
  $1.Timestamp get targetModifiedAt => $_getN(16);
  @$pb.TagNumber(17)
  set targetModifiedAt($1.Timestamp v) { setField(17, v); }
  @$pb.TagNumber(17)
  $core.bool hasTargetModifiedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearTargetModifiedAt() => clearField(17);
  @$pb.TagNumber(17)
  $1.Timestamp ensureTargetModifiedAt() => $_ensure(16);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(18)
  $1.Timestamp get syncedAt => $_getN(17);
  @$pb.TagNumber(18)
  set syncedAt($1.Timestamp v) { setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasSyncedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearSyncedAt() => clearField(18);
  @$pb.TagNumber(18)
  $1.Timestamp ensureSyncedAt() => $_ensure(17);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(19)
  $1.Timestamp get tombstoneAt => $_getN(18);
  @$pb.TagNumber(19)
  set tombstoneAt($1.Timestamp v) { setField(19, v); }
  @$pb.TagNumber(19)
  $core.bool hasTombstoneAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearTombstoneAt() => clearField(19);
  @$pb.TagNumber(19)
  $1.Timestamp ensureTombstoneAt() => $_ensure(18);
}

class SyncHistory_ListRequest extends $pb.GeneratedMessage {
  factory SyncHistory_ListRequest({
    $core.int? profileId,
    $fixnum.Int64? beforeId,
    $core.int? limit,
  }) {
    final $result = create();
    if (profileId != null) {
      $result.profileId = profileId;
    }
    if (beforeId != null) {
      $result.beforeId = beforeId;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    return $result;
  }
  SyncHistory_ListRequest._() : super();
  factory SyncHistory_ListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistory_ListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistory.ListRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'profileId', $pb.PbFieldType.O3)
    ..aInt64(2, _omitFieldNames ? '' : 'beforeId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistory_ListRequest clone() => SyncHistory_ListRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistory_ListRequest copyWith(void Function(SyncHistory_ListRequest) updates) => super.copyWith((message) => updates(message as SyncHistory_ListRequest)) as SyncHistory_ListRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistory_ListRequest create() => SyncHistory_ListRequest._();
  SyncHistory_ListRequest createEmptyInstance() => create();
  static $pb.PbList<SyncHistory_ListRequest> createRepeated() => $pb.PbList<SyncHistory_ListRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncHistory_ListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistory_ListRequest>(create);
  static SyncHistory_ListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get profileId => $_getIZ(0);
  @$pb.TagNumber(1)
  set profileId($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProfileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProfileId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get beforeId => $_getI64(1);
  @$pb.TagNumber(2)
  set beforeId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBeforeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBeforeId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => clearField(3);
}

class SyncHistory_ListResponse extends $pb.GeneratedMessage {
  factory SyncHistory_ListResponse({
    $core.Iterable<SyncHistory>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  SyncHistory_ListResponse._() : super();
  factory SyncHistory_ListResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistory_ListResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistory.ListResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..pc<SyncHistory>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: SyncHistory.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistory_ListResponse clone() => SyncHistory_ListResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistory_ListResponse copyWith(void Function(SyncHistory_ListResponse) updates) => super.copyWith((message) => updates(message as SyncHistory_ListResponse)) as SyncHistory_ListResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistory_ListResponse create() => SyncHistory_ListResponse._();
  SyncHistory_ListResponse createEmptyInstance() => create();
  static $pb.PbList<SyncHistory_ListResponse> createRepeated() => $pb.PbList<SyncHistory_ListResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncHistory_ListResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistory_ListResponse>(create);
  static SyncHistory_ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SyncHistory> get results => $_getList(0);
}

class SyncHistory_CreateRequest extends $pb.GeneratedMessage {
  factory SyncHistory_CreateRequest({
    SyncHistory? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  SyncHistory_CreateRequest._() : super();
  factory SyncHistory_CreateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistory_CreateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistory.CreateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncHistory>(1, _omitFieldNames ? '' : 'payload', subBuilder: SyncHistory.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistory_CreateRequest clone() => SyncHistory_CreateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistory_CreateRequest copyWith(void Function(SyncHistory_CreateRequest) updates) => super.copyWith((message) => updates(message as SyncHistory_CreateRequest)) as SyncHistory_CreateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistory_CreateRequest create() => SyncHistory_CreateRequest._();
  SyncHistory_CreateRequest createEmptyInstance() => create();
  static $pb.PbList<SyncHistory_CreateRequest> createRepeated() => $pb.PbList<SyncHistory_CreateRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncHistory_CreateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistory_CreateRequest>(create);
  static SyncHistory_CreateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  SyncHistory get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(SyncHistory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  SyncHistory ensurePayload() => $_ensure(0);
}

class SyncHistory_CreateResponse extends $pb.GeneratedMessage {
  factory SyncHistory_CreateResponse({
    SyncHistory? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  SyncHistory_CreateResponse._() : super();
  factory SyncHistory_CreateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistory_CreateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistory.CreateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncHistory>(1, _omitFieldNames ? '' : 'result', subBuilder: SyncHistory.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistory_CreateResponse clone() => SyncHistory_CreateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistory_CreateResponse copyWith(void Function(SyncHistory_CreateResponse) updates) => super.copyWith((message) => updates(message as SyncHistory_CreateResponse)) as SyncHistory_CreateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistory_CreateResponse create() => SyncHistory_CreateResponse._();
  SyncHistory_CreateResponse createEmptyInstance() => create();
  static $pb.PbList<SyncHistory_CreateResponse> createRepeated() => $pb.PbList<SyncHistory_CreateResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncHistory_CreateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistory_CreateResponse>(create);
  static SyncHistory_CreateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SyncHistory get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(SyncHistory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  SyncHistory ensureResult() => $_ensure(0);
}

class SyncHistory_StartRequest extends $pb.GeneratedMessage {
  factory SyncHistory_StartRequest({
    SyncHistory? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  SyncHistory_StartRequest._() : super();
  factory SyncHistory_StartRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistory_StartRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistory.StartRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncHistory>(1, _omitFieldNames ? '' : 'payload', subBuilder: SyncHistory.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistory_StartRequest clone() => SyncHistory_StartRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistory_StartRequest copyWith(void Function(SyncHistory_StartRequest) updates) => super.copyWith((message) => updates(message as SyncHistory_StartRequest)) as SyncHistory_StartRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistory_StartRequest create() => SyncHistory_StartRequest._();
  SyncHistory_StartRequest createEmptyInstance() => create();
  static $pb.PbList<SyncHistory_StartRequest> createRepeated() => $pb.PbList<SyncHistory_StartRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncHistory_StartRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistory_StartRequest>(create);
  static SyncHistory_StartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  SyncHistory get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(SyncHistory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  SyncHistory ensurePayload() => $_ensure(0);
}

class SyncHistory_StartResponse extends $pb.GeneratedMessage {
  factory SyncHistory_StartResponse({
    SyncHistory? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  SyncHistory_StartResponse._() : super();
  factory SyncHistory_StartResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistory_StartResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistory.StartResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncHistory>(1, _omitFieldNames ? '' : 'result', subBuilder: SyncHistory.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistory_StartResponse clone() => SyncHistory_StartResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistory_StartResponse copyWith(void Function(SyncHistory_StartResponse) updates) => super.copyWith((message) => updates(message as SyncHistory_StartResponse)) as SyncHistory_StartResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistory_StartResponse create() => SyncHistory_StartResponse._();
  SyncHistory_StartResponse createEmptyInstance() => create();
  static $pb.PbList<SyncHistory_StartResponse> createRepeated() => $pb.PbList<SyncHistory_StartResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncHistory_StartResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistory_StartResponse>(create);
  static SyncHistory_StartResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SyncHistory get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(SyncHistory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  SyncHistory ensureResult() => $_ensure(0);
}

class SyncHistory_FinishRequest extends $pb.GeneratedMessage {
  factory SyncHistory_FinishRequest({
    SyncHistory? payload,
  }) {
    final $result = create();
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  SyncHistory_FinishRequest._() : super();
  factory SyncHistory_FinishRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistory_FinishRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistory.FinishRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncHistory>(1, _omitFieldNames ? '' : 'payload', subBuilder: SyncHistory.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistory_FinishRequest clone() => SyncHistory_FinishRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistory_FinishRequest copyWith(void Function(SyncHistory_FinishRequest) updates) => super.copyWith((message) => updates(message as SyncHistory_FinishRequest)) as SyncHistory_FinishRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistory_FinishRequest create() => SyncHistory_FinishRequest._();
  SyncHistory_FinishRequest createEmptyInstance() => create();
  static $pb.PbList<SyncHistory_FinishRequest> createRepeated() => $pb.PbList<SyncHistory_FinishRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncHistory_FinishRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistory_FinishRequest>(create);
  static SyncHistory_FinishRequest? _defaultInstance;

  @$pb.TagNumber(1)
  SyncHistory get payload => $_getN(0);
  @$pb.TagNumber(1)
  set payload(SyncHistory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPayload() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayload() => clearField(1);
  @$pb.TagNumber(1)
  SyncHistory ensurePayload() => $_ensure(0);
}

class SyncHistory_FinishResponse extends $pb.GeneratedMessage {
  factory SyncHistory_FinishResponse({
    SyncHistory? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  SyncHistory_FinishResponse._() : super();
  factory SyncHistory_FinishResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistory_FinishResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistory.FinishResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOM<SyncHistory>(1, _omitFieldNames ? '' : 'result', subBuilder: SyncHistory.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistory_FinishResponse clone() => SyncHistory_FinishResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistory_FinishResponse copyWith(void Function(SyncHistory_FinishResponse) updates) => super.copyWith((message) => updates(message as SyncHistory_FinishResponse)) as SyncHistory_FinishResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistory_FinishResponse create() => SyncHistory_FinishResponse._();
  SyncHistory_FinishResponse createEmptyInstance() => create();
  static $pb.PbList<SyncHistory_FinishResponse> createRepeated() => $pb.PbList<SyncHistory_FinishResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncHistory_FinishResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistory_FinishResponse>(create);
  static SyncHistory_FinishResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SyncHistory get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(SyncHistory v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  SyncHistory ensureResult() => $_ensure(0);
}

/// One execution. SyncRecord is the durable state of each source item.
class SyncHistory extends $pb.GeneratedMessage {
  factory SyncHistory({
    $fixnum.Int64? id,
    $core.int? profileId,
    $core.String? runId,
    SyncHistory_Status? status,
    SyncHistory_Trigger? trigger,
    $fixnum.Int64? configVersion,
    $1.Timestamp? startedAt,
    $1.Timestamp? finishedAt,
    $core.int? synced,
    $core.int? skipped,
    $core.int? scanned,
    $core.int? failed,
    $core.int? conflicted,
    $core.String? errorSummary,
    $core.Iterable<SyncHistoryIssue>? issues,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (profileId != null) {
      $result.profileId = profileId;
    }
    if (runId != null) {
      $result.runId = runId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (trigger != null) {
      $result.trigger = trigger;
    }
    if (configVersion != null) {
      $result.configVersion = configVersion;
    }
    if (startedAt != null) {
      $result.startedAt = startedAt;
    }
    if (finishedAt != null) {
      $result.finishedAt = finishedAt;
    }
    if (synced != null) {
      $result.synced = synced;
    }
    if (skipped != null) {
      $result.skipped = skipped;
    }
    if (scanned != null) {
      $result.scanned = scanned;
    }
    if (failed != null) {
      $result.failed = failed;
    }
    if (conflicted != null) {
      $result.conflicted = conflicted;
    }
    if (errorSummary != null) {
      $result.errorSummary = errorSummary;
    }
    if (issues != null) {
      $result.issues.addAll(issues);
    }
    return $result;
  }
  SyncHistory._() : super();
  factory SyncHistory.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistory', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'profileId', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'runId')
    ..e<SyncHistory_Status>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: SyncHistory_Status.STATUS_UNSPECIFIED, valueOf: SyncHistory_Status.valueOf, enumValues: SyncHistory_Status.values)
    ..e<SyncHistory_Trigger>(5, _omitFieldNames ? '' : 'trigger', $pb.PbFieldType.OE, defaultOrMaker: SyncHistory_Trigger.TRIGGER_UNSPECIFIED, valueOf: SyncHistory_Trigger.valueOf, enumValues: SyncHistory_Trigger.values)
    ..aInt64(6, _omitFieldNames ? '' : 'configVersion')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'startedAt', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'finishedAt', subBuilder: $1.Timestamp.create)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'synced', $pb.PbFieldType.O3)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'skipped', $pb.PbFieldType.O3)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'scanned', $pb.PbFieldType.O3)
    ..a<$core.int>(12, _omitFieldNames ? '' : 'failed', $pb.PbFieldType.O3)
    ..a<$core.int>(13, _omitFieldNames ? '' : 'conflicted', $pb.PbFieldType.O3)
    ..aOS(14, _omitFieldNames ? '' : 'errorSummary')
    ..pc<SyncHistoryIssue>(15, _omitFieldNames ? '' : 'issues', $pb.PbFieldType.PM, subBuilder: SyncHistoryIssue.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistory clone() => SyncHistory()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistory copyWith(void Function(SyncHistory) updates) => super.copyWith((message) => updates(message as SyncHistory)) as SyncHistory;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistory create() => SyncHistory._();
  SyncHistory createEmptyInstance() => create();
  static $pb.PbList<SyncHistory> createRepeated() => $pb.PbList<SyncHistory>();
  @$core.pragma('dart2js:noInline')
  static SyncHistory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistory>(create);
  static SyncHistory? _defaultInstance;

  /// @gotags: gorm:"primary_key;auto_increment"
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// @gotags: gorm:"not null;index"
  @$pb.TagNumber(2)
  $core.int get profileId => $_getIZ(1);
  @$pb.TagNumber(2)
  set profileId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProfileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProfileId() => clearField(2);

  /// @gotags: gorm:"not null;uniqueIndex"
  @$pb.TagNumber(3)
  $core.String get runId => $_getSZ(2);
  @$pb.TagNumber(3)
  set runId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRunId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunId() => clearField(3);

  @$pb.TagNumber(4)
  SyncHistory_Status get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(SyncHistory_Status v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  @$pb.TagNumber(5)
  SyncHistory_Trigger get trigger => $_getN(4);
  @$pb.TagNumber(5)
  set trigger(SyncHistory_Trigger v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTrigger() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrigger() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get configVersion => $_getI64(5);
  @$pb.TagNumber(6)
  set configVersion($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasConfigVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearConfigVersion() => clearField(6);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(7)
  $1.Timestamp get startedAt => $_getN(6);
  @$pb.TagNumber(7)
  set startedAt($1.Timestamp v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasStartedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartedAt() => clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureStartedAt() => $_ensure(6);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(8)
  $1.Timestamp get finishedAt => $_getN(7);
  @$pb.TagNumber(8)
  set finishedAt($1.Timestamp v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasFinishedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearFinishedAt() => clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureFinishedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.int get synced => $_getIZ(8);
  @$pb.TagNumber(9)
  set synced($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSynced() => $_has(8);
  @$pb.TagNumber(9)
  void clearSynced() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get skipped => $_getIZ(9);
  @$pb.TagNumber(10)
  set skipped($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSkipped() => $_has(9);
  @$pb.TagNumber(10)
  void clearSkipped() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get scanned => $_getIZ(10);
  @$pb.TagNumber(11)
  set scanned($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasScanned() => $_has(10);
  @$pb.TagNumber(11)
  void clearScanned() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get failed => $_getIZ(11);
  @$pb.TagNumber(12)
  set failed($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasFailed() => $_has(11);
  @$pb.TagNumber(12)
  void clearFailed() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get conflicted => $_getIZ(12);
  @$pb.TagNumber(13)
  set conflicted($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasConflicted() => $_has(12);
  @$pb.TagNumber(13)
  void clearConflicted() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get errorSummary => $_getSZ(13);
  @$pb.TagNumber(14)
  set errorSummary($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasErrorSummary() => $_has(13);
  @$pb.TagNumber(14)
  void clearErrorSummary() => clearField(14);

  /// @gotags: gorm:"-"
  @$pb.TagNumber(15)
  $core.List<SyncHistoryIssue> get issues => $_getList(14);
}

class SyncHistoryIssue_ListRequest extends $pb.GeneratedMessage {
  factory SyncHistoryIssue_ListRequest({
    $core.String? errorCode,
    SyncHistoryIssue_Operation? errorOperation,
    $core.String? sourceKey,
    $fixnum.Int64? beforeId,
    $fixnum.Int64? historyId,
    SyncHistoryIssue_Kind? kind,
    $core.int? limit,
  }) {
    final $result = create();
    if (errorCode != null) {
      $result.errorCode = errorCode;
    }
    if (errorOperation != null) {
      $result.errorOperation = errorOperation;
    }
    if (sourceKey != null) {
      $result.sourceKey = sourceKey;
    }
    if (beforeId != null) {
      $result.beforeId = beforeId;
    }
    if (historyId != null) {
      $result.historyId = historyId;
    }
    if (kind != null) {
      $result.kind = kind;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    return $result;
  }
  SyncHistoryIssue_ListRequest._() : super();
  factory SyncHistoryIssue_ListRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistoryIssue_ListRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistoryIssue.ListRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'errorCode')
    ..e<SyncHistoryIssue_Operation>(2, _omitFieldNames ? '' : 'errorOperation', $pb.PbFieldType.OE, defaultOrMaker: SyncHistoryIssue_Operation.OPERATION_UNSPECIFIED, valueOf: SyncHistoryIssue_Operation.valueOf, enumValues: SyncHistoryIssue_Operation.values)
    ..aOS(3, _omitFieldNames ? '' : 'sourceKey')
    ..aInt64(4, _omitFieldNames ? '' : 'beforeId')
    ..aInt64(5, _omitFieldNames ? '' : 'historyId')
    ..e<SyncHistoryIssue_Kind>(6, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE, defaultOrMaker: SyncHistoryIssue_Kind.KIND_UNSPECIFIED, valueOf: SyncHistoryIssue_Kind.valueOf, enumValues: SyncHistoryIssue_Kind.values)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistoryIssue_ListRequest clone() => SyncHistoryIssue_ListRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistoryIssue_ListRequest copyWith(void Function(SyncHistoryIssue_ListRequest) updates) => super.copyWith((message) => updates(message as SyncHistoryIssue_ListRequest)) as SyncHistoryIssue_ListRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistoryIssue_ListRequest create() => SyncHistoryIssue_ListRequest._();
  SyncHistoryIssue_ListRequest createEmptyInstance() => create();
  static $pb.PbList<SyncHistoryIssue_ListRequest> createRepeated() => $pb.PbList<SyncHistoryIssue_ListRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncHistoryIssue_ListRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistoryIssue_ListRequest>(create);
  static SyncHistoryIssue_ListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get errorCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set errorCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasErrorCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearErrorCode() => clearField(1);

  @$pb.TagNumber(2)
  SyncHistoryIssue_Operation get errorOperation => $_getN(1);
  @$pb.TagNumber(2)
  set errorOperation(SyncHistoryIssue_Operation v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasErrorOperation() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorOperation() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sourceKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set sourceKey($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSourceKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceKey() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get beforeId => $_getI64(3);
  @$pb.TagNumber(4)
  set beforeId($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBeforeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearBeforeId() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get historyId => $_getI64(4);
  @$pb.TagNumber(5)
  set historyId($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHistoryId() => $_has(4);
  @$pb.TagNumber(5)
  void clearHistoryId() => clearField(5);

  @$pb.TagNumber(6)
  SyncHistoryIssue_Kind get kind => $_getN(5);
  @$pb.TagNumber(6)
  set kind(SyncHistoryIssue_Kind v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasKind() => $_has(5);
  @$pb.TagNumber(6)
  void clearKind() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get limit => $_getIZ(6);
  @$pb.TagNumber(7)
  set limit($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLimit() => $_has(6);
  @$pb.TagNumber(7)
  void clearLimit() => clearField(7);
}

class SyncHistoryIssue_ListResponse extends $pb.GeneratedMessage {
  factory SyncHistoryIssue_ListResponse({
    $core.Iterable<SyncHistoryIssue>? results,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    return $result;
  }
  SyncHistoryIssue_ListResponse._() : super();
  factory SyncHistoryIssue_ListResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistoryIssue_ListResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistoryIssue.ListResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..pc<SyncHistoryIssue>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: SyncHistoryIssue.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistoryIssue_ListResponse clone() => SyncHistoryIssue_ListResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistoryIssue_ListResponse copyWith(void Function(SyncHistoryIssue_ListResponse) updates) => super.copyWith((message) => updates(message as SyncHistoryIssue_ListResponse)) as SyncHistoryIssue_ListResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistoryIssue_ListResponse create() => SyncHistoryIssue_ListResponse._();
  SyncHistoryIssue_ListResponse createEmptyInstance() => create();
  static $pb.PbList<SyncHistoryIssue_ListResponse> createRepeated() => $pb.PbList<SyncHistoryIssue_ListResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncHistoryIssue_ListResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistoryIssue_ListResponse>(create);
  static SyncHistoryIssue_ListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SyncHistoryIssue> get results => $_getList(0);
}

class SyncHistoryIssue extends $pb.GeneratedMessage {
  factory SyncHistoryIssue({
    $fixnum.Int64? id,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $fixnum.Int64? historyId,
    $core.String? errorCode,
    $core.String? errorMessage,
    SyncHistoryIssue_Operation? errorOperation,
    SyncHistoryIssue_Kind? kind,
    $core.String? context,
    $core.String? sourceKey,
    $core.String? sourcePath,
    $core.String? sourceLabel,
    $core.String? targetPath,
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
    if (historyId != null) {
      $result.historyId = historyId;
    }
    if (errorCode != null) {
      $result.errorCode = errorCode;
    }
    if (errorMessage != null) {
      $result.errorMessage = errorMessage;
    }
    if (errorOperation != null) {
      $result.errorOperation = errorOperation;
    }
    if (kind != null) {
      $result.kind = kind;
    }
    if (context != null) {
      $result.context = context;
    }
    if (sourceKey != null) {
      $result.sourceKey = sourceKey;
    }
    if (sourcePath != null) {
      $result.sourcePath = sourcePath;
    }
    if (sourceLabel != null) {
      $result.sourceLabel = sourceLabel;
    }
    if (targetPath != null) {
      $result.targetPath = targetPath;
    }
    return $result;
  }
  SyncHistoryIssue._() : super();
  factory SyncHistoryIssue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncHistoryIssue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncHistoryIssue', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.syncing'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'createdAt', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'updatedAt', subBuilder: $1.Timestamp.create)
    ..aInt64(4, _omitFieldNames ? '' : 'historyId')
    ..aOS(5, _omitFieldNames ? '' : 'errorCode')
    ..aOS(6, _omitFieldNames ? '' : 'errorMessage')
    ..e<SyncHistoryIssue_Operation>(7, _omitFieldNames ? '' : 'errorOperation', $pb.PbFieldType.OE, defaultOrMaker: SyncHistoryIssue_Operation.OPERATION_UNSPECIFIED, valueOf: SyncHistoryIssue_Operation.valueOf, enumValues: SyncHistoryIssue_Operation.values)
    ..e<SyncHistoryIssue_Kind>(8, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE, defaultOrMaker: SyncHistoryIssue_Kind.KIND_UNSPECIFIED, valueOf: SyncHistoryIssue_Kind.valueOf, enumValues: SyncHistoryIssue_Kind.values)
    ..aOS(9, _omitFieldNames ? '' : 'context')
    ..aOS(10, _omitFieldNames ? '' : 'sourceKey')
    ..aOS(11, _omitFieldNames ? '' : 'sourcePath')
    ..aOS(12, _omitFieldNames ? '' : 'sourceLabel')
    ..aOS(13, _omitFieldNames ? '' : 'targetPath')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncHistoryIssue clone() => SyncHistoryIssue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncHistoryIssue copyWith(void Function(SyncHistoryIssue) updates) => super.copyWith((message) => updates(message as SyncHistoryIssue)) as SyncHistoryIssue;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncHistoryIssue create() => SyncHistoryIssue._();
  SyncHistoryIssue createEmptyInstance() => create();
  static $pb.PbList<SyncHistoryIssue> createRepeated() => $pb.PbList<SyncHistoryIssue>();
  @$core.pragma('dart2js:noInline')
  static SyncHistoryIssue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncHistoryIssue>(create);
  static SyncHistoryIssue? _defaultInstance;

  /// @gotags: gorm:"primary_key;auto_increment"
  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(2)
  $1.Timestamp get createdAt => $_getN(1);
  @$pb.TagNumber(2)
  set createdAt($1.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCreatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearCreatedAt() => clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureCreatedAt() => $_ensure(1);

  /// @gotags: gorm:"serializer:protobuf_timestamp;type:datetime"
  @$pb.TagNumber(3)
  $1.Timestamp get updatedAt => $_getN(2);
  @$pb.TagNumber(3)
  set updatedAt($1.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatedAt() => clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureUpdatedAt() => $_ensure(2);

  /// @gotags: gorm:"not null;index:idx_sync_issue_history_kind"
  @$pb.TagNumber(4)
  $fixnum.Int64 get historyId => $_getI64(3);
  @$pb.TagNumber(4)
  set historyId($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHistoryId() => $_has(3);
  @$pb.TagNumber(4)
  void clearHistoryId() => clearField(4);

  /// @gotags: gorm:"index"
  @$pb.TagNumber(5)
  $core.String get errorCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorCode($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasErrorCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorCode() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get errorMessage => $_getSZ(5);
  @$pb.TagNumber(6)
  set errorMessage($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasErrorMessage() => $_has(5);
  @$pb.TagNumber(6)
  void clearErrorMessage() => clearField(6);

  @$pb.TagNumber(7)
  SyncHistoryIssue_Operation get errorOperation => $_getN(6);
  @$pb.TagNumber(7)
  set errorOperation(SyncHistoryIssue_Operation v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasErrorOperation() => $_has(6);
  @$pb.TagNumber(7)
  void clearErrorOperation() => clearField(7);

  /// @gotags: gorm:"index:idx_sync_issue_history_kind"
  @$pb.TagNumber(8)
  SyncHistoryIssue_Kind get kind => $_getN(7);
  @$pb.TagNumber(8)
  set kind(SyncHistoryIssue_Kind v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasKind() => $_has(7);
  @$pb.TagNumber(8)
  void clearKind() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get context => $_getSZ(8);
  @$pb.TagNumber(9)
  set context($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasContext() => $_has(8);
  @$pb.TagNumber(9)
  void clearContext() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get sourceKey => $_getSZ(9);
  @$pb.TagNumber(10)
  set sourceKey($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSourceKey() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceKey() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get sourcePath => $_getSZ(10);
  @$pb.TagNumber(11)
  set sourcePath($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasSourcePath() => $_has(10);
  @$pb.TagNumber(11)
  void clearSourcePath() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get sourceLabel => $_getSZ(11);
  @$pb.TagNumber(12)
  set sourceLabel($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasSourceLabel() => $_has(11);
  @$pb.TagNumber(12)
  void clearSourceLabel() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get targetPath => $_getSZ(12);
  @$pb.TagNumber(13)
  set targetPath($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasTargetPath() => $_has(12);
  @$pb.TagNumber(13)
  void clearTargetPath() => clearField(13);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');

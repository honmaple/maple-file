//
//  Generated code. Do not modify.
//  source: api/file/server.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ExternalServer_GetRequest extends $pb.GeneratedMessage {
  factory ExternalServer_GetRequest({
    $core.String? type,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    return $result;
  }
  ExternalServer_GetRequest._() : super();
  factory ExternalServer_GetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExternalServer_GetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExternalServer.GetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExternalServer_GetRequest clone() => ExternalServer_GetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExternalServer_GetRequest copyWith(void Function(ExternalServer_GetRequest) updates) => super.copyWith((message) => updates(message as ExternalServer_GetRequest)) as ExternalServer_GetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExternalServer_GetRequest create() => ExternalServer_GetRequest._();
  ExternalServer_GetRequest createEmptyInstance() => create();
  static $pb.PbList<ExternalServer_GetRequest> createRepeated() => $pb.PbList<ExternalServer_GetRequest>();
  @$core.pragma('dart2js:noInline')
  static ExternalServer_GetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExternalServer_GetRequest>(create);
  static ExternalServer_GetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);
}

class ExternalServer_GetResponse extends $pb.GeneratedMessage {
  factory ExternalServer_GetResponse({
    ExternalServer? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  ExternalServer_GetResponse._() : super();
  factory ExternalServer_GetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExternalServer_GetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExternalServer.GetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<ExternalServer>(1, _omitFieldNames ? '' : 'result', subBuilder: ExternalServer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExternalServer_GetResponse clone() => ExternalServer_GetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExternalServer_GetResponse copyWith(void Function(ExternalServer_GetResponse) updates) => super.copyWith((message) => updates(message as ExternalServer_GetResponse)) as ExternalServer_GetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExternalServer_GetResponse create() => ExternalServer_GetResponse._();
  ExternalServer_GetResponse createEmptyInstance() => create();
  static $pb.PbList<ExternalServer_GetResponse> createRepeated() => $pb.PbList<ExternalServer_GetResponse>();
  @$core.pragma('dart2js:noInline')
  static ExternalServer_GetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExternalServer_GetResponse>(create);
  static ExternalServer_GetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ExternalServer get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(ExternalServer v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  ExternalServer ensureResult() => $_ensure(0);
}

class ExternalServer_StartRequest extends $pb.GeneratedMessage {
  factory ExternalServer_StartRequest({
    $core.String? type,
    $core.String? option,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (option != null) {
      $result.option = option;
    }
    return $result;
  }
  ExternalServer_StartRequest._() : super();
  factory ExternalServer_StartRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExternalServer_StartRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExternalServer.StartRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'option')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExternalServer_StartRequest clone() => ExternalServer_StartRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExternalServer_StartRequest copyWith(void Function(ExternalServer_StartRequest) updates) => super.copyWith((message) => updates(message as ExternalServer_StartRequest)) as ExternalServer_StartRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExternalServer_StartRequest create() => ExternalServer_StartRequest._();
  ExternalServer_StartRequest createEmptyInstance() => create();
  static $pb.PbList<ExternalServer_StartRequest> createRepeated() => $pb.PbList<ExternalServer_StartRequest>();
  @$core.pragma('dart2js:noInline')
  static ExternalServer_StartRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExternalServer_StartRequest>(create);
  static ExternalServer_StartRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get option => $_getSZ(1);
  @$pb.TagNumber(2)
  set option($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOption() => $_has(1);
  @$pb.TagNumber(2)
  void clearOption() => clearField(2);
}

class ExternalServer_StartResponse extends $pb.GeneratedMessage {
  factory ExternalServer_StartResponse({
    ExternalServer? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  ExternalServer_StartResponse._() : super();
  factory ExternalServer_StartResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExternalServer_StartResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExternalServer.StartResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<ExternalServer>(1, _omitFieldNames ? '' : 'result', subBuilder: ExternalServer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExternalServer_StartResponse clone() => ExternalServer_StartResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExternalServer_StartResponse copyWith(void Function(ExternalServer_StartResponse) updates) => super.copyWith((message) => updates(message as ExternalServer_StartResponse)) as ExternalServer_StartResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExternalServer_StartResponse create() => ExternalServer_StartResponse._();
  ExternalServer_StartResponse createEmptyInstance() => create();
  static $pb.PbList<ExternalServer_StartResponse> createRepeated() => $pb.PbList<ExternalServer_StartResponse>();
  @$core.pragma('dart2js:noInline')
  static ExternalServer_StartResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExternalServer_StartResponse>(create);
  static ExternalServer_StartResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ExternalServer get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(ExternalServer v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  ExternalServer ensureResult() => $_ensure(0);
}

class ExternalServer_StopRequest extends $pb.GeneratedMessage {
  factory ExternalServer_StopRequest({
    $core.String? type,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    return $result;
  }
  ExternalServer_StopRequest._() : super();
  factory ExternalServer_StopRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExternalServer_StopRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExternalServer.StopRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExternalServer_StopRequest clone() => ExternalServer_StopRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExternalServer_StopRequest copyWith(void Function(ExternalServer_StopRequest) updates) => super.copyWith((message) => updates(message as ExternalServer_StopRequest)) as ExternalServer_StopRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExternalServer_StopRequest create() => ExternalServer_StopRequest._();
  ExternalServer_StopRequest createEmptyInstance() => create();
  static $pb.PbList<ExternalServer_StopRequest> createRepeated() => $pb.PbList<ExternalServer_StopRequest>();
  @$core.pragma('dart2js:noInline')
  static ExternalServer_StopRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExternalServer_StopRequest>(create);
  static ExternalServer_StopRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);
}

class ExternalServer_StopResponse extends $pb.GeneratedMessage {
  factory ExternalServer_StopResponse() => create();
  ExternalServer_StopResponse._() : super();
  factory ExternalServer_StopResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExternalServer_StopResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExternalServer.StopResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExternalServer_StopResponse clone() => ExternalServer_StopResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExternalServer_StopResponse copyWith(void Function(ExternalServer_StopResponse) updates) => super.copyWith((message) => updates(message as ExternalServer_StopResponse)) as ExternalServer_StopResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExternalServer_StopResponse create() => ExternalServer_StopResponse._();
  ExternalServer_StopResponse createEmptyInstance() => create();
  static $pb.PbList<ExternalServer_StopResponse> createRepeated() => $pb.PbList<ExternalServer_StopResponse>();
  @$core.pragma('dart2js:noInline')
  static ExternalServer_StopResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExternalServer_StopResponse>(create);
  static ExternalServer_StopResponse? _defaultInstance;
}

class ExternalServer extends $pb.GeneratedMessage {
  factory ExternalServer({
    $core.String? addr,
    $core.bool? running,
    $core.String? error,
  }) {
    final $result = create();
    if (addr != null) {
      $result.addr = addr;
    }
    if (running != null) {
      $result.running = running;
    }
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  ExternalServer._() : super();
  factory ExternalServer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExternalServer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExternalServer', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'addr')
    ..aOB(2, _omitFieldNames ? '' : 'running')
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExternalServer clone() => ExternalServer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExternalServer copyWith(void Function(ExternalServer) updates) => super.copyWith((message) => updates(message as ExternalServer)) as ExternalServer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExternalServer create() => ExternalServer._();
  ExternalServer createEmptyInstance() => create();
  static $pb.PbList<ExternalServer> createRepeated() => $pb.PbList<ExternalServer>();
  @$core.pragma('dart2js:noInline')
  static ExternalServer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExternalServer>(create);
  static ExternalServer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get addr => $_getSZ(0);
  @$pb.TagNumber(1)
  set addr($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddr() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddr() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get running => $_getBF(1);
  @$pb.TagNumber(2)
  set running($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRunning() => $_has(1);
  @$pb.TagNumber(2)
  void clearRunning() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get error => $_getSZ(2);
  @$pb.TagNumber(3)
  set error($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasError() => $_has(2);
  @$pb.TagNumber(3)
  void clearError() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');

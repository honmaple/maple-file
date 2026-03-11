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

class Server_GetRequest extends $pb.GeneratedMessage {
  factory Server_GetRequest({
    $core.String? type,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    return $result;
  }
  Server_GetRequest._() : super();
  factory Server_GetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Server_GetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Server.GetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Server_GetRequest clone() => Server_GetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Server_GetRequest copyWith(void Function(Server_GetRequest) updates) => super.copyWith((message) => updates(message as Server_GetRequest)) as Server_GetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Server_GetRequest create() => Server_GetRequest._();
  Server_GetRequest createEmptyInstance() => create();
  static $pb.PbList<Server_GetRequest> createRepeated() => $pb.PbList<Server_GetRequest>();
  @$core.pragma('dart2js:noInline')
  static Server_GetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Server_GetRequest>(create);
  static Server_GetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);
}

class Server_GetResponse extends $pb.GeneratedMessage {
  factory Server_GetResponse({
    Server? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  Server_GetResponse._() : super();
  factory Server_GetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Server_GetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Server.GetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<Server>(1, _omitFieldNames ? '' : 'result', subBuilder: Server.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Server_GetResponse clone() => Server_GetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Server_GetResponse copyWith(void Function(Server_GetResponse) updates) => super.copyWith((message) => updates(message as Server_GetResponse)) as Server_GetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Server_GetResponse create() => Server_GetResponse._();
  Server_GetResponse createEmptyInstance() => create();
  static $pb.PbList<Server_GetResponse> createRepeated() => $pb.PbList<Server_GetResponse>();
  @$core.pragma('dart2js:noInline')
  static Server_GetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Server_GetResponse>(create);
  static Server_GetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Server get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(Server v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  Server ensureResult() => $_ensure(0);
}

class Server_StartRequest extends $pb.GeneratedMessage {
  factory Server_StartRequest({
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
  Server_StartRequest._() : super();
  factory Server_StartRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Server_StartRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Server.StartRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..aOS(2, _omitFieldNames ? '' : 'option')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Server_StartRequest clone() => Server_StartRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Server_StartRequest copyWith(void Function(Server_StartRequest) updates) => super.copyWith((message) => updates(message as Server_StartRequest)) as Server_StartRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Server_StartRequest create() => Server_StartRequest._();
  Server_StartRequest createEmptyInstance() => create();
  static $pb.PbList<Server_StartRequest> createRepeated() => $pb.PbList<Server_StartRequest>();
  @$core.pragma('dart2js:noInline')
  static Server_StartRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Server_StartRequest>(create);
  static Server_StartRequest? _defaultInstance;

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

class Server_StartResponse extends $pb.GeneratedMessage {
  factory Server_StartResponse({
    Server? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  Server_StartResponse._() : super();
  factory Server_StartResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Server_StartResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Server.StartResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOM<Server>(1, _omitFieldNames ? '' : 'result', subBuilder: Server.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Server_StartResponse clone() => Server_StartResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Server_StartResponse copyWith(void Function(Server_StartResponse) updates) => super.copyWith((message) => updates(message as Server_StartResponse)) as Server_StartResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Server_StartResponse create() => Server_StartResponse._();
  Server_StartResponse createEmptyInstance() => create();
  static $pb.PbList<Server_StartResponse> createRepeated() => $pb.PbList<Server_StartResponse>();
  @$core.pragma('dart2js:noInline')
  static Server_StartResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Server_StartResponse>(create);
  static Server_StartResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Server get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(Server v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  Server ensureResult() => $_ensure(0);
}

class Server_StopRequest extends $pb.GeneratedMessage {
  factory Server_StopRequest({
    $core.String? type,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    return $result;
  }
  Server_StopRequest._() : super();
  factory Server_StopRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Server_StopRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Server.StopRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Server_StopRequest clone() => Server_StopRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Server_StopRequest copyWith(void Function(Server_StopRequest) updates) => super.copyWith((message) => updates(message as Server_StopRequest)) as Server_StopRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Server_StopRequest create() => Server_StopRequest._();
  Server_StopRequest createEmptyInstance() => create();
  static $pb.PbList<Server_StopRequest> createRepeated() => $pb.PbList<Server_StopRequest>();
  @$core.pragma('dart2js:noInline')
  static Server_StopRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Server_StopRequest>(create);
  static Server_StopRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get type => $_getSZ(0);
  @$pb.TagNumber(1)
  set type($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);
}

class Server_StopResponse extends $pb.GeneratedMessage {
  factory Server_StopResponse() => create();
  Server_StopResponse._() : super();
  factory Server_StopResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Server_StopResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Server.StopResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Server_StopResponse clone() => Server_StopResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Server_StopResponse copyWith(void Function(Server_StopResponse) updates) => super.copyWith((message) => updates(message as Server_StopResponse)) as Server_StopResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Server_StopResponse create() => Server_StopResponse._();
  Server_StopResponse createEmptyInstance() => create();
  static $pb.PbList<Server_StopResponse> createRepeated() => $pb.PbList<Server_StopResponse>();
  @$core.pragma('dart2js:noInline')
  static Server_StopResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Server_StopResponse>(create);
  static Server_StopResponse? _defaultInstance;
}

class Server extends $pb.GeneratedMessage {
  factory Server({
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
  Server._() : super();
  factory Server.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Server.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Server', package: const $pb.PackageName(_omitMessageNames ? '' : 'api.file'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'addr')
    ..aOB(2, _omitFieldNames ? '' : 'running')
    ..aOS(3, _omitFieldNames ? '' : 'error')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Server clone() => Server()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Server copyWith(void Function(Server) updates) => super.copyWith((message) => updates(message as Server)) as Server;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Server create() => Server._();
  Server createEmptyInstance() => create();
  static $pb.PbList<Server> createRepeated() => $pb.PbList<Server>();
  @$core.pragma('dart2js:noInline')
  static Server getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Server>(create);
  static Server? _defaultInstance;

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

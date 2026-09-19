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

import 'package:protobuf/protobuf.dart' as $pb;

class SyncProfile_Mode extends $pb.ProtobufEnum {
  static const SyncProfile_Mode MODE_UNSPECIFIED = SyncProfile_Mode._(0, _omitEnumNames ? '' : 'MODE_UNSPECIFIED');
  static const SyncProfile_Mode MODE_BACKUP = SyncProfile_Mode._(1, _omitEnumNames ? '' : 'MODE_BACKUP');
  static const SyncProfile_Mode MODE_ONE_WAY = SyncProfile_Mode._(2, _omitEnumNames ? '' : 'MODE_ONE_WAY');
  static const SyncProfile_Mode MODE_TWO_WAY = SyncProfile_Mode._(3, _omitEnumNames ? '' : 'MODE_TWO_WAY');

  static const $core.List<SyncProfile_Mode> values = <SyncProfile_Mode> [
    MODE_UNSPECIFIED,
    MODE_BACKUP,
    MODE_ONE_WAY,
    MODE_TWO_WAY,
  ];

  static final $core.Map<$core.int, SyncProfile_Mode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SyncProfile_Mode? valueOf($core.int value) => _byValue[value];

  const SyncProfile_Mode._($core.int v, $core.String n) : super(v, n);
}

class SyncRecord_State extends $pb.ProtobufEnum {
  static const SyncRecord_State STATE_UNSPECIFIED = SyncRecord_State._(0, _omitEnumNames ? '' : 'STATE_UNSPECIFIED');
  static const SyncRecord_State STATE_ACTIVE = SyncRecord_State._(1, _omitEnumNames ? '' : 'STATE_ACTIVE');
  static const SyncRecord_State STATE_TOMBSTONE = SyncRecord_State._(2, _omitEnumNames ? '' : 'STATE_TOMBSTONE');

  static const $core.List<SyncRecord_State> values = <SyncRecord_State> [
    STATE_UNSPECIFIED,
    STATE_ACTIVE,
    STATE_TOMBSTONE,
  ];

  static final $core.Map<$core.int, SyncRecord_State> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SyncRecord_State? valueOf($core.int value) => _byValue[value];

  const SyncRecord_State._($core.int v, $core.String n) : super(v, n);
}

class SyncHistory_Status extends $pb.ProtobufEnum {
  static const SyncHistory_Status STATUS_UNSPECIFIED = SyncHistory_Status._(0, _omitEnumNames ? '' : 'STATUS_UNSPECIFIED');
  static const SyncHistory_Status STATUS_RUNNING = SyncHistory_Status._(1, _omitEnumNames ? '' : 'STATUS_RUNNING');
  static const SyncHistory_Status STATUS_SUCCEEDED = SyncHistory_Status._(2, _omitEnumNames ? '' : 'STATUS_SUCCEEDED');
  static const SyncHistory_Status STATUS_PARTIAL = SyncHistory_Status._(3, _omitEnumNames ? '' : 'STATUS_PARTIAL');
  static const SyncHistory_Status STATUS_FAILED = SyncHistory_Status._(4, _omitEnumNames ? '' : 'STATUS_FAILED');
  static const SyncHistory_Status STATUS_INTERRUPTED = SyncHistory_Status._(5, _omitEnumNames ? '' : 'STATUS_INTERRUPTED');
  static const SyncHistory_Status STATUS_CANCELED = SyncHistory_Status._(6, _omitEnumNames ? '' : 'STATUS_CANCELED');

  static const $core.List<SyncHistory_Status> values = <SyncHistory_Status> [
    STATUS_UNSPECIFIED,
    STATUS_RUNNING,
    STATUS_SUCCEEDED,
    STATUS_PARTIAL,
    STATUS_FAILED,
    STATUS_INTERRUPTED,
    STATUS_CANCELED,
  ];

  static final $core.Map<$core.int, SyncHistory_Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SyncHistory_Status? valueOf($core.int value) => _byValue[value];

  const SyncHistory_Status._($core.int v, $core.String n) : super(v, n);
}

class SyncHistory_Trigger extends $pb.ProtobufEnum {
  static const SyncHistory_Trigger TRIGGER_UNSPECIFIED = SyncHistory_Trigger._(0, _omitEnumNames ? '' : 'TRIGGER_UNSPECIFIED');
  static const SyncHistory_Trigger TRIGGER_MANUAL = SyncHistory_Trigger._(1, _omitEnumNames ? '' : 'TRIGGER_MANUAL');
  static const SyncHistory_Trigger TRIGGER_SCHEDULED = SyncHistory_Trigger._(2, _omitEnumNames ? '' : 'TRIGGER_SCHEDULED');
  static const SyncHistory_Trigger TRIGGER_RETRY = SyncHistory_Trigger._(3, _omitEnumNames ? '' : 'TRIGGER_RETRY');

  static const $core.List<SyncHistory_Trigger> values = <SyncHistory_Trigger> [
    TRIGGER_UNSPECIFIED,
    TRIGGER_MANUAL,
    TRIGGER_SCHEDULED,
    TRIGGER_RETRY,
  ];

  static final $core.Map<$core.int, SyncHistory_Trigger> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SyncHistory_Trigger? valueOf($core.int value) => _byValue[value];

  const SyncHistory_Trigger._($core.int v, $core.String n) : super(v, n);
}

class SyncHistoryIssue_Kind extends $pb.ProtobufEnum {
  static const SyncHistoryIssue_Kind KIND_UNSPECIFIED = SyncHistoryIssue_Kind._(0, _omitEnumNames ? '' : 'KIND_UNSPECIFIED');
  static const SyncHistoryIssue_Kind KIND_ERROR = SyncHistoryIssue_Kind._(1, _omitEnumNames ? '' : 'KIND_ERROR');
  static const SyncHistoryIssue_Kind KIND_CONFLICT = SyncHistoryIssue_Kind._(2, _omitEnumNames ? '' : 'KIND_CONFLICT');

  static const $core.List<SyncHistoryIssue_Kind> values = <SyncHistoryIssue_Kind> [
    KIND_UNSPECIFIED,
    KIND_ERROR,
    KIND_CONFLICT,
  ];

  static final $core.Map<$core.int, SyncHistoryIssue_Kind> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SyncHistoryIssue_Kind? valueOf($core.int value) => _byValue[value];

  const SyncHistoryIssue_Kind._($core.int v, $core.String n) : super(v, n);
}

class SyncHistoryIssue_Operation extends $pb.ProtobufEnum {
  static const SyncHistoryIssue_Operation OPERATION_UNSPECIFIED = SyncHistoryIssue_Operation._(0, _omitEnumNames ? '' : 'OPERATION_UNSPECIFIED');
  static const SyncHistoryIssue_Operation OPERATION_SCAN = SyncHistoryIssue_Operation._(1, _omitEnumNames ? '' : 'OPERATION_SCAN');
  static const SyncHistoryIssue_Operation OPERATION_UPLOAD = SyncHistoryIssue_Operation._(2, _omitEnumNames ? '' : 'OPERATION_UPLOAD');
  static const SyncHistoryIssue_Operation OPERATION_DOWNLOAD = SyncHistoryIssue_Operation._(3, _omitEnumNames ? '' : 'OPERATION_DOWNLOAD');
  static const SyncHistoryIssue_Operation OPERATION_DELETE = SyncHistoryIssue_Operation._(4, _omitEnumNames ? '' : 'OPERATION_DELETE');
  static const SyncHistoryIssue_Operation OPERATION_VERIFY = SyncHistoryIssue_Operation._(5, _omitEnumNames ? '' : 'OPERATION_VERIFY');

  static const $core.List<SyncHistoryIssue_Operation> values = <SyncHistoryIssue_Operation> [
    OPERATION_UNSPECIFIED,
    OPERATION_SCAN,
    OPERATION_UPLOAD,
    OPERATION_DOWNLOAD,
    OPERATION_DELETE,
    OPERATION_VERIFY,
  ];

  static final $core.Map<$core.int, SyncHistoryIssue_Operation> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SyncHistoryIssue_Operation? valueOf($core.int value) => _byValue[value];

  const SyncHistoryIssue_Operation._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');

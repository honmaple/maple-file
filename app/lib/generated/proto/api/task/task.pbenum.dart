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

class TaskState extends $pb.ProtobufEnum {
  static const TaskState TASK_STATE_UNSPECIFIED = TaskState._(0, _omitEnumNames ? '' : 'TASK_STATE_UNSPECIFIED');
  static const TaskState TASK_STATE_RUNNING = TaskState._(1, _omitEnumNames ? '' : 'TASK_STATE_RUNNING');
  static const TaskState TASK_STATE_SUCCEEDED = TaskState._(2, _omitEnumNames ? '' : 'TASK_STATE_SUCCEEDED');
  static const TaskState TASK_STATE_CANCELING = TaskState._(3, _omitEnumNames ? '' : 'TASK_STATE_CANCELING');
  static const TaskState TASK_STATE_CANCELED = TaskState._(4, _omitEnumNames ? '' : 'TASK_STATE_CANCELED');
  static const TaskState TASK_STATE_FAILED = TaskState._(5, _omitEnumNames ? '' : 'TASK_STATE_FAILED');

  static const TaskState TASK_STATE_PENDING = TASK_STATE_UNSPECIFIED;

  static const $core.List<TaskState> values = <TaskState> [
    TASK_STATE_UNSPECIFIED,
    TASK_STATE_RUNNING,
    TASK_STATE_SUCCEEDED,
    TASK_STATE_CANCELING,
    TASK_STATE_CANCELED,
    TASK_STATE_FAILED,
  ];

  static final $core.Map<$core.int, TaskState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TaskState? valueOf($core.int value) => _byValue[value];

  const TaskState._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');

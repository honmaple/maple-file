import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/generated/proto/api/task/task.pb.dart';

import 'service.dart';

enum TaskType {
  running,
  finished,
  failed,
}

extension TaskTypeExtension on TaskType {
  String label(BuildContext context) {
    Map<TaskType, String> labels = {
      TaskType.running: "正在进行".tr(context),
      TaskType.finished: "已完成".tr(context),
      TaskType.failed: "已失败".tr(context),
    };
    return labels[this] ?? "未知状态".tr(context);
  }
}

extension TaskStateExtension on TaskState {
  String label(BuildContext context) {
    Map<TaskState, String> labels = {
      TaskState.TASK_STATE_PENDING: "等待执行".tr(context),
      TaskState.TASK_STATE_RUNNING: "正在执行".tr(context),
      TaskState.TASK_STATE_SUCCEEDED: "执行成功".tr(context),
      TaskState.TASK_STATE_CANCELING: "正在取消".tr(context),
      TaskState.TASK_STATE_CANCELED: "已取消".tr(context),
      TaskState.TASK_STATE_FAILED: "执行失败".tr(context),
    };

    return labels[this] ?? "未知状态".tr(context);
  }
}

bool isRunning(Task item) {
  return item.state == TaskState.TASK_STATE_PENDING ||
      item.state == TaskState.TASK_STATE_RUNNING ||
      item.state == TaskState.TASK_STATE_CANCELING;
}

bool isFinished(Task item) {
  return item.state == TaskState.TASK_STATE_CANCELED ||
      item.state == TaskState.TASK_STATE_SUCCEEDED;
}

bool isFailed(Task item) {
  return item.state == TaskState.TASK_STATE_FAILED;
}

void refreshTaskProvider(WidgetRef ref) {
  ref.invalidate(taskProvider(TaskType.running));
  ref.invalidate(taskProvider(TaskType.finished));
  ref.invalidate(taskProvider(TaskType.failed));
}

class TaskNotifier extends FamilyAsyncNotifier<List<Task>, TaskType> {
  final _service = TaskService();

  @override
  FutureOr<List<Task>> build(arg) async {
    List<Task> results = await _service.listTasks();

    switch (arg) {
      case TaskType.running:
        return results.where(isRunning).toList();
      case TaskType.finished:
        return results.where(isFinished).toList();
      case TaskType.failed:
        return results.where(isFailed).toList();
    }
  }
}

class TaskCountNotifier extends FamilyNotifier<int, TaskType> {
  @override
  int build(arg) {
    final tasks = ref.watch(taskProvider(arg)).valueOrNull ?? <Task>[];
    return tasks.length;
  }
}

final taskProvider =
    AsyncNotifierProvider.family<TaskNotifier, List<Task>, TaskType>(() {
  return TaskNotifier();
});
final taskRunningProvider =
    AsyncNotifierProvider.family<TaskNotifier, List<Task>, TaskType>(() {
  return TaskNotifier();
});
final taskCountProvider =
    NotifierProvider.family<TaskCountNotifier, int, TaskType>(() {
  return TaskCountNotifier();
});

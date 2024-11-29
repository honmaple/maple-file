import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/generated/proto/api/task/task.pb.dart';

import 'service.dart';

Map<TaskState, String> stateLabel = {
  TaskState.TASK_STATE_PENDING: "等待执行",
  TaskState.TASK_STATE_RUNNING: "正在执行",
  TaskState.TASK_STATE_SUCCEEDED: "执行成功",
  TaskState.TASK_STATE_CANCELING: "正在取消",
  TaskState.TASK_STATE_CANCELED: "已取消",
  TaskState.TASK_STATE_FAILED: "执行失败",
};

enum TaskListStatus {
  running,
  finished,
  failed,
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

class TaskNotifier extends FamilyAsyncNotifier<List<Task>, TaskListStatus> {
  final _service = TaskService();

  @override
  FutureOr<List<Task>> build(arg) async {
    List<Task> results = await _service.listTasks();

    switch (arg) {
      case TaskListStatus.running:
        return results.where(isRunning).toList();
      case TaskListStatus.finished:
        return results.where(isFinished).toList();
      case TaskListStatus.failed:
        return results.where(isFailed).toList();
    }
  }
}

class TaskCountNotifier extends FamilyNotifier<int, TaskListStatus> {
  @override
  int build(arg) {
    final tasks = ref.watch(taskProvider(arg)).valueOrNull ?? <Task>[];
    return tasks.length;
  }
}

final taskProvider =
    AsyncNotifierProvider.family<TaskNotifier, List<Task>, TaskListStatus>(() {
  return TaskNotifier();
});
final taskCountProvider =
    NotifierProvider.family<TaskCountNotifier, int, TaskListStatus>(() {
  return TaskCountNotifier();
});

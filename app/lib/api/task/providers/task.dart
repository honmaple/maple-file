import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/generated/proto/api/task/task.pb.dart';

import 'service.dart';

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<Task>>(() {
  return TaskNotifier();
});
final taskFilterProvider = StateProvider((ref) => TaskListFilter.running);

Map<TaskState, String> stateLabel = {
  TaskState.TASK_STATE_PENDING: "等待执行",
  TaskState.TASK_STATE_RUNNING: "正在执行",
  TaskState.TASK_STATE_SUCCEEDED: "执行成功",
  TaskState.TASK_STATE_CANCELING: "正在取消",
  TaskState.TASK_STATE_CANCELED: "已取消",
  TaskState.TASK_STATE_FAILED: "执行失败",
};

enum TaskListFilter {
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

class TaskNotifier extends AsyncNotifier<List<Task>> {
  final _service = TaskService();

  @override
  FutureOr<List<Task>> build() async {
    List<Task> results = await _service.listTasks();

    final filter = ref.watch(taskFilterProvider);

    switch (filter) {
      case TaskListFilter.running:
        return results.where(isRunning).toList();
      case TaskListFilter.finished:
        return results.where(isFinished).toList();
      case TaskListFilter.failed:
        return results.where(isFailed).toList();
      default:
        return results;
    }
  }
}

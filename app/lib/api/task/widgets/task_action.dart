import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/task/task.pb.dart';

import '../providers/task.dart';
import '../providers/service.dart';

enum TaskAction {
  detail,
  retry,
  cancel,
  remove,
}

extension on TaskAction {
  IconData? get icon {
    final Map<TaskAction, IconData> icons = {
      TaskAction.detail: Icons.info_outlined,
      TaskAction.retry: Icons.refresh,
      TaskAction.cancel: Icons.cancel,
      TaskAction.remove: Icons.delete,
    };
    return icons[this];
  }

  String get label {
    final Map<TaskAction, String> labels = {
      TaskAction.detail: "详情".tr(),
      TaskAction.retry: "重试".tr(),
      TaskAction.cancel: "取消".tr(),
      TaskAction.remove: "删除".tr(),
    };
    return labels[this] ?? "unknown";
  }

  Future<void> action(BuildContext context, Task task, {WidgetRef? ref}) async {
    switch (this) {
      case TaskAction.detail:
        showTaskDetail(context, task);
        return;
      case TaskAction.retry:
        TaskService().retryTask([task.id]);
        return;
      case TaskAction.cancel:
        TaskService().cancelTask([task.id]);
        return;
      case TaskAction.remove:
        TaskService().removeTask([task.id]);
        return;
    }
  }
}

void showTaskDetail(BuildContext context, Task task) {
  showCustomDialog(
    context,
    child: Scaffold(
      appBar: AppBar(
        title: Text("执行日志".tr()),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(task.log),
          ),
        ],
      ),
    ),
  );
}

Future<void> showTaskAction(
  BuildContext context,
  Task task, {
  WidgetRef? ref,
}) async {
  final result = await showCustomListOptions<TaskAction>(
      context: context,
      // useAlertDialog: true,
      options: [
        if (task.log != "")
          CustomOption(
            icon: Icon(TaskAction.detail.icon),
            label: TaskAction.detail.label,
            value: TaskAction.detail,
          ),
        if (isFinished(task))
          CustomOption(
            icon: Icon(TaskAction.retry.icon),
            label: TaskAction.retry.label,
            value: TaskAction.retry,
          ),
        if (isRunning(task))
          CustomOption(
            icon: Icon(TaskAction.cancel.icon),
            label: TaskAction.cancel.label,
            value: TaskAction.cancel,
          ),
        if (isFinished(task))
          CustomOption(
            icon: Icon(TaskAction.remove.icon),
            label: TaskAction.remove.label,
            value: TaskAction.remove,
          ),
      ]);
  if (!context.mounted) return;
  result?.action(context, task, ref: ref);
}

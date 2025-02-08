import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/task/task.pb.dart';

import '../providers/task.dart';
import '../providers/service.dart';

enum TaskActionType {
  retry,
  cancel,
  remove,
}

extension TaskActionTypeExtension on TaskActionType {
  Future<void> action(BuildContext context, Task task, {WidgetRef? ref}) async {
    switch (this) {
      case TaskActionType.retry:
        TaskService().retryTask([task.id]);
        return;
      case TaskActionType.cancel:
        TaskService().cancelTask([task.id]);
        return;
      case TaskActionType.remove:
        TaskService().removeTask([task.id]);
        return;
    }
  }
}

void showTaskDetail(BuildContext context, Task task) {
  showListDialog2(
    context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(title: Text("执行日志".tr())),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(task.log),
        ),
      ],
    ),
  );
}

Future<void> showTaskAction(
  BuildContext context,
  Task task, {
  WidgetRef? ref,
}) async {
  final result = await showListDialog<TaskActionType>(context,
      useAlertDialog: true,
      items: [
        ListDialogItem(
          child: ListTile(
            title: Text(task.name),
            subtitle: Text(task.progressState),
            trailing: TextButton.icon(
              label: Text("查看详情".tr()),
              icon: const Icon(Icons.info_outlined),
              onPressed: () {
                Navigator.of(context).pop();
                showTaskDetail(context, task);
              },
            ),
          ),
        ),
        if (isFinished(task))
          ListDialogItem(
            icon: Icons.refresh,
            label: "重试任务".tr(),
            value: TaskActionType.retry,
          ),
        if (isRunning(task))
          ListDialogItem(
            icon: Icons.cancel,
            label: "取消任务".tr(),
            value: TaskActionType.cancel,
          ),
        if (isFinished(task))
          ListDialogItem(
            icon: Icons.delete,
            label: "删除任务".tr(),
            value: TaskActionType.remove,
          ),
      ]);
  if (!context.mounted) return;
  result?.action(context, task, ref: ref);
}

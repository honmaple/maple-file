import 'package:flutter/material.dart';

import 'package:maple_file/generated/proto/api/task/persist.pb.dart';

import "backup.dart";
import "sync.dart";

enum TaskType {
  sync,
  backup,
}

extension TaskTypeExtension on TaskType {
  String label() {
    final Map<TaskType, String> labels = {
      TaskType.sync: "同步",
      TaskType.backup: "备份",
    };
    return labels[this] ?? "unknown";
  }
}

class TaskForm extends StatelessWidget {
  final PersistTask form;

  const TaskForm({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    switch (form.type) {
      case "sync":
        return Sync(form: form);
      case "backup":
        return Backup(form: form);
      default:
        return const SizedBox.shrink();
    }
  }
}

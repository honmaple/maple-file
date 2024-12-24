import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/task/task.pb.dart';

void showTaskDetail(BuildContext context, Task task) {
  showListDialog2(
    context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(title: Text("执行日志".tr(context))),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(task.log),
        ),
      ],
    ),
  );
}

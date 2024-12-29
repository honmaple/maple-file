import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/responsive.dart';
import 'package:maple_file/api/task/providers/persist.dart';
import 'package:maple_file/api/task/providers/service.dart';
import 'package:maple_file/generated/proto/api/task/persist.pb.dart';

import '../widgets/task/form.dart';

class TaskEdit extends ConsumerStatefulWidget {
  const TaskEdit({super.key, this.task});

  final PersistTask? task;

  factory TaskEdit.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;

    return TaskEdit(task: args == null ? null : args as PersistTask);
  }

  @override
  ConsumerState<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends ConsumerState<TaskEdit> {
  late PersistTask _form;

  @override
  void initState() {
    super.initState();

    _form = widget.task ?? PersistTask(status: true);
  }

  bool get _isEditing {
    return _form.id > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEditing ? Text('修改任务'.tr()) : Text('添加任务'.tr()),
        actions: [
          if (_isEditing)
            TextButton(
              child: Text("删除".tr()),
              onPressed: () {
                _handleDelete(context);
              },
            ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  if (!_isEditing)
                    CustomFormField(
                      label: "任务类型".tr(),
                      value: _form.type,
                      type: CustomFormFieldType.option,
                      options: TaskType.values.map((v) {
                        return CustomFormFieldOption(
                          label: v.label(),
                          value: v.name,
                        );
                      }).toList(),
                      isRequired: true,
                      onTap: (result) {
                        setState(() {
                          _form.type = result;
                        });
                      },
                    ),
                  CustomFormField(
                    label: "任务名称".tr(),
                    value: _form.name,
                    isRequired: true,
                    onTap: (result) {
                      setState(() {
                        _form.name = result;
                      });
                    },
                  ),
                  ListTile(
                    title: Text('任务状态'.tr()),
                    trailing: Switch(
                      value: _form.status,
                      onChanged: (result) {
                        setState(() {
                          _form.status = result;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_form.type != "")
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TaskForm(form: _form),
                  SizedBox(height: Breakpoint.isMobile(context) ? 4 : 8),
                  SizedBox(
                    width: double.infinity,
                    child: _isEditing
                        ? ElevatedButton(
                            child: Text('确认修改'.tr()),
                            onPressed: () {
                              _handleUpdate(context);
                            },
                          )
                        : ElevatedButton(
                            child: Text('确认添加'.tr()),
                            onPressed: () {
                              _handleCreate(context);
                            },
                          ),
                  ),
                  if (_isEditing)
                    SizedBox(height: Breakpoint.isMobile(context) ? 4 : 8),
                  if (_isEditing)
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const WidgetSpan(
                              child: Icon(
                                Icons.error_outline,
                                size: 16,
                              ),
                            ),
                            const TextSpan(text: " "),
                            TextSpan(
                              text: "删除或者修改任务可能会导致正在进行中的任务中断，请确认任务完成后再操作",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            SizedBox(height: Breakpoint.isMobile(context) ? 8 : 16),
          ],
        ),
      ),
    );
  }

  _handleCreate(BuildContext context) async {
    await TaskService().createPersistTask(_form).then((resp) {
      if (!resp.hasErr) {
        ref.invalidate(persistTaskProvider);
        if (context.mounted) Navigator.of(context).pop();
      }
    });
  }

  _handleUpdate(BuildContext context) async {
    print(_form.option);
    await TaskService().updatePersistTask(_form).then((resp) {
      if (!resp.hasErr) {
        ref.invalidate(persistTaskProvider);
        if (context.mounted) Navigator.of(context).pop();
      }
    });
  }

  _handleDelete(BuildContext context) async {
    final result = await showAlertDialog<bool>(
      context,
      content: Text("确认删除任务?".tr()),
    );
    if (result != null && result) {
      await TaskService().deletePersistTask(_form.id).then((_) {
        ref.invalidate(persistTaskProvider);
        if (context.mounted) Navigator.of(context).pop();
      });
    }
  }
}

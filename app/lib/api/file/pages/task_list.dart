import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/api/task/providers/persist.dart';
import 'package:maple_file/api/task/providers/service.dart';

import '../widgets/task/form.dart';

class TaskList extends ConsumerStatefulWidget {
  const TaskList({super.key});

  @override
  ConsumerState<TaskList> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('同步备份'.tr(context)),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text("同步备份".tr(context)),
                    dense: true,
                  ),
                  CustomAsyncValue(
                    value: ref.watch(persistTaskProvider),
                    builder: (items) => Column(
                      children: [
                        for (final item in items)
                          ListTile(
                            title: Text(item.name),
                            subtitle: Row(
                              children: [
                                Text(
                                  "任务类型：{type}".tr(
                                    context,
                                    args: {
                                      "type": _typeLabel(context, item.type)
                                    },
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 18,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Switch(
                                      value: item.status,
                                      onChanged: (result) async {
                                        await TaskService().updatePersistTask(
                                            item.copyWith((r) {
                                          r.status = result;
                                        })).then((_) {
                                          ref.invalidate(persistTaskProvider);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: InkWell(
                              child: Text("立即执行".tr(context),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                      )),
                              onTap: () async {
                                // await TaskService()
                                //     .executePersistTask(item.id)
                                //     .then((_) {
                                //   ref.invalidate(persistTaskProvider);
                                // });
                              },
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/file/setting/task/edit',
                                arguments: item,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  ListTile(
                    trailing: const Icon(Icons.add),
                    title: Text("添加新任务".tr(context)),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/file/setting/task/edit',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(BuildContext context, String type) {
    for (final value in TaskType.values) {
      if (value.name == type) {
        return value.label();
      }
    }
    return "unknonw";
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import '../widgets/repo/form.dart';

import '../providers/file.dart';
import '../providers/repo.dart';
import '../providers/service.dart';

class RepoEdit extends ConsumerStatefulWidget {
  const RepoEdit({super.key, this.repo});

  final Repo? repo;

  factory RepoEdit.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;

    return RepoEdit(repo: args == null ? null : args as Repo);
  }

  @override
  ConsumerState<RepoEdit> createState() => _RepoEditState();
}

class _RepoEditState extends ConsumerState<RepoEdit> {
  late Repo _form;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _form = widget.repo ?? Repo(path: "/");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isEditing {
    return _form.id > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEditing ? Text('修改存储'.tr(context)) : Text('添加存储'.tr(context)),
        actions: [
          if (_isEditing)
            TextButton(
              child: Text("删除".tr(context)),
              onPressed: () async {
                final result = await showAlertDialog<bool>(context,
                    content: Text(("确认删除存储?".tr(context))));
                if (result != null && result) {
                  await FileService().deleteRepo(_form.id).then((_) {
                    ref.invalidate(repoProvider);
                    ref.invalidate(fileProvider(_form.path));
                    if (context.mounted) Navigator.of(context).pop();
                  });
                }
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
                  ListTile(
                    enabled: !_isEditing,
                    title: Text('存储类型'.tr(context)),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(_form.driver == ""
                            ? "未选择".tr(context)
                            : _form.driver),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog(context, items: [
                        for (final value in DriverType.values)
                          ListDialogItem(label: value.label(), value: value),
                      ]);
                      if (result != null) {
                        setState(() {
                          _form.driver = result.name;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text("存储名称".tr(context)),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(_form.name == "" ? "未设置".tr(context) : _form.name),
                        if (_form.name == "")
                          const Text(' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    onTap: () async {
                      _controller.text = _form.name;

                      final result = await showEditingDialog(
                        context,
                        "存储名称".tr(context),
                        value: _form.name,
                      );
                      if (result != null) {
                        setState(() {
                          _form.name = result;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text("挂载目录".tr(context)),
                    trailing: Text(_form.path),
                    onTap: () async {
                      _controller.text = _form.path;

                      final result = await showEditingDialog(
                        context,
                        "挂载目录".tr(context),
                        value: _form.path,
                      );
                      if (result != null) {
                        setState(() {
                          _form.path = result;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            if (_form.driver != "") DriverForm(form: _form),
            if (_form.driver != "")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('测试连接'.tr(context)),
                  onPressed: () async {
                    await FileService().testRepo(_form);
                  },
                ),
              ),
            if (_form.driver != "") const SizedBox(height: 4),
            if (_form.driver != "")
              SizedBox(
                width: double.infinity,
                child: _isEditing
                    ? ElevatedButton(
                        child: Text('确认修改'.tr(context)),
                        onPressed: () async {
                          await FileService().updateRepo(_form).then((_) {
                            ref.invalidate(repoProvider);
                            ref.invalidate(fileProvider(_form.path));
                            if (context.mounted) Navigator.of(context).pop();
                          });
                        },
                      )
                    : ElevatedButton(
                        child: Text('确认添加'.tr(context)),
                        onPressed: () async {
                          await FileService().createRepo(_form).then((_) {
                            ref.invalidate(repoProvider);
                            ref.invalidate(fileProvider(_form.path));
                            if (context.mounted) Navigator.of(context).pop();
                          });
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

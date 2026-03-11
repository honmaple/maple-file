import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/common/widgets/responsive.dart';
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
  final _formKey = GlobalKey<FormState>();

  late Repo _form;

  @override
  void initState() {
    super.initState();

    _form = widget.repo?.clone() ?? Repo(path: "/", status: true);
  }

  bool get _isEditing {
    return _form.id > 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: _isEditing ? Text('修改存储'.tr()) : Text('添加存储'.tr()),
        trailingActions: [
          if (_isEditing)
            TextButton(
              onPressed: _handleDelete,
              child: Text("删除".tr()),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            CustomListSection(
              hasLeading: false,
              dividerMargin: 20,
              children: [
                if (!_isEditing)
                  CustomListTileOptions(
                    label: "存储类型".tr(),
                    value: _form.driver,
                    options: DriverType.values.map((v) {
                      return CustomOption(
                        label: v.label(),
                        value: v.name,
                      );
                    }).toList(),
                    usePage: true,
                    isRequired: true,
                    onTap: (result) {
                      setState(() {
                        _form.driver = result;
                      });
                    },
                  ),
                CustomListTileTextField(
                  label: "存储名称".tr(),
                  value: _form.name,
                  isRequired: true,
                  onChanged: (result) {
                    setState(() {
                      _form.name = result;
                    });
                  },
                ),
                CustomListTileTextField(
                  label: "挂载目录".tr(),
                  value: _form.path,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '{}不能为空'.tr(args: ["挂载目录".tr()]);
                    }
                    if (!value.startsWith("/")) {
                      return '{}必须以 / 开头'.tr(args: ["挂载目录".tr()]);
                    }
                    return null;
                  },
                  onChanged: (result) {
                    setState(() {
                      _form.path = result;
                    });
                  },
                ),
                CustomListTileSwitch(
                  label: '存储状态'.tr(),
                  value: _form.status,
                  onChanged: (result) {
                    setState(() {
                      _form.status = result;
                    });
                  },
                ),
              ],
            ),
            if (_form.driver != "")
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DriverForm(form: _form),
                  SizedBox(height: Breakpoint.isSmall(context) ? 4 : 8),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        backgroundColor: ColorUtil.backgroundColor(context),
                      ),
                      onPressed: _handleTest,
                      child: Text('测试连接'.tr()),
                    ),
                  ),
                  SizedBox(height: Breakpoint.isSmall(context) ? 4 : 8),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: _isEditing
                        ? FilledButton(
                            onPressed: _handleUpdate,
                            child: Text('确认修改'.tr()),
                          )
                        : FilledButton(
                            onPressed: _handleCreate,
                            child: Text('确认添加'.tr()),
                          ),
                  ),
                  if (_isEditing)
                    SizedBox(height: Breakpoint.isSmall(context) ? 4 : 8),
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
                              text: "删除或者修改存储可能会导致正在进行中的任务中断，请确认任务完成后再操作".tr(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            SizedBox(height: Breakpoint.isSmall(context) ? 8 : 16),
          ],
        ),
      ),
    );
  }

  _handleTest() {
    if (_formKey.currentState!.validate()) {
      FileService.instance.testRepo(_form);
    }
  }

  _handleCreate() {
    if (_formKey.currentState!.validate()) {
      FileService.instance.createRepo(_form).then((_) {
        _handleDone(_form);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      FileService.instance.updateRepo(_form).then((_) {
        _handleDone(_form);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  _handleDelete() async {
    final result = await showCustomConfirmDialog(
      context: context,
      title: Text("确认删除存储?".tr()),
    );
    if (result != null && result) {
      await FileService.instance.deleteRepo(_form.id).then((_) {
        _handleDone(_form);
        if (context.mounted) Navigator.of(context).pop();
      });
    }
  }

  _handleDone(Repo repo) {
    ref.invalidate(repoProvider);
    ref.invalidate(fileProvider(repo.path));
  }
}

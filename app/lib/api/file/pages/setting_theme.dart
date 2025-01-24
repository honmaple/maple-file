import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/api/setting/providers/setting_appearance.dart';

import '../providers/file_setting.dart';

class FileSettingTheme extends ConsumerStatefulWidget {
  const FileSettingTheme({super.key});

  @override
  ConsumerState<FileSettingTheme> createState() => _FileSettingThemeState();
}

class _FileSettingThemeState extends ConsumerState<FileSettingTheme> {
  @override
  Widget build(BuildContext context) {
    final setting = ref.watch(fileSettingProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('显示设置'.tr()),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('布局'.tr()),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(setting.view.label(context)),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog(
                        context,
                        items: FileListView.values.map((item) {
                          return ListDialogItem(
                              label: item.label(context), value: item);
                        }).toList(),
                      );
                      if (result != null) {
                        ref.read(fileSettingProvider.notifier).update((state) {
                          return state.copyWith(view: result);
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text('排序'.tr()),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('按{sort}排序'.tr(
                          args: {"sort": setting.sort.label(context)},
                        )),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog(
                        context,
                        items: FileListSort.values.map((item) {
                          return ListDialogItem(
                            label: item.label(context),
                            value: item,
                            trailing: setting.sort == item
                                ? Text(setting.sortReversed
                                    ? "倒序".tr()
                                    : "正序".tr())
                                : null,
                          );
                        }).toList(),
                      );
                      if (result != null) {
                        ref.read(fileSettingProvider.notifier).update((state) {
                          if (result == setting.sort) {
                            return state.copyWith(
                                sortReversed: !state.sortReversed);
                          }
                          return state.copyWith(sort: result);
                        });
                      }
                    },
                  ),
                  FileTypeFormField(
                    label: '隐藏文件'.tr(),
                    value: setting.hideFiles,
                    onTap: (result) {
                      ref.read(fileSettingProvider.notifier).update((state) {
                        return state.copyWith(hideFiles: result);
                      });
                    },
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('图标'.tr()),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(setting.icon.label(context)),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog(
                        context,
                        items: FileListIcon.values.map((item) {
                          return ListDialogItem(
                            label: item.label(context),
                            value: item,
                          );
                        }).toList(),
                      );
                      if (result != null) {
                        ref.read(fileSettingProvider.notifier).update((state) {
                          return state.copyWith(icon: result);
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text('图标颜色'.tr()),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(setting.iconColor ?? "默认".tr()),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog2<FlexScheme>(
                        context,
                        height: MediaQuery.sizeOf(context).height * 0.618,
                        child: ListView(
                          children: [
                            ListTile(
                              title: Text("默认".tr()),
                              leading: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  color:
                                      defaultFlexScheme.primaryColor(context),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                              ),
                              selected: setting.iconColor == null,
                              onTap: () {
                                Navigator.of(context).pop(defaultFlexScheme);
                              },
                            ),
                            for (final scheme in FlexScheme.values)
                              ListTile(
                                title: Text(scheme.name),
                                leading: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: scheme.primaryColor(context),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                  ),
                                ),
                                selected: setting.iconColor == scheme.name,
                                onTap: () {
                                  Navigator.of(context).pop(scheme);
                                },
                              ),
                          ],
                        ),
                      );
                      if (result != null) {
                        ref.read(fileSettingProvider.notifier).update((state) {
                          return state.copyWith(
                            iconColor: result.name == defaultFlexScheme.name
                                ? null
                                : result.name,
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text("分页设置".tr()),
                    dense: true,
                  ),
                  CustomFormField(
                    type: CustomFormFieldType.number,
                    label: '分页大小'.tr(),
                    value: "${setting.paginationSize}",
                    subtitle: Text("为0时表示不分页".tr()),
                    onTap: (result) {
                      ref.read(fileSettingProvider.notifier).update((state) {
                        return state.copyWith(
                          paginationSize: int.parse(result),
                        );
                      });
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
}

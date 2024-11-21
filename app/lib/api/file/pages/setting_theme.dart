import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
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
        title: Text('显示设置'.tr(context)),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('布局'.tr(context)),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(fileListViewLabel[setting.view] ??
                            "默认".tr(context)),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog(
                        context,
                        items: FileListView.values.map((item) {
                          return ListDialogItem(
                              label: fileListViewLabel[item] ?? "未知",
                              value: item);
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
                    title: const Text('排序'),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('按${fileListSortLabel[setting.sort] ?? "默认"}排序'),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog(
                        context,
                        items: FileListSort.values.map((item) {
                          return ListDialogItem(
                            label: fileListSortLabel[item] ?? "未知",
                            value: item,
                            trailing: setting.sort == item
                                ? Text(setting.sortReversed ? "倒序" : "正序")
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
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('图标'),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(fileListIconLabel[setting.icon] ?? "默认"),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog(
                        context,
                        items: FileListIcon.values.map((item) {
                          return ListDialogItem(
                              label: fileListIconLabel[item] ?? "未知",
                              value: item);
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
                    title: Text('图标颜色'.tr(context)),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(setting.iconColor ?? "默认".tr(context)),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog2(
                        context,
                        height: MediaQuery.sizeOf(context).height * 0.618,
                        child: ListView(
                          children: ThemeModel.themes.map(
                            (theme) {
                              return ListTile(
                                title: Text(theme.name),
                                leading: Container(
                                  height: 24,
                                  width: 24,
                                  decoration: BoxDecoration(
                                    color: theme.color,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12)),
                                  ),
                                ),
                                selected: setting.iconColor == theme.name,
                                onTap: () {
                                  Navigator.of(context).pop(theme.name);
                                },
                              );
                            },
                          ).toList(),
                        ),
                      );
                      if (result != null) {
                        ref.read(fileSettingProvider.notifier).update((state) {
                          return state.copyWith(iconColor: result);
                        });
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

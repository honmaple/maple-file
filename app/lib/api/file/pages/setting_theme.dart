import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/custom.dart';
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
                    title: const Text('排序'),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text('按{sort}排序'.tr(
                          context,
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
                                    ? "倒序".tr(context)
                                    : "正序".tr(context))
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
                  ListTile(
                    title: Text('隐藏文件'.tr(context)),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(setting.hideFiles.join(", ")),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () async {
                      final result = await showListDialog2(
                        context,
                        height: MediaQuery.of(context).size.height / 2,
                        child: const FileSettingHideFiles(),
                      );
                      if (result != null) {
                        // ref.read(fileSettingProvider.notifier).update((state) {
                        //   if (result == setting.sort) {
                        //     return state.copyWith(
                        //         sortReversed: !state.sortReversed);
                        //   }
                        //   return state.copyWith(sort: result);
                        // });
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
                    title: Text('图标'.tr(context)),
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
            ),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text("分页设置".tr(context)),
                    dense: true,
                  ),
                  CustomFormField(
                    type: CustomFormFieldType.number,
                    label: '分页大小'.tr(context),
                    value: "${setting.paginationSize}",
                    subtitle: Text("为0时表示不分页".tr(context)),
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

class FileSettingHideFiles extends ConsumerStatefulWidget {
  const FileSettingHideFiles({super.key});

  @override
  ConsumerState<FileSettingHideFiles> createState() =>
      _FileSettingHideFilesState();
}

class _FileSettingHideFilesState extends ConsumerState<FileSettingHideFiles> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hideFiles = ref.watch(fileSettingProvider.select((state) {
      return state.hideFiles;
    }));
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: '输入文件名称',
            hintStyle: TextStyle(
              fontSize: 12,
            ),
            prefixIcon: Icon(Icons.tag),
            prefixIconConstraints: BoxConstraints(
              minWidth: 42,
              minHeight: 42,
            ),
            filled: true,
            isDense: true,
            contentPadding: EdgeInsets.all(0),
          ),
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: kDefaultFontSize),
              child: Text(
                "添加",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            onTap: () {
              ref.read(fileSettingProvider.notifier).update((state) {
                return state
                    .copyWith(hideFiles: [...hideFiles, _controller.text]);
              });
              _controller.text = "";
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (final file in hideFiles)
              InputChip(
                label: Text(file),
                labelStyle: TextStyle(
                  fontSize: kDefaultFontSize * 0.875,
                  color: Theme.of(context).primaryColor,
                ),
                selected: true,
                showCheckmark: false,
                onDeleted: () {
                  ref.read(fileSettingProvider.notifier).update((state) {
                    return state.copyWith(
                      hideFiles: hideFiles.where((r) => r != file).toList(),
                    );
                  });
                },
              )
          ],
        ),
      ),
    );
  }
}

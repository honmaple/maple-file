import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:io' as io;
import 'package:path/path.dart' as filepath;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart' as image_picker;

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';
import 'package:maple_file/api/task/providers/task.dart';

import '../providers/file.dart';
import '../providers/file_setting.dart';
import '../providers/service.dart';

enum FileActionType {
  move,
  copy,
  rename,
  remove,
  download,
  selectionMove,
  selectionCopy,
  selectionRemove,
  selectionDownload,
}

extension FileActionTypeExtension on FileActionType {
  Future<void> action(BuildContext context, File file, WidgetRef ref) async {
    switch (this) {
      case FileActionType.move:
        final Map<String, dynamic> args = {
          "path": "/",
          "title": "移动文件到".tr(),
          "filter": (File file) => file.type == "DIR",
        };
        final result = await Navigator.pushNamed(
          context,
          '/file/select',
          arguments: args,
        );
        if (result != null) {
          await FileService().move(
            file.path,
            result as String,
            [file.name],
          );
        }
        return;
      case FileActionType.copy:
        final Map<String, dynamic> args = {
          "path": "/",
          "title": "复制文件到".tr(),
          "filter": (File file) => file.type == "DIR",
        };
        final result = await Navigator.pushNamed(
          context,
          '/file/select',
          arguments: args,
        );
        if (result != null) {
          await FileService()
              .copy(file.path, result as String, [file.name]).then((_) {
            ref.invalidate(fileProvider(file.path));
          });
        }
        return;
      case FileActionType.rename:
        final ext = filepath.extension(file.name);
        final result = await showEditingDialog(
          context,
          "重命名".tr(),
          value: file.name,
          selection: TextSelection(
            baseOffset: 0,
            extentOffset: file.name.length - ext.length,
          ),
        );
        if (result != null) {
          await FileService().rename(file.path, file.name, result).then((_) {
            ref.invalidate(fileProvider(file.path));
          });
        }
        return;
      case FileActionType.download:
        String? downloadPath = ref.read(fileSettingProvider.select((state) {
          return state.downloadPath;
        }));
        if (downloadPath == null || downloadPath == "") {
          downloadPath = await PathUtil.getDownloadsPath();
        }
        await FileService()
            .download(
          filepath.join(file.path, file.name),
          io.File(PathUtil.autoRename(filepath.join(downloadPath, file.name))),
        )
            .then((_) {
          ref.invalidate(taskProvider(TaskType.running));
        });
        return;
      case FileActionType.remove:
        final result = await showAlertDialog<bool>(
          context,
          content: Text("确认删除文件{name}?".tr(
            args: {"name": file.name},
          )),
        );
        if (result != null && result) {
          await FileService().remove(file.path, [file.name]).then((_) {
            ref.invalidate(fileProvider(file.path));
          });
        }
        return;
      default:
    }
  }

  Future<void> selectionAction(BuildContext context, WidgetRef ref) async {
    // final selection = ref.read(fileSelectionProvider);
    switch (this) {
      case FileActionType.selectionMove:
        return;
      case FileActionType.selectionCopy:
      default:
        return;
    }
  }
}

void showFileDetail(BuildContext context, File file) {
  final size = Util.formatSize(file.size);
  showListDialog2(
    context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Text("文件路径".tr()),
          title: Text(file.path),
          minLeadingWidth: 16 * 4,
        ),
        ListTile(
          leading: Text("文件名称".tr()),
          title: Text(file.name),
          minLeadingWidth: 16 * 4,
        ),
        ListTile(
          leading: Text("文件大小".tr()),
          title: Text(size),
          minLeadingWidth: 16 * 4,
        ),
        ListTile(
          leading: Text("创建时间".tr()),
          title:
              Text(TimeUtil.pbToString(file.createdAt, "yyyy-MM-dd HH:mm:ss")),
          minLeadingWidth: 16 * 4,
        ),
        ListTile(
          leading: Text("修改时间".tr()),
          title:
              Text(TimeUtil.pbToString(file.updatedAt, "yyyy-MM-dd HH:mm:ss")),
          minLeadingWidth: 16 * 4,
        ),
      ],
    ),
  );
}

Future<void> showFileAction(
  BuildContext context,
  File file,
  WidgetRef ref,
) async {
  final result = await showListDialog<FileActionType>(context, items: [
    ListDialogItem(
      child: ListTile(
        title: Text(file.name),
        trailing: TextButton.icon(
          label: Text("查看详情".tr()),
          icon: const Icon(Icons.info_outlined),
          onPressed: () {
            Navigator.of(context).pop();
            showFileDetail(context, file);
          },
        ),
      ),
    ),
    ListDialogItem(
      label: "下载".tr(),
      value: FileActionType.download,
      icon: Icons.download,
    ),
    ListDialogItem(
      label: "复制".tr(),
      value: FileActionType.copy,
      icon: Icons.folder_copy_outlined,
    ),
    ListDialogItem(
      label: "移动".tr(),
      value: FileActionType.move,
      icon: Icons.move_up,
    ),
    ListDialogItem(
      label: "重命名".tr(),
      value: FileActionType.rename,
      icon: Icons.drive_file_rename_outline,
    ),
    ListDialogItem(
      child: const Divider(height: 4),
    ),
    ListDialogItem(
      label: "删除".tr(),
      value: FileActionType.remove,
      icon: Icons.delete,
    ),
  ]);
  if (!context.mounted) return;
  result?.action(context, file, ref);
}

class FilePopupAction extends ConsumerWidget {
  const FilePopupAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(fileSettingProvider.select((state) => state.view));
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.more_vert),
      // iconSize: 18,
      itemBuilder: (BuildContext bc) {
        return [
          PopupMenuItem(
            child: ListTile(
              dense: true,
              title: Text("存储库".tr()),
              leading: const Icon(Icons.storage),
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/file/setting/repo");
            },
          ),
          view == FileListView.list
              ? PopupMenuItem(
                  child: ListTile(
                    dense: true,
                    title: Text("宫格模式".tr()),
                    leading: const Icon(Icons.grid_view),
                  ),
                  onTap: () {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(view: FileListView.grid);
                    });
                  },
                )
              : PopupMenuItem(
                  child: ListTile(
                    dense: true,
                    title: Text("列表模式".tr()),
                    leading: const Icon(Icons.list),
                  ),
                  onTap: () {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(view: FileListView.list);
                    });
                  },
                ),
          PopupMenuItem(
            child: ListTile(
              dense: true,
              title: Text("设置".tr()),
              leading: const Icon(Icons.settings),
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/setting");
            },
          ),
        ];
      },
    );
  }
}

class FileSortAction extends ConsumerWidget {
  const FileSortAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = ref.watch(fileSettingProvider.select((state) => state.sort));
    final sortReversed =
        ref.watch(fileSettingProvider.select((state) => state.sortReversed));
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(sortReversed ? Icons.north : Icons.south, size: 12),
          const SizedBox(width: 4),
          Text(sort.label(context)),
        ],
      ),
      itemBuilder: (BuildContext bc) {
        return FileListSort.values.map((value) {
          return PopupMenuItem(
            height: 16 * 2,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text(value.label(context)),
              trailing: sort == value
                  ? Icon(sortReversed ? Icons.north : Icons.south, size: 16)
                  : null,
            ),
            onTap: () {
              ref.read(fileSettingProvider.notifier).update((state) {
                if (sort == value) {
                  return state.copyWith(sortReversed: !state.sortReversed);
                }
                return state.copyWith(sort: value);
              });
            },
          );
        }).toList();
      },
    );
  }
}

class FileFloatingAction extends ConsumerStatefulWidget {
  const FileFloatingAction({
    super.key,
    required this.path,
  });

  final String path;

  @override
  ConsumerState<FileFloatingAction> createState() => _FileFloatingActionState();
}

class _FileFloatingActionState extends ConsumerState<FileFloatingAction> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: const CircleBorder(),
      child: const Icon(Icons.add_a_photo),
      onPressed: () async {
        final result = await showListDialog(
          context,
          items: [
            if (Util.isMobile())
              ListDialogItem(
                label: "拍照上传".tr(),
                value: "camera",
                icon: Icons.camera_alt,
              ),
            ListDialogItem(
              label: "相册上传".tr(),
              value: "photo",
              icon: Icons.photo,
            ),
            ListDialogItem(
              label: "文件上传".tr(),
              value: "file",
              icon: Icons.file_upload_outlined,
            ),
            ListDialogItem(
              label: "新建文件夹".tr(),
              value: "folder",
              icon: Icons.create_new_folder,
            ),
          ],
          cancelAction: true,
        );

        final image_picker.ImagePicker picker = image_picker.ImagePicker();

        Future<void>? future;
        switch (result) {
          case "camera":
            image_picker.XFile? image = await picker.pickImage(
              source: image_picker.ImageSource.camera,
              imageQuality: 100,
            );
            if (image != null) {
              future = FileService().upload(widget.path, [io.File(image.path)]);
            }
            break;
          case "photo":
            List<image_picker.XFile> images = await picker.pickMultiImage(
              imageQuality: 100,
            );
            if (images.isNotEmpty) {
              future = FileService().upload(
                widget.path,
                images.map((file) => io.File(file.path)).toList(),
              );
            }
            break;
          case "file":
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
            );
            if (result != null) {
              future = FileService().upload(
                widget.path,
                result.paths.map((path) => io.File(path!)).toList(),
              );
            }
            break;
          case "folder":
            final name = await showEditingDialog(context, "新建目录".tr());
            if (name != null) {
              future = FileService().mkdir(widget.path, name);
            }
            break;
        }
        future?.then((_) {
          ref.invalidate(fileProvider(widget.path));
        });
      },
    );
  }
}

class FileSelectionAction extends ConsumerStatefulWidget {
  const FileSelectionAction({
    super.key,
    required this.path,
    required this.selected,
  });

  final String path;
  final List<File> selected;

  @override
  ConsumerState<FileSelectionAction> createState() =>
      _FileSelectionActionState();
}

class _FileSelectionActionState extends ConsumerState<FileSelectionAction> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.minWidth,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.folder_copy_outlined),
                      Text('复制'.tr()),
                    ],
                  ),
                  onPressed: () async {
                    final Map<String, dynamic> args = {
                      "path": "/",
                      "title": "复制文件到".tr(),
                      "filter": (File file) => file.type == "DIR",
                    };
                    final result = await Navigator.pushNamed(
                      context,
                      '/file/select',
                      arguments: args,
                    );
                    if (result != null) {
                      FileService()
                          .copy(
                        widget.path,
                        result as String,
                        widget.selected.map((i) => i.name).toList(),
                      )
                          .then((_) {
                        ref.read(fileSelectionProvider.notifier).reset();
                      });
                    }
                  },
                ),
                TextButton(
                  child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.move_up),
                      Text('移动'.tr()),
                    ],
                  ),
                  onPressed: () async {
                    final Map<String, dynamic> args = {
                      "path": "/",
                      "title": "移动文件到".tr(),
                      "filter": (File file) => file.type == "DIR",
                    };
                    final result = await Navigator.pushNamed(
                      context,
                      '/file/select',
                      arguments: args,
                    );
                    if (result != null) {
                      FileService()
                          .move(
                        widget.path,
                        result as String,
                        widget.selected.map((i) => i.name).toList(),
                      )
                          .then((_) {
                        ref.invalidate(fileProvider(widget.path));
                        ref.read(fileSelectionProvider.notifier).reset();
                      });
                    }
                  },
                ),
                if (widget.selected.length == 1)
                  TextButton(
                    child: Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(Icons.drive_file_rename_outline),
                        Text('重命名'.tr()),
                      ],
                    ),
                    onPressed: () {
                      FileActionType.rename
                          .action(context, widget.selected[0], ref)
                          .then((_) {
                        ref.read(fileSelectionProvider.notifier).reset();
                      });
                    },
                  ),
                TextButton(
                  child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.download_outlined),
                      Text('下载'.tr()),
                    ],
                  ),
                  onPressed: () async {},
                ),
                TextButton(
                  child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Icon(Icons.delete_outlined),
                      Text('删除'.tr()),
                    ],
                  ),
                  onPressed: () async {
                    final result = await showAlertDialog<bool>(
                      context,
                      content: Text("确认删除{n}个文件?".tr(
                        args: {"n": widget.selected.length},
                      )),
                    );
                    if (result != null && result) {
                      await FileService()
                          .remove(widget.path,
                              widget.selected.map((i) => i.name).toList())
                          .then((_) {
                        ref.invalidate(fileProvider(widget.path));
                        ref.read(fileSelectionProvider.notifier).reset();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

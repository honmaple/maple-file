import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:io' as io;
import 'package:path/path.dart' as filepath;
import 'package:image_picker/image_picker.dart' as image_picker;

import 'package:maple_file/app/app.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../providers/file.dart';
import '../providers/file_setting.dart';
import '../providers/service.dart';

enum FileActionType {
  download,
  selectionPinned,
  selectionDelete,
  selectionArchived,
}

extension FileActionTypeExtension on FileActionType {
  void action(BuildContext context, File file, WidgetRef ref) async {
    switch (this) {
      case FileActionType.download:
        String? downloadPath = ref.read(fileSettingProvider.select((state) {
          return state.downloadPath;
        }));
        downloadPath ??= await FilePicker.platform.getDirectoryPath();
        showAlertDialog(context, title: Text("aaaa"));
      default:
    }
  }
}

void showFileDetail(BuildContext context, File file) {
  showListDialog2(
    context,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Text("文件路径".tr(context)),
          title: Text(file.path),
          minLeadingWidth: 16 * 4,
        ),
        ListTile(
          leading: Text("文件名称".tr(context)),
          title: Text(file.name),
          minLeadingWidth: 16 * 4,
        ),
        ListTile(
          leading: Text("文件大小".tr(context)),
          title: Text("${file.size}B"),
          minLeadingWidth: 16 * 4,
        ),
        ListTile(
          leading: Text("创建时间".tr(context)),
          title:
              Text(TimeUtil.pbToString(file.createdAt, "yyyy-MM-dd HH:mm:ss")),
          minLeadingWidth: 16 * 4,
        ),
        ListTile(
          leading: Text("修改时间".tr(context)),
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
  final result = await showListDialog(context, items: [
    ListDialogItem(
      child: ListTile(
        title: Text(file.name),
        trailing: TextButton.icon(
          label: Text("查看详情".tr(context)),
          icon: const Icon(Icons.info_outlined),
          onPressed: () {
            showFileDetail(context, file);
          },
        ),
      ),
    ),
    ListDialogItem(
      label: "下载".tr(context),
      value: "download",
      icon: Icons.download,
    ),
    ListDialogItem(
      label: "重命名".tr(context),
      value: "rename",
      icon: Icons.drive_file_rename_outline,
    ),
    ListDialogItem(
      child: const Divider(height: 4),
    ),
    ListDialogItem(
      label: "删除".tr(context),
      value: "delete",
      icon: Icons.delete,
    ),
  ]);

  switch (result) {
    case "rename":
      final name = await showEditingDialog(
        context,
        "新建目录",
        value: file.name,
      );
      if (name != null) {
        FileService().rename(file.path, file.name, name);
      }
      break;
    case "download":
      String? downloadPath = ref.read(fileSettingProvider.select((state) {
        return state.downloadPath;
      }));
      if (downloadPath == null || downloadPath == "") {
        final path = await PathUtil.getDownloadsPath();
        final result = await showAlertDialog<bool>(
          context,
          content: Text("下载文件到$path?"),
        );
        if (result == null || !result) {
          return;
        }
        downloadPath = path;
      }
      if (io.File(filepath.join(downloadPath, file.name)).existsSync()) {
        final result = await showAlertDialog<bool>(
          context,
          content: const Text("本地文件已存在?\n是否覆盖原文件"),
        );
        if (result != null) {}
      }

      FileService().download(filepath.join(file.path, file.name), downloadPath);
      break;
    case "delete":
      final result = await showAlertDialog<bool>(
        context,
        content: const Text("确认删除文件?"),
      );
      if (result != null && result) {
        await FileService().remove(file.path, [file.name]).then((_) {
          ref.invalidate(fileProvider(file.path));
        });
      }
      break;
  }
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
              title: Text("存储库".tr(context)),
              leading: const Icon(Icons.storage),
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/file/setting/repo");
            },
          ),
          view == FileListView.LIST
              ? PopupMenuItem(
                  child: ListTile(
                    dense: true,
                    title: Text("宫格模式".tr(context)),
                    leading: const Icon(Icons.grid_view),
                  ),
                  onTap: () {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(view: FileListView.GRID);
                    });
                  },
                )
              : PopupMenuItem(
                  child: ListTile(
                    dense: true,
                    title: Text("列表模式".tr(context)),
                    leading: const Icon(Icons.list),
                  ),
                  onTap: () {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(view: FileListView.LIST);
                    });
                  },
                ),
          PopupMenuItem(
            child: ListTile(
              dense: true,
              title: Text("设置".tr(context)),
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
          Text(fileListSortLabel[sort] ?? sort.toString()),
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
              title: Text(fileListSortLabel[value] ?? value.toString()),
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
        final image_picker.ImagePicker picker = image_picker.ImagePicker();

        final result = await showListDialog(
          context,
          items: [
            if (Util.isMobile())
              ListDialogItem(
                label: "拍照上传",
                value: "camera",
                icon: Icons.camera_alt,
              ),
            ListDialogItem(
              label: "相册上传",
              value: "photo",
              icon: Icons.photo,
            ),
            ListDialogItem(
              label: "新建文件夹",
              value: "folder",
              icon: Icons.create_new_folder,
            ),
          ],
          cancelAction: true,
        );

        Future<void>? future;
        switch (result) {
          case "camera":
            image_picker.XFile? image = await picker.pickImage(
              source: image_picker.ImageSource.camera,
              imageQuality: 100,
            );
            List<io.File> images = [];
            if (image != null) {
              images.add(io.File(image.path));
            }
            future = FileService().upload(widget.path, images);
            break;
          case "photo":
            List<image_picker.XFile> images = await picker.pickMultiImage(
              imageQuality: 100,
            );
            future = FileService().upload(
              widget.path,
              images.map((file) => io.File(file.path)).toList(),
            );
            break;
          case "folder":
            final name = await showEditingDialog(context, "新建目录");
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
    this.callback,
  });

  final String path;
  final List<File> selected;
  final void Function()? callback;

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
    return OverflowBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextButton(
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.folder_copy_outlined),
              Text('复制'.tr(context)),
            ],
          ),
          onPressed: () async {
            final Map<String, dynamic> args = {
              "path": "/",
              "title": "复制文件到",
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
                widget.callback?.call();
              });
            }
          },
        ),
        TextButton(
          child: const Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(Icons.move_up),
              Text('移动'),
            ],
          ),
          onPressed: () async {
            final Map<String, dynamic> args = {
              "path": "/",
              "title": "移动文件到",
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
                widget.callback?.call();
                ref.invalidate(fileProvider(widget.path));
              });
            }
          },
        ),
        if (widget.selected.length == 1)
          TextButton(
            child: const Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.drive_file_rename_outline),
                Text('重命名'),
              ],
            ),
            onPressed: () async {
              _controller.text = widget.selected[0].name;
              _controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: _controller.text.length -
                    filepath.extension(_controller.text).length,
              );
              final result = await showEditingDialog(
                context,
                "重命名",
                controller: _controller,
              );
              if (result != null) {
                FileService()
                    .rename(
                  widget.path,
                  widget.selected[0].name,
                  result as String,
                )
                    .then((_) {
                  widget.callback?.call();
                  ref.invalidate(fileProvider(widget.path));
                });
              }
            },
          ),
        TextButton(
          child: Wrap(
            direction: Axis.vertical,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.more_horiz),
              Text('更多'.tr(context)),
            ],
          ),
          onPressed: () async {
            final item = widget.selected[0];
            final result = await showListDialog(context, items: [
              if (widget.selected.length == 1)
                ListDialogItem(
                  child: ListTile(
                    title: Text(widget.selected[0].name),
                    trailing: TextButton(
                      child: Text("查看详情".tr(context)),
                      onPressed: () {
                        showFileDetail(context, item);
                      },
                    ),
                  ),
                ),
              ListDialogItem(
                label: "下载",
                value: "download",
                icon: Icons.download,
              ),
              if (widget.selected.length == 1)
                ListDialogItem(
                  label: "复制链接",
                  value: "link",
                  icon: Icons.link,
                ),
              ListDialogItem(
                child: const Divider(height: 4),
              ),
              ListDialogItem(
                label: "删除",
                value: "delete",
                icon: Icons.delete,
              ),
            ]);

            Future<void>? future;
            switch (result) {
              case "delete":
                final result = await showAlertDialog<bool>(context,
                    content: Text(("确认删除文件?")));
                if (result != null && result) {
                  future = FileService().remove(
                    widget.path,
                    widget.selected.map((i) => i.name).toList(),
                  );
                  break;
                }
            }
            future?.then((_) {
              widget.callback?.call();
              ref.invalidate(fileProvider(widget.path));
            });
          },
        ),
      ],
    );
  }
}

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

enum FileAction {
  open,
  detail,
  move,
  copy,
  rename,
  remove,
  download,
}

extension FileActionExtension on FileAction {
  IconData? get icon {
    final Map<FileAction, IconData> icons = {
      FileAction.open: Icons.file_open_outlined,
      FileAction.detail: Icons.info_outlined,
      FileAction.copy: Icons.folder_copy_outlined,
      FileAction.move: Icons.move_up,
      FileAction.rename: Icons.drive_file_rename_outline,
      FileAction.remove: Icons.delete_outline,
      FileAction.download: Icons.download,
    };
    return icons[this];
  }

  String get label {
    final Map<FileAction, String> labels = {
      FileAction.open: "打开".tr(),
      FileAction.detail: "详情".tr(),
      FileAction.copy: "复制".tr(),
      FileAction.move: "移动".tr(),
      FileAction.rename: "重命名".tr(),
      FileAction.remove: "删除".tr(),
      FileAction.download: "下载".tr(),
    };
    return labels[this] ?? "unknown";
  }

  Future<void> action(
    BuildContext context,
    File file, {
    WidgetRef? ref,
    NavigatorState? navigator,
  }) async {
    navigator ??= Navigator.of(context);
    switch (this) {
      case FileAction.open:
        if (file.type == "DIR") {
          await navigator.pushNamed(
            '/file/list',
            arguments: filepath.posix.join(file.path, file.name),
          );
          return;
        }
        navigator.pushNamed(
          '/file/preview',
          arguments: {
            "file": file,
          },
        );
        return;
      case FileAction.detail:
        showFileDetail(context, file);
        return;
      case FileAction.move:
        final Map<String, dynamic> args = {
          "path": "/",
          "title": "移动文件到".tr(),
          "filter": (File file) => file.type == "DIR",
        };
        final result = await navigator.pushNamed(
          '/file/select',
          arguments: args,
        );
        if (result != null) {
          await FileService.instance.move(
            file.path,
            result as String,
            [file.name],
          );
        }
        return;
      case FileAction.copy:
        final Map<String, dynamic> args = {
          "path": "/",
          "title": "复制文件到".tr(),
          "filter": (File file) => file.type == "DIR",
        };
        final result = await navigator.pushNamed(
          '/file/select',
          arguments: args,
        );
        if (result != null) {
          await FileService.instance
              .copy(file.path, result as String, [file.name]).then((_) {
            ref?.invalidate(fileProvider(file.path));
          });
        }
        return;
      case FileAction.rename:
        final ext = filepath.posix.extension(file.name);
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
          await FileService.instance
              .rename(file.path, file.name, result)
              .then((_) {
            ref?.invalidate(fileProvider(file.path));
          });
        }
        return;
      case FileAction.download:
        String? downloadPath = ref?.read(fileSettingProvider.select((state) {
          return state.downloadPath;
        }));
        if (downloadPath == null || downloadPath == "") {
          downloadPath = await PathUtil.getDownloadsPath();
        }
        await FileService.instance
            .download(
          filepath.posix.join(file.path, file.name),
          io.File(PathUtil.autoRename(filepath.join(downloadPath, file.name))),
        )
            .then((_) {
          ref?.invalidate(taskProvider(TaskType.running));
        });
        return;
      case FileAction.remove:
        final result = await showAlertDialog<bool>(
          context,
          content: Text("确认删除文件{name}?".tr(
            args: {"name": file.name},
          )),
        );
        if (result != null && result) {
          await FileService.instance.remove(file.path, [file.name]).then((_) {
            ref?.invalidate(fileProvider(file.path));
          });
        }
        return;
    }
  }
}

void showFileDetail(BuildContext context, File file) {
  final size = Util.formatSize(file.size.toInt());
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

Future<FileAction?> showFileAction(
  BuildContext context,
  File file, {
  WidgetRef? ref,
  bool popup = false,
  Offset? popupOffset,
}) {
  if (popup) {
    return showFilePopupAction(
      context,
      file,
      ref: ref,
      popupOffset: popupOffset,
    );
  }

  ListDialogItem<FileAction> menu(FileAction value) {
    return ListDialogItem(
      icon: value.icon,
      label: value.label,
      value: value,
    );
  }

  return showListDialog<FileAction>(context, items: [
    menu(FileAction.open),
    menu(FileAction.detail),
    if (file.type != "DIR") menu(FileAction.download),
    menu(FileAction.copy),
    menu(FileAction.move),
    menu(FileAction.rename),
    ListDialogItem(
      child: const Divider(height: 4),
    ),
    menu(FileAction.remove),
  ]);
}

Future<FileAction?> showFilePopupAction(
  BuildContext context,
  File file, {
  WidgetRef? ref,
  Offset? popupOffset,
}) {
  PopupMenuItem<FileAction> menu(FileAction value) {
    return PopupMenuItem<FileAction>(
      height: 24,
      value: value,
      child: ListTile(
        dense: true,
        title: Text(value.label),
        leading: Icon(
          value.icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  final offset = popupOffset!;
  return showMenu(
    context: context,
    menuPadding: const EdgeInsets.all(0),
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.of(context).size.width - offset.dx,
      MediaQuery.of(context).size.height - offset.dy,
      // offset.dx + 1,
      // offset.dy + 1,
    ),
    items: [
      menu(FileAction.open),
      menu(FileAction.detail),
      if (file.type != "DIR") menu(FileAction.download),
      menu(FileAction.copy),
      menu(FileAction.move),
      menu(FileAction.rename),
      PopupMenuItem<FileAction>(
        height: 4,
        child: const Divider(height: 4),
      ),
      menu(FileAction.remove),
    ],
  );
}

enum FileFloatingAction {
  camera,
  photo,
  file,
  folder,
}

extension FileFloatingActionExtension on FileFloatingAction {
  String get label {
    final Map<FileFloatingAction, String> labels = {
      FileFloatingAction.camera: "拍照上传".tr(),
      FileFloatingAction.photo: "相册上传".tr(),
      FileFloatingAction.file: "文件上传".tr(),
      FileFloatingAction.folder: "新建文件夹".tr(),
    };
    return labels[this] ?? "unknown";
  }

  IconData? get icon {
    final Map<FileFloatingAction, IconData> icons = {
      FileFloatingAction.camera: Icons.camera_alt,
      FileFloatingAction.photo: Icons.photo,
      FileFloatingAction.file: Icons.file_upload_outlined,
      FileFloatingAction.folder: Icons.create_new_folder,
    };
    return icons[this];
  }

  Future<void> action(
    BuildContext context,
    String path, {
    WidgetRef? ref,
  }) async {
    final image_picker.ImagePicker picker = image_picker.ImagePicker();

    Future<void>? future;
    switch (this) {
      case FileFloatingAction.camera:
        image_picker.XFile? image = await picker.pickImage(
          source: image_picker.ImageSource.camera,
          imageQuality: 100,
        );
        if (image != null) {
          future = FileService.instance.upload(
            path,
            files: [io.File(image.path)],
          );
        }
        break;
      case FileFloatingAction.photo:
        List<image_picker.XFile> images = await picker.pickMultiImage(
          imageQuality: 100,
        );
        if (images.isNotEmpty) {
          future = FileService.instance.upload(
            path,
            files: images.map((file) => io.File(file.path)).toList(),
          );
        }
        break;
      case FileFloatingAction.file:
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
        );
        if (result != null) {
          future = FileService.instance.upload(
            path,
            files: result.paths.map((path) => io.File(path!)).toList(),
          );
        }
        break;
      case FileFloatingAction.folder:
        final name = await showEditingDialog(context, "新建目录".tr());
        if (name != null) {
          future = FileService.instance.mkdir(path, name);
        }
        break;
    }
    future?.then((_) {
      ref?.invalidate(fileProvider(path));
    });
  }
}

Future<FileFloatingAction?> showFileFloatingAction(
  BuildContext context,
  String path, {
  WidgetRef? ref,
}) async {
  ListDialogItem<FileFloatingAction> menu(FileFloatingAction value) {
    return ListDialogItem(
      icon: value.icon,
      label: value.label,
      value: value,
    );
  }

  return showListDialog<FileFloatingAction>(context,
      cancelAction: true,
      useAlertDialog: true,
      items: [
        if (Util.isMobile) menu(FileFloatingAction.camera),
        if (Util.isMobile) menu(FileFloatingAction.photo),
        menu(FileFloatingAction.file),
        menu(FileFloatingAction.folder),
      ]);
}

enum FileSelectionAction {
  move,
  copy,
  remove,
  rename,
  download,
}

extension FileSelectionActionExtension on FileSelectionAction {
  String get label {
    final Map<FileSelectionAction, String> labels = {
      FileSelectionAction.copy: "复制".tr(),
      FileSelectionAction.move: "移动".tr(),
      FileSelectionAction.rename: "重命名".tr(),
      FileSelectionAction.remove: "删除".tr(),
      FileSelectionAction.download: "下载".tr(),
    };
    return labels[this] ?? "unknown";
  }

  IconData? get icon {
    final Map<FileSelectionAction, IconData> icons = {
      FileSelectionAction.copy: Icons.folder_copy_outlined,
      FileSelectionAction.move: Icons.move_up,
      FileSelectionAction.rename: Icons.drive_file_rename_outline,
      FileSelectionAction.remove: Icons.delete,
      FileSelectionAction.download: Icons.download,
    };
    return icons[this];
  }

  Future<void> action(
    BuildContext context,
    String path,
    List<File> selected, {
    WidgetRef? ref,
  }) async {
    switch (this) {
      case FileSelectionAction.move:
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
          FileService.instance
              .move(
            path,
            result as String,
            selected.map((i) => i.name).toList(),
          )
              .then((_) {
            ref?.invalidate(fileProvider(path));
            ref?.read(fileSelectionProvider.notifier).reset();
          });
        }
        return;
      case FileSelectionAction.copy:
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
          FileService.instance
              .copy(
            path,
            result as String,
            selected.map((i) => i.name).toList(),
          )
              .then((_) {
            ref?.read(fileSelectionProvider.notifier).reset();
          });
        }
        return;
      case FileSelectionAction.rename:
        FileAction.rename.action(context, selected[0], ref: ref).then((_) {
          ref?.read(fileSelectionProvider.notifier).reset();
        });
        return;
      case FileSelectionAction.remove:
        final result = await showAlertDialog<bool>(
          context,
          content: Text("确认删除{n}个文件?".tr(
            args: {"n": selected.length},
          )),
        );
        if (result != null && result) {
          await FileService.instance
              .remove(path, selected.map((i) => i.name).toList())
              .then((_) {
            ref?.invalidate(fileProvider(path));
            ref?.read(fileSelectionProvider.notifier).reset();
          });
        }
        return;
      case FileSelectionAction.download:
        return;
    }
  }
}

Future<FileSelectionAction?> showFileSelectionPopupAction(
  BuildContext context,
  String path,
  List<File> selected, {
  WidgetRef? ref,
  Offset? popupOffset,
}) async {
  PopupMenuItem<FileSelectionAction> menu(FileSelectionAction value) {
    return PopupMenuItem<FileSelectionAction>(
      height: 24,
      value: value,
      child: ListTile(
        dense: true,
        title: Text(value.label),
        leading: Icon(
          value.icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  final offset = popupOffset!;
  return showMenu(
    context: context,
    menuPadding: const EdgeInsets.all(0),
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.of(context).size.width - offset.dx,
      MediaQuery.of(context).size.height - offset.dy,
      // offset.dx + 1,
      // offset.dy + 1,
    ),
    items: [
      menu(FileSelectionAction.download),
      menu(FileSelectionAction.copy),
      menu(FileSelectionAction.move),
      if (selected.length == 1) menu(FileSelectionAction.rename),
      PopupMenuItem<FileSelectionAction>(
        height: 4,
        child: const Divider(height: 4),
      ),
      menu(FileSelectionAction.remove),
    ],
  );
}

class FilePopupAction extends ConsumerWidget {
  const FilePopupAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(fileSettingProvider.select((state) => state.view));
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      position: PopupMenuPosition.under,
      menuPadding: EdgeInsets.zero,
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
    final sortDir =
        ref.watch(fileSettingProvider.select((state) => state.sortDir));
    return PopupMenuButton(
      menuPadding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(sortReversed ? Icons.north : Icons.south, size: 12),
          const SizedBox(width: 4),
          Text(sort.label(context)),
        ],
      ),
      itemBuilder: (context) {
        return <PopupMenuEntry>[
          ...FileListSort.values.map((value) {
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
          }),
          PopupMenuDivider(height: 1),
          PopupMenuItem(
            height: 16 * 2,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: Text("目录优先".tr()),
              trailing: sortDir ? Icon(Icons.check, size: 16) : null,
            ),
            onTap: () {
              ref.read(fileSettingProvider.notifier).update((state) {
                return state.copyWith(sortDir: !state.sortDir);
              });
            },
          ),
        ];
      },
    );
  }
}

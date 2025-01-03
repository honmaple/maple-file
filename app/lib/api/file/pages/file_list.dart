import 'dart:io' as io;
import 'package:path/path.dart' as filepath;
import 'package:desktop_drop/desktop_drop.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/app.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/api/task/providers/task.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/providers/selection.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../widgets/file_view.dart';
import '../widgets/file_action.dart';

import '../providers/file.dart';
import '../providers/service.dart';

class FileList extends ConsumerStatefulWidget {
  final String path;
  const FileList({super.key, this.path = "/"});

  factory FileList.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;
    if (args == null) {
      return const FileList();
    }
    return FileList(path: args as String);
  }

  @override
  ConsumerState<FileList> createState() => _FileListState();
}

class _FileListState extends ConsumerState<FileList> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final taskCount = ref.watch(taskCountProvider(TaskType.running));
    final selection = ref.watch(fileSelectionProvider);
    if (selection.enabled) {
      return FileSelectionList(path: widget.path, selection: selection);
    }

    return Scaffold(
      appBar: _buildAppBar(context, taskCount),
      body: widget.path == "/"
          ? FileView(
              path: widget.path,
              onTap: _onTap,
              onLongPress: (widget.path != "/") ? _onLongPress : null,
            )
          : DropTarget(
              onDragDone: (detail) async {
                final len = detail.files.where((file) {
                  return io.Directory(file.path).existsSync();
                }).length;
                if (len > 0) {
                  App.showSnackBar(Text("无法上传文件夹".tr()));
                  return;
                }
                final result = await showListDialog2<List<io.File>>(
                  context,
                  useRootNavigator: true,
                  child: FileDragList(
                    files: detail.files.map((r) => io.File(r.path)).toList(),
                  ),
                );
                if (result != null) {
                  FileService().upload(widget.path, result).then((_) {
                    ref.invalidate(fileProvider(widget.path));
                  });
                }
              },
              onDragEntered: (detail) {
                setState(() {
                  _dragging = true;
                });
              },
              onDragExited: (detail) {
                setState(() {
                  _dragging = false;
                });
              },
              child: _dragging
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.2),
                      child: Center(
                        child: Text("拖拽文件到这里".tr()),
                      ),
                    )
                  : FileView(
                      path: widget.path,
                      onTap: _onTap,
                      onLongPress: (widget.path != "/") ? _onLongPress : null,
                    ),
            ),
      floatingActionButton:
          (widget.path != "/") ? FileFloatingAction(path: widget.path) : null,
    );
  }

  _buildAppBar(BuildContext context, int taskCount) {
    String title = "";
    if (widget.path != "/") {
      title = widget.path.split('/').last;
    }
    return AppBar(
      leading: widget.path == "/"
          ? Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: const Text(
                'F',
                overflow: TextOverflow.visible,
                softWrap: false,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            )
          : null,
      title: Text(title),
      actions: [
        IconButton(
          icon: Badge(
            label: Text('$taskCount'),
            isLabelVisible: taskCount > 0,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.swap_vert_circle_outlined),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/task/list');
          },
        ),
        const FilePopupAction(),
      ],
    );
  }

  _onTap(BuildContext context, File file) async {
    if (file.type == "DIR") {
      Navigator.of(context).pushNamed(
        '/file/list',
        arguments: filepath.join(file.path, file.name),
      );
      return;
    }
    Navigator.pushNamed(
      context,
      '/file/preview',
      arguments: {
        "file": file,
      },
    );
  }

  _onLongPress(BuildContext context, File item) {
    ref.read(fileSelectionProvider.notifier).update((state) {
      return state.copyWith(enabled: true, selected: [item]);
    });
  }
}

class FileDragList extends ConsumerStatefulWidget {
  final List<io.File> files;
  const FileDragList({super.key, required this.files});

  @override
  ConsumerState<FileDragList> createState() => _FileDragListState();
}

class _FileDragListState extends ConsumerState<FileDragList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("取消".tr()),
        ),
        title: Text("确认上传文件?".tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(widget.files);
            },
            child: Text("确认上传".tr()),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final file in widget.files) _buildDragFile(context, file),
          ],
        ),
      ),
    );
  }

  _buildDragFile(BuildContext context, io.File file) {
    final name = filepath.basename(file.path);
    return ListTile(
      leading: Icon(
        PathUtil.icon(name),
        size: 64 * 0.8,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(name),
      subtitle: Wrap(
        spacing: 8,
        children: [
          Text(
            TimeUtil.formatDate(file.lastModifiedSync(), "yyyy-MM-dd HH:mm"),
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            Util.formatSize(file.lengthSync()),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class FileSelectionList extends ConsumerStatefulWidget {
  final String path;
  final Selection<File> selection;

  const FileSelectionList({
    super.key,
    this.path = "/",
    required this.selection,
  });

  @override
  ConsumerState<FileSelectionList> createState() => _FileSelectionListState();
}

class _FileSelectionListState extends ConsumerState<FileSelectionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: FileView(
        path: widget.path,
        selection: widget.selection,
        onTap: _onTap,
        onLongPress: _onLongPress,
      ),
      bottomNavigationBar: widget.selection.selected.isNotEmpty
          ? FileSelectionAction(
              path: widget.path,
              selected: widget.selection.selected,
            )
          : null,
    );
  }

  _buildAppBar(BuildContext context) {
    final items = ref.watch(fileProvider(widget.path)).valueOrNull ?? <File>[];
    return AppBar(
      automaticallyImplyLeading: false,
      title: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            ref.read(fileSelectionProvider.notifier).reset();
          },
        ),
        title: Text("已选择{count}项".tr(args: {
          "count": widget.selection.selected.length,
        })),
        trailing: Checkbox(
          checkColor: Colors.white,
          value: widget.selection.selected.length == items.length,
          onChanged: (bool? checked) {
            if (checked ?? true) {
              ref.read(fileSelectionProvider.notifier).selectAll(items);
            } else {
              ref.read(fileSelectionProvider.notifier).clear();
            }
          },
        ),
      ),
    );
  }

  _onTap(BuildContext context, File item) {
    ref.read(fileSelectionProvider.notifier).toggle(item);
  }

  _onLongPress(BuildContext context, File item) {
    if (widget.path != "/") {
      ref.read(fileSelectionProvider.notifier).update((state) {
        return state.copyWith(enabled: true, selected: [item]);
      });
    }
  }
}

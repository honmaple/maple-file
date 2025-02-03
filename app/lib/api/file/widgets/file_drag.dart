import 'dart:io' as io;
import 'package:desktop_drop/desktop_drop.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../providers/file.dart';
import '../providers/service.dart';

class FileDrag extends ConsumerStatefulWidget {
  const FileDrag({
    super.key,
    required this.child,
    this.path = "/",
    this.enable = true,
  });

  final String path;
  final Widget child;
  final bool enable;

  @override
  ConsumerState<FileDrag> createState() => _FileDragState();
}

class _FileDragState extends ConsumerState<FileDrag> {
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      enable: widget.enable,
      onDragDone: (detail) async {
        final files = detail.files.map((item) {
          return File(
            name: item.name,
            path: item.path,
            type: io.Directory(item.path).existsSync() ? "DIR" : item.mimeType,
          );
        }).toList();

        final result = await showListDialog2<List<File>>(
          context,
          child: FileDragList(files: files),
        );
        if (result != null) {
          _handleUpload(result);
        }
      },
      onDragEntered: (detail) {
        setState(() {
          _dragging = true;
        });
      },
      onDragExited: (detail) async {
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
          : widget.child,
    );
  }

  _handleUpload(List<File> uploads) {
    final dirs = uploads.where((file) {
      return file.type == "DIR";
    }).map((file) {
      return io.Directory(file.path);
    }).toList();

    final files = uploads.where((file) {
      return file.type != "DIR";
    }).map((file) {
      return io.File(file.path);
    }).toList();

    FileService().upload(widget.path, files: files, dirs: dirs).then((_) {
      ref.invalidate(fileProvider(widget.path));
    });
  }
}

class FileDragList extends ConsumerStatefulWidget {
  const FileDragList({super.key, required this.files});

  final List<File> files;

  @override
  ConsumerState<FileDragList> createState() => _FileDragListState();
}

class _FileDragListState extends ConsumerState<FileDragList> {
  List<File> files = [];

  @override
  void initState() {
    super.initState();

    files = [...widget.files];
  }

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
          if (files.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(files);
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

  _buildDragFile(BuildContext context, File file) {
    final stat = file.type == "DIR"
        ? io.Directory(file.path).statSync()
        : io.File(file.path).statSync();

    return ListTile(
      leading: Icon(
        PathUtil.icon(file.name, type: file.type),
        size: 64 * 0.8,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(file.name),
      subtitle: Wrap(
        spacing: 8,
        children: [
          Text(
            TimeUtil.formatDate(stat.modified, "yyyy-MM-dd HH:mm"),
            style: const TextStyle(fontSize: 12),
          ),
          if (file.type != "DIR")
            Text(
              Util.formatSize(stat.size),
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
      trailing: Checkbox(
        value: files.contains(file),
        onChanged: (checked) {
          if (checked ?? false) {
            files.add(file);
          } else {
            files.remove(file);
          }
          setState(() {});
        },
      ),
    );
  }
}

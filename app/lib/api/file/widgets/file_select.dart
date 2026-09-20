import 'dart:math' as math;

import 'package:maple_file/api/file/providers/service.dart';
import 'package:path/path.dart' as filepath;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/providers/selection.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../providers/file.dart';
import 'file_view.dart';

enum FileSelectMode {
  directory,
  file,
  files;

  bool get selectsDirectory => this == FileSelectMode.directory;
  bool get allowsMultiple => this == FileSelectMode.files;
}

Future<String?> showDirectorySelectDialog(
  BuildContext context, {
  String path = '/',
  String title = '选择文件',
  bool Function(File)? filter,
  bool useRootNavigator = false,
}) async {
  final result = await _showFileSelectDialog(
    context,
    path: path,
    title: title,
    filter: filter,
    mode: FileSelectMode.directory,
    useRootNavigator: useRootNavigator,
  );
  return result?.single;
}

Future<String?> showFileSelectDialog(
  BuildContext context, {
  String path = '/',
  String title = '选择文件',
  bool Function(File)? filter,
  bool useRootNavigator = false,
}) async {
  final result = await _showFileSelectDialog(
    context,
    path: path,
    title: title,
    filter: filter,
    mode: FileSelectMode.file,
    useRootNavigator: useRootNavigator,
  );
  return result?.single;
}

Future<List<String>?> showMultipleFileSelectDialog(
  BuildContext context, {
  String path = '/',
  String title = '选择文件',
  bool Function(File)? filter,
  bool useRootNavigator = false,
}) async {
  final result = await _showFileSelectDialog(
    context,
    path: path,
    title: title,
    filter: filter,
    mode: FileSelectMode.files,
    useRootNavigator: useRootNavigator,
  );
  return result;
}

Future<List<String>?> _showFileSelectDialog(
  BuildContext context, {
  required String path,
  required String title,
  required FileSelectMode mode,
  bool Function(File)? filter,
  required bool useRootNavigator,
}) {
  final size = MediaQuery.sizeOf(context);
  final navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );

  return showCustomDialog<List<String>>(
    context,
    width: math.max(280.0, math.min(720.0, size.width - 64)),
    height: math.max(320.0, math.min(720.0, size.height - 80)),
    useRootNavigator: useRootNavigator,
    child: ProviderScope(
      overrides: [
        fileSelectionProvider.overrideWith(
          () => SelectionNotifier<File>(
            compare: (oldFile, newFile) =>
                oldFile.path == newFile.path && oldFile.name == newFile.name,
            multiple: mode.allowsMultiple,
          ),
        ),
      ],
      child: FileSelectPage(
        path: path,
        title: title,
        filter: filter,
        mode: mode,
        onClose: () => navigator.pop(),
        onSelected: (result) => navigator.pop(result),
      ),
    ),
  );
}

class FileSelectPage extends ConsumerStatefulWidget {
  final String path;
  final String title;
  final bool Function(File)? filter;
  final FileSelectMode mode;
  final VoidCallback onClose;
  final ValueChanged<List<String>> onSelected;

  const FileSelectPage({
    super.key,
    this.path = "/",
    this.title = "选择文件",
    this.filter,
    required this.mode,
    required this.onClose,
    required this.onSelected,
  });

  @override
  ConsumerState<FileSelectPage> createState() => _FileSelectState();
}

class _FileSelectState extends ConsumerState<FileSelectPage> {
  static const double _bottomActionBarHeight = 64;
  late String _path;

  @override
  void initState() {
    super.initState();
    _path = widget.path;
  }

  @override
  Widget build(BuildContext context) {
    final selection = ref.watch(fileSelectionProvider);
    final showBottomBar = _path != "/" &&
        (widget.mode.selectsDirectory || selection.selected.isNotEmpty);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomBarHeight = _bottomActionBarHeight + bottomInset;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.title.tr()),
        leading: TextButton(
          onPressed: widget.onClose,
          child: Text("取消".tr()),
        ),
        trailingActions: [
          if (_path != "/" && widget.mode.selectsDirectory)
            TextButton(
              child: Text("新建文件夹".tr()),
              onPressed: () async {
                final result = await showCustomEditingDialog(
                  context: context,
                  label: "新建文件夹".tr(),
                );
                if (result != null) {
                  FileService.instance.mkdir(_path, result).then((_) {
                    ref.invalidate(fileProvider(_path));
                  });
                }
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: showBottomBar ? bottomBarHeight : 0,
            child: FileView(
              key: ValueKey(_path),
              path: _path,
              filter: _filter,
              selection: selection,
              showActions: false,
              onPathChanged: _handlePathChanged,
              fileBuilder: (context, file, child) {
                return InkWell(
                  onTap: () => _handleTap(context, file),
                  child: child,
                );
              },
            ),
          ),
          if (showBottomBar)
            PositionedDirectional(
              start: 0,
              end: 0,
              bottom: 0,
              height: bottomBarHeight,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                elevation: 8,
                child: SafeArea(
                  top: false,
                  child: _buildBottomBar(context),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return OverflowBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: FilledButton(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                final result = ref
                    .read(fileSelectionProvider)
                    .selected
                    .map((file) => filepath.posix.join(file.path, file.name))
                    .toList();

                if (widget.mode.selectsDirectory) {
                  widget.onSelected([_path]);
                  return;
                }
                if (widget.mode.allowsMultiple) {
                  widget.onSelected(result);
                } else if (result.isNotEmpty) {
                  widget.onSelected([result.first]);
                }
              },
              child: Text('确定'.tr()),
            ),
          ),
        ),
      ],
    );
  }

  bool _filter(File file) {
    if (file.type == "DIR") {
      return widget.mode.selectsDirectory
          ? widget.filter?.call(file) ?? true
          : true;
    }
    return widget.filter?.call(file) ?? false;
  }

  Future<void> _handleTap(BuildContext context, File item) async {
    final selection = ref.read(fileSelectionProvider);
    if (item.type == "DIR") {
      _handlePathChanged(filepath.posix.join(item.path, item.name));
      return;
    }

    if (!selection.enabled) {
      ref.read(fileSelectionProvider.notifier).update((state) {
        return state.copyWith(
          enabled: true,
          multiple: widget.mode.allowsMultiple,
        );
      });
    }
    ref.read(fileSelectionProvider.notifier).toggle(item);
  }

  void _handlePathChanged(String path) {
    ref.read(fileSelectionProvider.notifier).reset();
    setState(() {
      _path = path;
    });
  }
}

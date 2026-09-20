import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/api/task/providers/task.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/responsive.dart';
import 'package:maple_file/common/providers/selection.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../widgets/file_drag.dart';
import '../widgets/file_view.dart';
import '../widgets/file_action.dart';

import '../providers/file.dart';

class FileListScreen extends ConsumerStatefulWidget {
  final String path;
  const FileListScreen({super.key, this.path = "/"});

  factory FileListScreen.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;
    if (args == null) {
      return const FileListScreen();
    }
    return FileListScreen(path: args as String);
  }

  @override
  ConsumerState<FileListScreen> createState() => _FileListState();
}

class _FileListState extends ConsumerState<FileListScreen> {
  late bool _dragEnable;

  bool get _isRoot => widget.path == "/";

  @override
  void initState() {
    super.initState();

    _dragEnable = !_isRoot;
  }

  @override
  Widget build(BuildContext context) {
    final taskCount = ref.watch(taskCountProvider(TaskType.running));
    final selection = ref.watch(fileSelectionProvider);
    if (selection.enabled) {
      return FileSelectionList(path: widget.path, selection: selection);
    }

    return PlatformScaffold(
      appBar: _buildAppBar(context, taskCount),
      body: Stack(
        children: [
          Positioned.fill(
            child: FileDrag(
              enable: _dragEnable,
              path: widget.path,
              child: FileView(
                path: widget.path,
                fileBuilder: (context, file, child) {
                  return InkWell(
                    onTap: () => _handleTap(context, file),
                    onLongPress:
                        _isRoot ? null : () => _handleLongPress(context, file),
                    onSecondaryTapUp:
                        (!_isRoot && (Util.isDesktop || Util.isWeb))
                            ? (detail) =>
                                _handleSecondaryTapUp(context, file, detail)
                            : null,
                    child: child,
                  );
                },
              ),
            ),
          ),
          if (!_isRoot)
            PositionedDirectional(
              end: 16,
              bottom: 16,
              child: SafeArea(
                child: FloatingActionButton(
                  shape: const CircleBorder(),
                  onPressed: _handleFloatingAction,
                  child: const Icon(Icons.add_a_photo),
                ),
              ),
            ),
        ],
      ),
    );
  }

  PlatformAppBar _buildAppBar(BuildContext context, int taskCount) {
    String title = "";
    if (!_isRoot) {
      title = widget.path.split('/').last;
    }
    return PlatformAppBar(
      leading: _isRoot
          ? Container(
              alignment: Alignment.centerLeft,
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
      trailingActions: [
        if (Breakpoint.isSmall(context))
          IconButton(
            iconSize: 24,
            icon: Badge(
              label: Text('$taskCount'),
              isLabelVisible: taskCount > 0,
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.swap_vert_circle_outlined),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/task/list');
            },
          ),
        const FilePopupAction(),
      ],
    );
  }

  Future<void> _handleTap(BuildContext context, File file) async {
    setState(() {
      _dragEnable = false;
    });
    await FileAction.open.action(context, file, ref: ref);
    setState(() {
      _dragEnable = !_isRoot;
    });
  }

  void _handleLongPress(BuildContext context, File file) {
    ref.read(fileSelectionProvider.notifier).update((state) {
      return state.copyWith(enabled: true, selected: [file]);
    });
  }

  Future<void> _handleSecondaryTapUp(
    BuildContext context,
    File file,
    TapUpDetails detail,
  ) async {
    final result = await showFilePopupAction(
      context,
      file,
      popupOffset: detail.globalPosition,
    );
    if (!context.mounted) return;
    result?.action(context, file, ref: ref);
  }

  Future<void> _handleFloatingAction() async {
    final result = await showFileFloatingAction(
      context,
      widget.path,
      ref: ref,
    );
    if (!mounted) return;
    result?.action(context, widget.path, ref: ref);
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
  static const double _bottomActionBarHeight = 64;

  @override
  Widget build(BuildContext context) {
    final showBottomBar = Util.isMobile && widget.selection.selected.isNotEmpty;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final bottomBarHeight = _bottomActionBarHeight + bottomInset;

    return PlatformScaffold(
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: showBottomBar ? bottomBarHeight : 0,
            child: FileView(
              path: widget.path,
              selection: widget.selection,
              fileBuilder: (context, file, child) {
                return InkWell(
                  onTap: () => _handleTap(context, file),
                  onLongPress: () => _handleLongPress(context, file),
                  onSecondaryTapUp: ((Util.isDesktop || Util.isWeb) &&
                          widget.selection.selected.isNotEmpty)
                      ? (detail) => _handleSecondaryTapUp(context, detail)
                      : null,
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

  PlatformAppBar _buildAppBar(BuildContext context) {
    final items = ref.watch(fileProvider(widget.path)).valueOrNull ?? <File>[];
    return PlatformAppBar(
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

  Widget _buildBottomBar(BuildContext context) {
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
              children: [
                FileSelectionAction.copy,
                FileSelectionAction.move,
                if (widget.selection.selected.length == 1)
                  FileSelectionAction.rename,
                FileSelectionAction.download,
                FileSelectionAction.remove,
              ].map((value) {
                return TextButton(
                  child: Wrap(
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(value.icon),
                      Text(value.label),
                    ],
                  ),
                  onPressed: () {
                    value.action(
                      context,
                      widget.path,
                      widget.selection.selected,
                      ref: ref,
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _handleTap(BuildContext context, File item) {
    ref.read(fileSelectionProvider.notifier).toggle(item);
  }

  void _handleLongPress(BuildContext context, File item) {
    if (widget.path != "/") {
      ref.read(fileSelectionProvider.notifier).update((state) {
        return state.copyWith(enabled: true, selected: [item]);
      });
    }
  }

  Future<void> _handleSecondaryTapUp(
    BuildContext context,
    TapUpDetails detail,
  ) async {
    final result = await showFileSelectionPopupAction(
      context,
      widget.path,
      widget.selection.selected,
      ref: ref,
      popupOffset: detail.globalPosition,
    );
    if (!context.mounted) return;
    result?.action(context, widget.path, widget.selection.selected, ref: ref);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/responsive.dart';
import 'package:maple_file/common/providers/selection.dart';

import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import 'file_action.dart';
import 'file_breadcrumb.dart';

import '../providers/file.dart';
import '../providers/file_setting.dart';

typedef FileViewTapCallback = void Function(BuildContext, File);

class FileView extends ConsumerStatefulWidget {
  const FileView({
    super.key,
    this.path = "/",
    this.filter,
    this.selection,
    this.onTap,
    this.onLongPress,
  });

  final String path;
  final bool Function(File)? filter;
  final Selection<File>? selection;
  final FileViewTapCallback? onTap;
  final FileViewTapCallback? onLongPress;

  @override
  ConsumerState<FileView> createState() => _FileViewState();
}

class _FileViewState extends ConsumerState<FileView> {
  @override
  Widget build(BuildContext context) {
    return CustomRefresh(
      onLoad: () => ref.invalidate(fileProvider(widget.path)),
      onRefresh: () => ref.invalidate(fileProvider(widget.path)),
      childBuilder: (context, physics) {
        return CustomScrollView(
          physics: physics,
          slivers: [
            if (widget.path != "/")
              SliverToBoxAdapter(
                child: ListTile(
                  dense: true,
                  title: FileBreadcrumb(path: widget.path),
                  trailing: const FileSortAction(),
                ),
              ),
            CustomSliverAsyncValue(
              value: ref.watch(fileProvider(widget.path)),
              builder: (items) => buildView(context, items),
            ),
          ],
        );
      },
    );
  }

  buildView(BuildContext context, List<File> items) {
    if (widget.filter != null) {
      items = items.where(widget.filter!).toList();
    }
    if (items.isEmpty) {
      if (widget.path == "/") {
        return SliverFillRemaining(
          child: Center(
            child: TextButton.icon(
              icon: const Icon(Icons.add),
              label: Text("创建存储".tr(context)),
              onPressed: () {
                Navigator.pushNamed(context, '/file/setting/repo/edit');
              },
            ),
          ),
        );
      }
      return const SliverFillRemaining(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.hourglass_empty,
              size: 36,
              color: Colors.black54,
            ),
            SizedBox(height: 8),
            Text(
              "暂无文件",
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      );
    }
    final view = ref.watch(fileSettingProvider.select((state) => state.view));
    return view == FileListView.GRID
        ? buildGridView(context, items)
        : buildListView(context, items);
  }

  buildListView(BuildContext context, List<File> rows) {
    final selection = widget.selection ?? Selection<File>();
    final setting = ref.watch(fileSettingProvider);

    return SliverList.builder(
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];

        final size = (row.size / 1024 / 1024).toStringAsFixed(2);
        return GestureDetector(
          onTap: widget.onTap == null
              ? null
              : () {
                  widget.onTap?.call(context, row);
                },
          onLongPress: widget.onLongPress == null
              ? null
              : () {
                  widget.onLongPress?.call(context, row);
                },
          child: ListTile(
            leading: _buildIcon(row, setting, 0.8),
            title: Text(row.name),
            subtitle: Wrap(
              spacing: 8,
              children: [
                Text(
                  TimeUtil.pbToString(row.updatedAt, "yyyy-MM-dd HH:mm:ss"),
                  style: const TextStyle(fontSize: 12),
                ),
                if (Breakpoint.isDesktop(context) && row.type != "DIR")
                  Text(
                      "文件大小: {size}MB".tr(
                        context,
                        args: {"size": size},
                      ),
                      style: const TextStyle(fontSize: 12)),
              ],
            ),
            selected: selection.contains(row),
            trailing: _isSelection(row)
                ? _buildCheckbox(selection, row)
                : IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showFileAction(context, row, ref);
                    },
                  ),
          ),
        );
      },
    );
  }

  buildGridView(BuildContext context, List<File> rows) {
    final selection = widget.selection ?? Selection<File>();

    final setting = ref.watch(fileSettingProvider);
    return SliverAlignedGrid.extent(
      itemCount: rows.length,
      // 单个文件占用的宽度
      maxCrossAxisExtent: 100,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        final row = rows[index];
        return Stack(children: [
          if (_isSelection(row))
            Positioned(
              top: -4,
              right: -4,
              child: _buildCheckbox(selection, row),
            ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIcon(row, setting, 1),
                  const SizedBox(height: 8),
                  Text(
                    row.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            onTap: () {
              widget.onTap?.call(context, row);
            },
            onLongPress: () {
              widget.onLongPress?.call(context, row);
            },
          ),
        ]);
      },
    );
  }

  _buildIcon(File row, FileSetting setting, double size) {
    if (setting.icon == FileListIcon.CIRCLE) {
      return Container(
        height: 48 * size,
        width: 48 * size,
        decoration: BoxDecoration(
          color: setting.iconColor != null
              ? setting.color
              : ColorUtil.backgroundColorWithString(row.name),
          borderRadius: BorderRadius.all(Radius.circular(24 * size)),
        ),
        alignment: Alignment.center,
        child: Icon(
          _getIcon(row),
          color: ColorUtil.foregroundColorWithString(row.name),
        ),
      );
    }
    return Icon(
      _getIcon(row),
      size: 64 * size,
      color: setting.iconColor != null
          ? setting.color
          : ColorUtil.backgroundColorWithString(row.name),
    );
  }

  _buildCheckbox(Selection<File> selection, File row) {
    return Checkbox(
      value: selection.contains(row),
      onChanged: (checked) {
        ref.read(fileSelectionProvider.notifier).toggle(row, checked: checked);
      },
    );
  }

  bool _isSelection(File file) {
    if (widget.selection != null && widget.selection!.enabled) {
      if (widget.onLongPress == null) {
        return file.type != "DIR";
      }
      return true;
    }
    return false;
  }

  IconData _getIcon(File row) {
    String fileType = row.type;
    // 由于未知原因，golang后端服务访回的部分类型为空
    if (fileType == "") {
      fileType = Util.mimeType(row.name);
    }
    if (fileType == "DIR") {
      return Icons.folder;
    } else if (fileType.startsWith("text/")) {
      return Icons.note;
    } else if (fileType.startsWith("image/")) {
      return Icons.image;
    } else if (fileType.startsWith("video/")) {
      return Icons.video_file;
    } else if (fileType.startsWith("audio/")) {
      return Icons.audio_file;
    } else {
      return Icons.note;
    }
  }
}

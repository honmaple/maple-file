import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/custom.dart';
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
    return CustomPaging(
      onLoad: () => ref.read(fileProvider(widget.path).notifier).load(),
      onRefresh: () => ref.read(fileProvider(widget.path).notifier).refresh(),
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
              label: Text("创建存储".tr()),
              onPressed: () {
                Navigator.pushNamed(context, '/file/setting/repo/edit');
              },
            ),
          ),
        );
      }
      return SliverFillRemaining(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.hourglass_empty,
              size: 36,
              color: Colors.black54,
            ),
            const SizedBox(height: 8),
            Text(
              "暂无文件".tr(),
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      );
    }
    final view = ref.watch(fileSettingProvider.select((state) => state.view));
    return view == FileListView.grid
        ? buildGridView(context, items)
        : buildListView(context, items);
  }

  buildListView(BuildContext context, List<File> rows) {
    final selection = widget.selection ?? Selection<File>();
    final setting = ref.watch(fileSettingProvider);

    return SliverList.builder(
      // separatorBuilder: (context, index) => Divider(
      //   height: 0.5,
      //   indent: 64,
      // ),
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];

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
            title: _buildName(row),
            subtitle: Wrap(
              spacing: 8,
              children: [
                Text(
                  TimeUtil.pbToString(row.updatedAt, "yyyy-MM-dd HH:mm"),
                  style: const TextStyle(fontSize: 12),
                ),
                if (row.type != "DIR")
                  Text(
                    Util.formatSize(row.size),
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            selected: selection.contains(row),
            trailing: _isSelection(row)
                ? _buildCheckbox(selection, row)
                : widget.path != "/"
                    ? IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showFileAction(context, row, ref);
                        },
                      )
                    : null,
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
                  _buildName(row, maxLines: 2),
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

  _buildName(File row, {int? maxLines}) {
    if (row.type == "RECYCLE") {
      return Text("回收站".tr());
    }
    return Text(
      row.name,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  _buildIcon(File row, FileSetting setting, double size) {
    if (setting.icon == FileListIcon.circle) {
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
          PathUtil.icon(row.name, type: row.type),
          color: ColorUtil.foregroundColorWithString(row.name),
        ),
      );
    }
    return Icon(
      PathUtil.icon(row.name, type: row.type),
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
}

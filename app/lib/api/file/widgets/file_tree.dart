import 'dart:math' as math;
import 'package:path/path.dart' as filepath;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/widgets/tree.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../providers/file.dart';

import 'file_view.dart';
import 'file_action.dart';

class FileTree extends ConsumerStatefulWidget {
  const FileTree({
    super.key,
    this.path = "/",
    this.dense = true,
    this.navigatorKey,
  });

  final bool dense;
  final String path;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  ConsumerState<FileTree> createState() => FileTreeState();
}

class FileTreeState extends ConsumerState<FileTree> {
  final CustomTreeViewController _controller = CustomTreeViewController();

  NavigatorState navigatorState(context) {
    return widget.navigatorKey?.currentState ?? Navigator.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomSliverAsyncValue(
      value: ref.watch(fileProvider(widget.path)),
      builder: (items) {
        if (items.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text("暂无数据".tr()),
            ),
          );
        }

        final List<CustomTreeNode<File>> tree = [
          for (final item in items)
            CustomTreeNode<File>(item, key: "${item.id} ${item.name}"),
        ];
        return CustomSliverTreeView<File>(
          tree: tree,
          controller: _controller,
          nodeBuilder: _nodeBuilder,
        );
      },
    );
  }

  Widget _nodeBuilder(
    BuildContext context,
    CustomTreeNode<File> node,
  ) {
    final file = node.content;

    return Container(
      padding: EdgeInsets.only(left: 12.0 * (node.depth ?? 0)),
      child: GestureDetector(
        onSecondaryTapUp: file.path == "/"
            ? null
            : (detail) async {
                final result = await showFilePopupAction(
                  context,
                  file,
                  popupOffset: detail.globalPosition,
                );
                if (!context.mounted) return;
                result?.action(
                  context,
                  file,
                  ref: ref,
                  navigator: navigatorState(context),
                );
              },
        child: ListTile(
          dense: widget.dense,
          title: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                file.name,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          leading: FileIcon(file: file, size: 0.5),
          trailing: PathUtil.isDir(file.name, type: file.type)
              ? AnimatedRotation(
                  turns: node.isExpanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: Transform.rotate(
                      angle: math.pi / 180,
                      child: const Icon(Icons.expand_more, size: 18)),
                )
              : null,
          onTap: () async {
            if (!PathUtil.isDir(file.name, type: file.type)) {
              navigatorState(context).popAndPushNamed(
                '/file/preview',
                arguments: {
                  "file": file,
                },
              );
              return;
            }

            if (node.isExpanded) {
              _controller.collapseNode(node);
              return;
            }

            String path = file.name;
            CustomTreeNode<File>? parent = node.parent;

            while (parent != null) {
              path = filepath.posix.join(parent.content.name, path);
              parent = parent.parent;
            }
            path = filepath.posix.join(widget.path, path);

            final files = await ref.refresh(fileProvider(path).future);
            node.children.clear();
            for (final file in files) {
              node.children.add(CustomTreeNode<File>(
                file,
                key: "${file.path}:${file.name}",
              ));
            }
            _controller.expandNode(node);
          },
        ),
      ),
    );
  }
}

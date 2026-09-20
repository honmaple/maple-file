import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as filepath;

import 'package:maple_file/api/file/providers/file.dart';
import 'package:maple_file/api/file/providers/service.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform/list.dart';

class FileDirectorySelect extends ConsumerStatefulWidget {
  const FileDirectorySelect({super.key, this.title});

  final String? title;

  @override
  ConsumerState<FileDirectorySelect> createState() =>
      _FileDirectorySelectState();
}

class _FileDirectorySelectState extends ConsumerState<FileDirectorySelect> {
  String _path = '/';

  @override
  Widget build(BuildContext context) {
    final currentPath = _path;
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(widget.title ?? '选择目录'.tr()),
        automaticallyImplyLeading: false,
        leading: TextButton(
          child: Text(currentPath == '/' ? '取消'.tr() : '上一级'.tr()),
          onPressed: () {
            if (currentPath == '/') {
              Navigator.of(context).pop();
            } else {
              setState(() => _path = filepath.posix.dirname(currentPath));
            }
          },
        ),
        trailingActions: [
          if (currentPath != '/')
            TextButton(
              onPressed: () async {
                final name = await showCustomEditingDialog(
                  context: context,
                  label: '新建文件夹'.tr(),
                );
                if (!mounted || name == null || name.isEmpty) return;
                await FileService.instance.mkdir(currentPath, name);
                ref.invalidate(fileProvider(currentPath));
              },
              child: Text('新建文件夹'.tr()),
            ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            dense: true,
            title: Text(
              currentPath == '/' ? '全部文件'.tr() : currentPath,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: CustomPaging(
              onLoad: () => ref.read(fileProvider(currentPath).notifier).load(),
              onRefresh: () =>
                  ref.read(fileProvider(currentPath).notifier).refresh(),
              slivers: [
                CustomSliverAsyncValue(
                  value: ref.watch(fileProvider(currentPath)),
                  builder: (files) {
                    final directories =
                        files.where((file) => file.type == 'DIR').toList();
                    if (directories.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(child: Text('暂无文件夹'.tr())),
                      );
                    }
                    return SliverList.builder(
                      itemCount: directories.length,
                      itemBuilder: (context, index) {
                        final directory = directories[index];
                        return PlatformListTile(
                          leading: const Icon(Icons.folder_outlined),
                          title: Text(directory.name),
                          trailing: const PlatformListTileChevron(),
                          onTap: () => setState(() {
                            _path = filepath.posix.join(
                              directory.path,
                              directory.name,
                            );
                          }),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: currentPath == '/'
                    ? null
                    : () => Navigator.of(context).pop(currentPath),
                child: Text('确认'.tr()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

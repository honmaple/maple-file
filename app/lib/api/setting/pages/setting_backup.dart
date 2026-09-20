import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:path/path.dart' as filepath;
import 'package:file_picker/file_picker.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import 'package:maple_file/api/file/providers/file.dart';
import 'package:maple_file/api/file/providers/service.dart';

class SettingBackupScreen extends ConsumerStatefulWidget {
  const SettingBackupScreen({super.key});

  @override
  ConsumerState<SettingBackupScreen> createState() => _SettingBackupState();
}

class _SettingBackupState extends ConsumerState<SettingBackupScreen> {
  late final Future<_BackupFileInfo> _backupFileInfo;

  @override
  void initState() {
    super.initState();
    _backupFileInfo = _loadBackupFileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('备份与恢复'.tr()),
        cupertino: (context, platform) => CupertinoNavigationBarData(
          previousPageTitle: '设置'.tr(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          _buildBackupFileSection(context),
          _buildBackupSection(context),
          _buildRestoreSection(context),
        ],
      ),
    );
  }

  Widget _buildBackupFileSection(BuildContext context) {
    final themeData = Theme.of(context);
    return CustomListSection(
      children: [
        PlatformListTile(
          leading: Icon(
            Icons.storage_rounded,
            color: themeData.colorScheme.primary,
          ),
          title: Text('备份文件'.tr()),
          subtitle: FutureBuilder<_BackupFileInfo>(
            future: _backupFileInfo,
            builder: (context, snapshot) {
              final info = snapshot.data;
              if (info == null) {
                return const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              return Column(
                spacing: 2,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: info.name,
                      children: [
                        TextSpan(text: " · "),
                        TextSpan(text: Util.formatSize(info.size))
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "更新于 {time}".tr(args: {
                      "time": TimeUtil.datetimeToString(info.modified),
                    }),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBackupSection(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return CustomListSection(
      header: Text(
        '备份'.tr(),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      children: [
        PlatformListTile(
          leading: Icon(Icons.folder_outlined, color: primaryColor),
          title: Text('备份至本地'.tr()),
          subtitle: Text('保存到设备文件夹'.tr()),
          trailing: const PlatformListTileChevron(),
          onTap: _handleBackupToLocal,
        ),
        PlatformListTile(
          leading: Icon(Icons.cloud_upload_outlined, color: primaryColor),
          title: Text('备份至云盘'.tr()),
          subtitle: Text('保存到云盘中的文件夹'.tr()),
          trailing: const PlatformListTileChevron(),
          onTap: _handleBackupToCloud,
        ),
      ],
    );
  }

  Widget _buildRestoreSection(BuildContext context) {
    final themeData = Theme.of(context);
    return CustomListSection(
      header: Text(
        '恢复'.tr(),
        style: themeData.textTheme.bodySmall,
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 16,
              color: themeData.colorScheme.error,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '恢复备份将会覆盖红枫云盘的所有数据'.tr(),
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
      children: [
        PlatformListTile(
          leading: Icon(
            Icons.folder_open_outlined,
            color: themeData.colorScheme.error,
          ),
          title: Text('从本地恢复'.tr()),
          subtitle: Text('选择设备中的备份文件'.tr()),
          trailing: const PlatformListTileChevron(),
          onTap: _handleRestoreFromLocal,
        ),
        PlatformListTile(
          leading: Icon(
            Icons.cloud_download_outlined,
            color: themeData.colorScheme.error,
          ),
          title: Text('从云盘恢复'.tr()),
          subtitle: Text('选择云盘中的备份文件'.tr()),
          trailing: const PlatformListTileChevron(),
          onTap: _handleRestoreFromCloud,
        ),
      ],
    );
  }

  Future<_BackupFileInfo> _loadBackupFileInfo() async {
    final path = await PathUtil.getDatabasePath();
    final stat = await io.File(path).stat();
    return _BackupFileInfo(
      name: filepath.basename(path),
      size: stat.size,
      modified: stat.modified,
    );
  }

  Future<void> _handleBackupToLocal() async {
    String? result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "请选择备份路径".tr(),
    );
    if (result != null) {
      final name = _generateName();

      final src = await PathUtil.getDatabasePath();
      final dst = filepath.join(result, name);

      doFuture(() {
        return io.File(src).copy(dst).then((_) {
          SmartDialog.showNotify(
            msg: "备份成功，文件名称: {name}".tr(args: {
              "name": name,
            }),
            notifyType: NotifyType.success,
          );
        });
      });
    }
  }

  Future<void> _handleBackupToCloud() async {
    final Map<String, dynamic> args = {
      "path": "/",
      "title": "备份文件到".tr(),
    };
    final result = await Navigator.pushNamed(
      context,
      '/file/select',
      arguments: args,
    );
    if (result != null) {
      final name = _generateName();
      final path = await PathUtil.getDatabasePath();
      FileService.instance.upload(result as String, files: [
        io.File(path)
      ], newNames: {
        path: name,
      }).then((_) {
        SmartDialog.showNotify(
          msg: "备份成功，文件名称: {name}".tr(args: {
            "name": name,
          }),
          notifyType: NotifyType.success,
        );
        ref.invalidate(fileProvider(result));
      });
    }
  }

  Future<void> _handleRestoreFromLocal() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "请选择备份文件".tr(),
      // type: FileType.custom,
      // allowedExtensions: ["db"],
    );
    if (result != null && result.files.isNotEmpty) {
      final src = result.files.single.path!;
      if (!src.endsWith(".db")) {
        SmartDialog.showNotify(
          msg: "错误的文件类型".tr(),
          notifyType: NotifyType.error,
        );
        return;
      }
      final dst = await PathUtil.getDatabasePath();

      doFuture(() {
        return io.File(src).copy(dst).then((resp) {
          SmartDialog.showNotify(
            msg: "恢复成功，请重启应用".tr(),
            notifyType: NotifyType.success,
          );
        });
      });
    }
  }

  Future<void> _handleRestoreFromCloud() async {
    final Map<String, dynamic> args = {
      "path": "/",
      "title": "请选择备份文件".tr(),
      "filter": (File file) => file.name.endsWith(".db"),
      "selectDir": false,
    };
    final result = await Navigator.pushNamed(
      context,
      '/file/select',
      arguments: args,
    );
    if (result != null) {
      final path = await PathUtil.getDatabasePath();

      FileService.instance
          .download(result as String, io.File(path), override: true)
          .then((_) {
        SmartDialog.showNotify(
          msg: "恢复成功，请重启应用".tr(),
          notifyType: NotifyType.success,
        );
      });
    }
  }

  String _generateName() {
    return "server_${TimeUtil.formatDate(DateTime.now(), 'yyyyMMddHHmmss')}.db";
  }
}

class _BackupFileInfo {
  const _BackupFileInfo({
    required this.name,
    required this.size,
    required this.modified,
  });

  final String name;
  final int size;
  final DateTime modified;
}

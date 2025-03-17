import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maple_file/api/file/providers/file.dart';
import 'package:maple_file/api/file/providers/service.dart';

import 'package:path/path.dart' as filepath;
import 'package:file_picker/file_picker.dart';

import 'package:maple_file/app/app.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

class SettingBackup extends ConsumerStatefulWidget {
  const SettingBackup({super.key});

  @override
  ConsumerState<SettingBackup> createState() => _SettingBackupState();
}

class _SettingBackupState extends ConsumerState<SettingBackup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('备份与恢复'.tr()),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: CustomScrollView(
          slivers: [
            buildBody(context),
          ],
        ),
      ),
    );
  }

  buildBody(BuildContext context) {
    return SliverList.list(
      children: <Widget>[
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text('备份文件'.tr()),
                subtitle: FutureBuilder(
                  future: PathUtil.getDatabasePath(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Text(snapshot.data);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text('备份'.tr()),
            onPressed: () {
              showListDialog2(
                context,
                useAlertDialog: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.local_library,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text("备份至本地".tr()),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _backupToLocal();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.cloud,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text("备份至云盘".tr()),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _backupToCloud();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text('恢复'.tr()),
            onPressed: () {
              showListDialog2(
                context,
                useAlertDialog: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.local_library,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text("从本地恢复".tr()),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _restoreFromLocal();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.cloud,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text("从云盘恢复".tr()),
                      onTap: () async {
                        Navigator.of(context).pop();
                        await _restoreFromCloud();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.error_outline,
                    size: 16,
                  ),
                ),
                const TextSpan(text: " "),
                TextSpan(
                  text: "恢复备份将会覆盖红枫云盘的所有数据".tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  _backupToLocal() async {
    String? result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: "请选择备份路径".tr(),
    );
    if (result != null) {
      final name = _generateName();

      final src = await PathUtil.getDatabasePath();
      final dst = filepath.join(result, name);

      doFuture(() {
        return io.File(src).copy(dst).then((_) {
          App.showSnackBar(Text(
            "备份成功，文件名称: {name}".tr(args: {
              "name": name,
            }),
          ));
        });
      });
    }
  }

  _backupToCloud() async {
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
        App.showSnackBar(Text(
          "备份成功，文件名称: {name}".tr(args: {
            "name": name,
          }),
        ));
        ref.invalidate(fileProvider(result));
      });
    }
  }

  _restoreFromLocal() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "请选择备份文件".tr(),
      // type: FileType.custom,
      // allowedExtensions: ["db"],
    );
    if (result != null && result.files.isNotEmpty) {
      final src = result.files.single.path!;
      if (!src.endsWith(".db")) {
        App.showSnackBar(Text("错误的文件类型".tr()));
        return;
      }
      final dst = await PathUtil.getDatabasePath();

      doFuture(() {
        return io.File(src).copy(dst).then((resp) {
          App.showSnackBar(Text("恢复成功，请重启应用".tr()));
        });
      });
    }
  }

  _restoreFromCloud() async {
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
        App.showSnackBar(Text("恢复成功，请重启应用".tr()));
      });
    }
  }

  String _generateName() {
    return "server_${TimeUtil.formatDate(DateTime.now(), 'yyyyMMddHHmmss')}.db";
  }
}

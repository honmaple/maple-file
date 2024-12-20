import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path/path.dart' as filepath;
import 'package:file_picker/file_picker.dart';

import 'package:maple_file/app/app.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/utils/path.dart';

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
        title: Text('备份与恢复'.tr(context)),
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
                title: Text('备份文件'.tr(context)),
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
            child: Text('备份'.tr(context)),
            onPressed: () async {
              String? result = await FilePicker.platform.getDirectoryPath(
                dialogTitle: "请选择备份路径".tr(context),
              );
              if (result != null) {
                final name =
                    "server_${TimeUtil.formatDate(DateTime.now(), 'yyyyMMddHHmmss')}.db";
                doFuture(() async {
                  final src = await PathUtil.getDatabasePath();
                  final dst = filepath.join(result, name);
                  await io.File(src).copy(dst);
                }).then((resp) {
                  if (!resp.hasErr) {
                    Messenger.showSnackBar(Text(
                      "备份成功，文件名称: {name}".tr(context, args: {
                        "name": name,
                      }),
                    ));
                  }
                });
              }
            },
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text('恢复'.tr(context)),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                dialogTitle: "请选择备份文件".tr(context),
                // type: FileType.custom,
                // allowedExtensions: ["db"],
              );
              if (result != null) {
                doFuture(() async {
                  final src = result.files.single.path!;
                  final dst = await PathUtil.getDatabasePath();
                  await io.File(src).copy(dst);
                }).then((resp) {
                  if (!resp.hasErr) {
                    Messenger.showSnackBar(Text("恢复成功，请重启应用".tr(context)));
                  }
                });
              }
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
                  text: "恢复备份将会覆盖红枫云盘的所有数据".tr(context),
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
}

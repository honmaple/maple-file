import 'dart:io' as io;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:macos_secure_bookmarks/macos_secure_bookmarks.dart";

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class Local extends StatefulWidget {
  const Local({super.key, required this.form});

  final Repo form;

  @override
  State<Local> createState() => _LocalState();
}

class _LocalState extends State<Local> {
  late Map<String, dynamic> _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == "" ? {} : jsonDecode(widget.form.option);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Column(
            children: [
              CustomFormField(
                type: CustomFormFieldType.directory,
                label: '目录'.tr(),
                value: _option["path"],
                isRequired: true,
                onTap: (result) {
                  _handlePath(result);
                },
              ),
            ],
          ),
        ),
        if (Util.isAndroid)
          FutureBuilder(
            future: Permission.manageExternalStorage.status,
            builder: (context, snapshot) {
              if (snapshot.hasData && (snapshot.data?.isDenied ?? false)) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      "本地文件的访问需要授权设备的读写权限".tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextButton(
                      child: Text("去设置 >>".tr()),
                      onPressed: () async {
                        await Permission.manageExternalStorage
                            .onDeniedCallback(() {
                          SmartDialog.showNotify(
                            msg: "拒绝权限可能会导致本地存储无法获取到文件信息".tr(),
                            notifyType: NotifyType.warning,
                          );
                        }).request();
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text('自定义目录'.tr()),
            onPressed: () async {
              final result = await showEditingDialog(
                context,
                "自定义目录".tr(),
                value: _option["path"] ?? "",
              );
              if (result != null) {
                _handlePath(result);
              }
            },
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  _handlePath(String path) async {
    _option["path"] = path;
    if (Util.isMacOS) {
      final secureBookmarks = SecureBookmarks();
      _option["bookmark"] = await secureBookmarks.bookmark(
        io.Directory(path),
      );
    }
    setState(() {});

    widget.form.option = jsonEncode(_option);
  }
}

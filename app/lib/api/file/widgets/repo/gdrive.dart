import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class GDrive extends StatefulWidget {
  const GDrive({super.key, required this.form});

  final Repo form;

  @override
  State<GDrive> createState() => _GDriveState();
}

class _GDriveState extends State<GDrive> {
  late Map<String, dynamic> _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == "" ? {} : jsonDecode(widget.form.option);
  }

  void _saveOption() {
    widget.form.option = jsonEncode(_option);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return CustomListSection(
      hasLeading: false,
      dividerMargin: 20,
      children: [
        CustomListTileTextField(
          type: CustomListTileTextFieldType.password,
          label: "访问令牌".tr(),
          value: _option["access_token"],
          onChanged: (result) {
            setState(() {
              _option["access_token"] = result;
            });
            _saveOption();
          },
        ),
        CustomListTileTextField(
          label: "凭证文件".tr(),
          value: _option["credentials_file"],
          subtitle: Text(
            "服务账号或 OAuth 凭证 JSON 文件路径".tr(),
            style: themeData.textTheme.bodySmall,
          ),
          onChanged: (result) {
            setState(() {
              _option["credentials_file"] = result;
            });
            _saveOption();
          },
        ),
        CustomListTileTextField(
          label: "凭证 JSON".tr(),
          value: _option["credentials"],
          subtitle: Text(
            "可直接粘贴压缩后的 JSON 内容".tr(),
            style: themeData.textTheme.bodySmall,
          ),
          onChanged: (result) {
            setState(() {
              _option["credentials"] = result;
            });
            _saveOption();
          },
        ),
        CustomListTileTextField(
          label: "根目录 ID".tr(),
          value: _option["root_id"] ?? "root",
          onChanged: (result) {
            setState(() {
              _option["root_id"] = result;
            });
            _saveOption();
          },
        ),
        CustomListTileTextField(
          label: "共享盘 ID".tr(),
          value: _option["shared_drive_id"],
          onChanged: (result) {
            setState(() {
              _option["shared_drive_id"] = result;
            });
            _saveOption();
          },
        ),
        CustomListTileTextField(
          label: "导出 MIME 类型".tr(),
          value: _option["export_mime_type"],
          subtitle: Text(
            "用于 Google 文档等 Workspace 文件导出".tr(),
            style: themeData.textTheme.bodySmall,
          ),
          onChanged: (result) {
            setState(() {
              _option["export_mime_type"] = result;
            });
            _saveOption();
          },
        ),
        CustomListTileSwitch(
          label: '启用全部云端硬盘'.tr(),
          value: _option["supports_all_drives"] ?? false,
          onChanged: (result) {
            setState(() {
              _option["supports_all_drives"] = result;
            });
            _saveOption();
          },
        ),
      ],
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class OneDrive extends StatefulWidget {
  const OneDrive({super.key, required this.form});

  final Repo form;

  @override
  State<OneDrive> createState() => _OneDriveState();
}

class _OneDriveState extends State<OneDrive> {
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
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["access_token"] = result;
            });
            _saveOption();
          },
        ),
        CustomListTileTextField(
          label: "接口地址".tr(),
          value: _option["endpoint"] ?? "https://graph.microsoft.com/v1.0",
          subtitle: Text(
            "默认使用 Microsoft Graph v1.0".tr(),
            style: themeData.textTheme.bodySmall,
          ),
          onChanged: (result) {
            setState(() {
              _option["endpoint"] = result;
            });
            _saveOption();
          },
        ),
        CustomListTileTextField(
          label: "云盘 ID".tr(),
          value: _option["drive_id"],
          onChanged: (result) {
            setState(() {
              _option["drive_id"] = result;
            });
            _saveOption();
          },
        ),
        CustomListTileTextField(
          label: "用户 ID".tr(),
          value: _option["user_id"],
          onChanged: (result) {
            setState(() {
              _option["user_id"] = result;
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
      ],
    );
  }
}

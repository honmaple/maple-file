import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

enum S3ListVersion {
  v1,
  v2,
}

class S3 extends StatefulWidget {
  const S3({super.key, required this.form});

  final Repo form;

  @override
  State<S3> createState() => _S3State();
}

class _S3State extends State<S3> {
  late Map<String, dynamic> _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == "" ? {} : jsonDecode(widget.form.option);
  }

  @override
  Widget build(BuildContext context) {
    return CustomListSection(
      hasLeading: false,
      dividerMargin: 20,
      children: [
        CustomListTileTextField(
          label: "接入点".tr(),
          value: _option["endpoint"],
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["endpoint"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileTextField(
          label: "存储桶".tr(),
          value: _option["bucket"],
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["bucket"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileTextField(
          label: "访问区域".tr(),
          value: _option["region"],
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["region"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileTextField(
          label: "访问身份".tr(),
          value: _option["access_key"],
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["access_key"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileTextField(
          type: CustomListTileTextFieldType.password,
          label: "访问密钥".tr(),
          value: _option["secret_key"],
          onChanged: (result) {
            setState(() {
              _option["secret_key"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileTextField(
          type: CustomListTileTextFieldType.password,
          label: "会话令牌".tr(),
          value: _option["session_token"],
          onChanged: (result) {
            setState(() {
              _option["session_token"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileSwitch(
          label: '强制路径样式'.tr(),
          value: _option["force_path_style"] ?? false,
          onChanged: (result) {
            setState(() {
              _option["force_path_style"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileOptions(
          label: "访问版本".tr(),
          value: _option["list_version"] ?? "v1",
          subtitle: Text(
            "访问当前对象存储文件列表的版本",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          options: S3ListVersion.values.map((v) {
            return CustomOption(
              label: v.name.toUpperCase(),
              value: v.name,
            );
          }).toList(),
          onTap: (result) {
            setState(() {
              _option["list_version"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
      ],
    );
  }
}

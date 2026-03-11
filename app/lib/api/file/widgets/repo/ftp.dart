import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class FTP extends StatefulWidget {
  const FTP({super.key, required this.form});

  final Repo form;

  @override
  State<FTP> createState() => _FTPState();
}

class _FTPState extends State<FTP> {
  late Map<String, dynamic> _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == ""
        ? {"port": 21}
        : jsonDecode(widget.form.option);
  }

  @override
  Widget build(BuildContext context) {
    return CustomListSection(
      hasLeading: false,
      dividerMargin: 20,
      children: [
        CustomListTileTextField(
          label: "主机/IP".tr(),
          value: _option["host"],
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["host"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileTextField(
          type: CustomListTileTextFieldType.number,
          label: "端口".tr(),
          value: "${_option['port'] ?? 21}",
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["port"] = int.parse(result);
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileTextField(
          label: "用户".tr(),
          value: _option["username"],
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["username"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileTextField(
          type: CustomListTileTextFieldType.password,
          label: "密码".tr(),
          value: _option["password"],
          onChanged: (result) {
            setState(() {
              _option["password"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
      ],
    );
  }
}

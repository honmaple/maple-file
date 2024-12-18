import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import 'form.dart';

class SMB extends StatefulWidget {
  const SMB({super.key, required this.form});

  final Repo form;

  @override
  State<SMB> createState() => _SMBState();
}

class _SMBState extends State<SMB> {
  late Map<String, dynamic> _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == ""
        ? {"port": 445}
        : jsonDecode(widget.form.option);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          DriverFormField(
            label: "主机/IP".tr(context),
            value: _option["host"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["host"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          DriverFormField(
            type: DriverFormFieldType.number,
            label: "端口".tr(context),
            value: "${_option['port'] ?? 445}",
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["port"] = int.parse(result);
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          DriverFormField(
            label: "用户".tr(context),
            value: _option["username"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["username"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          DriverFormField(
            type: DriverFormFieldType.password,
            label: "密码".tr(context),
            value: _option["password"],
            onTap: (result) {
              setState(() {
                _option["password"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          DriverFormField(
            label: "共享名称".tr(context),
            value: _option["share_name"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["share_name"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          DriverFormField(
            label: "根目录".tr(context),
            value: _option["root_path"],
            onTap: (result) {
              setState(() {
                _option["root_path"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
        ],
      ),
    );
  }
}

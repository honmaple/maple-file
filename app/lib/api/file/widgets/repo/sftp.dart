import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class SFTP extends StatefulWidget {
  const SFTP({super.key, required this.form});

  final Repo form;

  @override
  State<SFTP> createState() => _SFTPState();
}

class _SFTPState extends State<SFTP> {
  late Map<String, dynamic> _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == ""
        ? {"port": 22}
        : jsonDecode(widget.form.option);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CustomFormField(
            label: "主机/IP".tr(),
            value: _option["host"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["host"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            type: CustomFormFieldType.number,
            label: "端口".tr(),
            value: "${_option['port'] ?? 22}",
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["port"] = int.parse(result);
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: "用户".tr(),
            value: _option["username"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["username"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            type: CustomFormFieldType.password,
            label: "密码".tr(),
            value: _option["password"],
            onTap: (result) {
              setState(() {
                _option["password"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            type: CustomFormFieldType.password,
            label: "私钥".tr(),
            value: _option["private_key"],
            onTap: (result) {
              setState(() {
                _option["private_key"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: "根目录".tr(),
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

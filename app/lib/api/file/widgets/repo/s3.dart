import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import 'form.dart';

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

    _option = widget.form.option == ""
        ? {"port": 22}
        : jsonDecode(widget.form.option);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          DriverFormField(
            label: "主机/IP".tr(context),
            value: _option["endpoint"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["endpoint"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          DriverFormField(
            label: "存储桶".tr(context),
            value: _option["bucket"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["bucket"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          DriverFormField(
            label: "访问区域".tr(context),
            value: _option["region"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["region"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          DriverFormField(
            label: "访问key".tr(context),
            value: _option["access_key"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["access_key"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          DriverFormField(
            type: DriverFormFieldType.password,
            label: "访问密钥".tr(context),
            value: _option["secret_key"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["secret_key"] = result;
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

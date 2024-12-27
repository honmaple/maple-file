import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class Alist extends StatefulWidget {
  const Alist({super.key, required this.form});

  final Repo form;

  @override
  State<Alist> createState() => _AlistState();
}

class _AlistState extends State<Alist> {
  late Map<String, dynamic> _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == "" ? {} : jsonDecode(widget.form.option);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CustomFormField(
            label: "接入点".tr(),
            value: _option["endpoint"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["endpoint"] = result;
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
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["password"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
        ],
      ),
    );
  }
}

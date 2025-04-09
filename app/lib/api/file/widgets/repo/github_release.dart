import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class GithubRelease extends StatefulWidget {
  const GithubRelease({super.key, required this.form});

  final Repo form;

  @override
  State<GithubRelease> createState() => _GithubReleaseState();
}

class _GithubReleaseState extends State<GithubRelease> {
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
            label: "所属者".tr(),
            value: _option["owner"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["owner"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: "仓库名称".tr(),
            value: _option["repo"],
            onTap: (result) {
              setState(() {
                _option["repo"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: "版本名称".tr(),
            value: _option["release"],
            onTap: (result) {
              setState(() {
                _option["release"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            type: CustomFormFieldType.password,
            label: "访问密钥".tr(),
            value: _option["token"],
            onTap: (result) {
              setState(() {
                _option["token"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
        ],
      ),
    );
  }
}

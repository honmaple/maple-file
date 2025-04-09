import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class Github extends StatefulWidget {
  const Github({super.key, required this.form});

  final Repo form;

  @override
  State<Github> createState() => _GithubState();
}

class _GithubState extends State<Github> {
  late Map<String, dynamic> _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == "" ? {} : jsonDecode(widget.form.option);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
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
            label: "分支名称".tr(),
            value: _option["ref"],
            subtitle: Text(
              "分支、标签或者提交Sha".tr(),
              style: themeData.textTheme.bodySmall,
            ),
            onTap: (result) {
              setState(() {
                _option["ref"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          ListTile(
            title: Text('显示全部分支'.tr()),
            trailing: Switch(
              value: _option["show_branch"] ?? false,
              onChanged: (result) {
                setState(() {
                  _option["show_branch"] = result;
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
          ),
          ListTile(
            title: Text('显示全部标签'.tr()),
            trailing: Switch(
              value: _option["show_tag"] ?? false,
              onChanged: (result) {
                setState(() {
                  _option["show_tag"] = result;
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
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

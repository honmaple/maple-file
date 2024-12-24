import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class Mirror extends StatefulWidget {
  const Mirror({super.key, required this.form});

  final Repo form;

  @override
  State<Mirror> createState() => _MirrorState();
}

class _MirrorState extends State<Mirror> {
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
            label: "源站".tr(),
            value: _option["endpoint"],
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option["endpoint"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          ListTile(
            title: Text('源站格式'.tr()),
            trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(_option["format"] ?? "未选择".tr()),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () async {
              final result = await showListDialog(context, items: [
                ListDialogItem(value: "nginx"),
                ListDialogItem(value: "tuna"),
                ListDialogItem(value: "aliyun"),
              ]);
              if (result != null) {
                setState(() {
                  _option["format"] = result;
                });
                widget.form.option = jsonEncode(_option);
              }
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

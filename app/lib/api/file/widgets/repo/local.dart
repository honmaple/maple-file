import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class Local extends StatefulWidget {
  const Local({super.key, required this.form});

  final Repo form;

  @override
  State<Local> createState() => _LocalState();
}

class _LocalState extends State<Local> {
  late Map<String, dynamic> _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == ""
        ? {"dir_perm": 0755}
        : jsonDecode(widget.form.option);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text('目录'.tr(context)),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      _option["root_path"] ?? "未设置".tr(context),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Text(' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
                onTap: () async {
                  String? result = await FilePicker.platform.getDirectoryPath();
                  if (result != null) {
                    setState(() {
                      _option["root_path"] = result;
                    });

                    widget.form.option = jsonEncode(_option);
                  }
                },
              ),
              ListTile(
                title: Text("目录权限".tr(context)),
                trailing: Text("${_option['dir_perm'] ?? 0755}"),
                onTap: () async {
                  final result = await showNumberEditingDialog(
                    context,
                    "目录权限".tr(context),
                    value: "${_option['dir_perm'] ?? 0755}",
                  );
                  if (result != null) {
                    setState(() {
                      _option["dir_perm"] = int.parse(result);
                    });

                    widget.form.option = jsonEncode(_option);
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text('自定义目录'.tr(context)),
            onPressed: () async {
              final result = await showEditingDialog(
                context,
                "自定义目录".tr(context),
                value: _option["root_path"] ?? "",
              );
              if (result != null) {
                setState(() {
                  _option["root_path"] = result;
                });

                widget.form.option = jsonEncode(_option);
              }
            },
          ),
        ),
      ],
    );
  }
}

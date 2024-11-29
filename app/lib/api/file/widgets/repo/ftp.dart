import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/dialog.dart';
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
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("主机/IP".tr(context)),
            trailing: _emptyText(
              context,
              _option["host"],
              isRequired: true,
            ),
            onTap: () async {
              final result = await showEditingDialog(
                context,
                "主机/IP".tr(context),
                value: _option["host"] ?? "",
              );
              if (result != null) {
                setState(() {
                  _option["host"] = result;
                });

                widget.form.option = jsonEncode(_option);
              }
            },
          ),
          ListTile(
            title: Text("端口".tr(context)),
            trailing: Text("${_option['port'] ?? 21}"),
            onTap: () async {
              final result = await showNumberEditingDialog(
                context,
                "端口".tr(context),
                value: "${_option['port'] ?? 21}",
              );
              if (result != null) {
                setState(() {
                  _option["port"] = int.parse(result);
                });

                widget.form.option = jsonEncode(_option);
              }
            },
          ),
          ListTile(
            title: Text("用户".tr(context)),
            trailing: _emptyText(
              context,
              _option["username"],
              isRequired: true,
            ),
            onTap: () async {
              final result = await showEditingDialog(
                context,
                "用户".tr(context),
                value: _option["username"] ?? "",
              );
              if (result != null) {
                setState(() {
                  _option["username"] = result;
                });

                widget.form.option = jsonEncode(_option);
              }
            },
          ),
          ListTile(
            title: Text("密码".tr(context)),
            trailing: _option["password"] == null
                ? Text("未设置".tr(context))
                : const Icon(Icons.more_horiz),
            onTap: () async {
              final result = await showEditingDialog(
                context,
                "密码".tr(context),
                value: _option["password"] ?? "",
                obscureText: true,
              );
              if (result != null) {
                setState(() {
                  _option["password"] = result;
                });

                widget.form.option = jsonEncode(_option);
              }
            },
          ),
          ListTile(
            title: Text("根目录".tr(context)),
            trailing: _emptyText(context, _option["root_path"]),
            onTap: () async {
              final result = await showEditingDialog(
                context,
                "根目录".tr(context),
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
        ],
      ),
    );
  }

  Widget _emptyText(
    BuildContext context,
    String? value, {
    bool isRequired = false,
  }) {
    bool isEmpty = value == null || value == "";
    return Wrap(
      children: [
        Text(isEmpty ? "未设置".tr(context) : value),
        if (isRequired && isEmpty)
          const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}

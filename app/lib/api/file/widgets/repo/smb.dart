import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

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
          ListTile(
            title: Text("主机/IP".tr(context)),
            trailing: Wrap(
              children: [
                Text(_option["host"] ?? "未设置".tr(context)),
                const Text(' *', style: TextStyle(color: Colors.red)),
              ],
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
            trailing: Text("${_option['port'] ?? 22}"),
            onTap: () async {
              final result = await showNumberEditingDialog(
                context,
                "端口".tr(context),
                value: "${_option['port'] ?? 22}",
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
            trailing: Wrap(
              children: [
                Text(_option["username"] ?? "未设置".tr(context)),
                const Text(' *', style: TextStyle(color: Colors.red)),
              ],
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
            trailing: Wrap(
              children: [
                _option["password"] == null
                    ? Text("未设置".tr(context))
                    : const Icon(Icons.more_horiz),
                const Text(' *', style: TextStyle(color: Colors.red)),
              ],
            ),
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
            trailing: _option["root_path"] == null
                ? Text("未设置".tr(context))
                : const Icon(Icons.more_horiz),
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
}

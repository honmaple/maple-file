import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

enum CompressLevel {
  normal,
  best,
  fast,
}

extension CompressLevelExtension on CompressLevel {
  String label() {
    final Map<CompressLevel, String> labels = {
      CompressLevel.normal: "默认".tr(),
      CompressLevel.best: "压缩率最高".tr(),
      CompressLevel.fast: "压缩速度最快".tr(),
    };
    return labels[this] ?? "unknown";
  }
}

class BaseForm extends StatefulWidget {
  const BaseForm({super.key, required this.form});

  final Repo form;

  @override
  State<BaseForm> createState() => _BaseFormState();
}

class _BaseFormState extends State<BaseForm> {
  late Map<String, dynamic> _option;
  late Map<String, dynamic> _recycleOption;
  late Map<String, dynamic> _encryptOption;
  late Map<String, dynamic> _compressOption;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == "" ? {} : jsonDecode(widget.form.option);
    _recycleOption = _option["recycle_option"] ?? {};
    _encryptOption = _option["encrypt_option"] ?? {};
    _compressOption = _option["compress_option"] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
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
          FileTypeFormField(
            label: '隐藏文件'.tr(),
            value: List<String>.from(_option["hidden_files"] ?? <String>[]),
            onTap: (result) {
              setState(() {
                _option["hidden_files"] = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          ListTile(
            title: Text('回收站'.tr()),
            subtitle: Text("是否激活回收站".tr()),
            trailing: Switch(
              value: _option["recycle"] ?? false,
              onChanged: (result) {
                setState(() {
                  _option["recycle"] = result;
                  if (!result) {
                    _recycleOption = {};
                    _option.remove("recycle");
                    _option.remove("recycle_option");
                  }
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
          ),
          if (_option["recycle"] ?? false)
            CustomFormField(
              label: "回收站路径".tr(),
              value: _recycleOption["path"],
              subtitle: Text("未设置时将在根目录创建.maplerecycle".tr()),
              onTap: (result) {
                setState(() {
                  _recycleOption["path"] = result;
                  _option["recycle_option"] = _recycleOption;
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
          ListTile(
            title: Text('文件加密'.tr()),
            trailing: Switch(
              value: _option["encrypt"] ?? false,
              onChanged: (result) {
                setState(() {
                  _option["encrypt"] = result;
                  if (!result) {
                    _encryptOption = {};
                    _option.remove("encrypt");
                    _option.remove("encrypt_option");
                  }
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
          ),
          if (_option["encrypt"] ?? false)
            CustomFormField(
              type: CustomFormFieldType.password,
              label: "文件密码".tr(),
              value: _encryptOption["password"],
              isRequired: true,
              onTap: (result) {
                setState(() {
                  _encryptOption["password"] = result;
                  _option["encrypt_option"] = _encryptOption;
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
          if (_option["encrypt"] ?? false)
            CustomFormField(
              label: "文件后缀".tr(),
              value: _encryptOption["suffix"],
              onTap: (result) {
                setState(() {
                  _encryptOption["suffix"] = result;
                  _option["encrypt_option"] = _encryptOption;
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
          if (_option["encrypt"] ?? false)
            ListTile(
              title: Text('目录名称加密'.tr()),
              trailing: Switch(
                value: _encryptOption["dir_name"] ?? false,
                onChanged: (result) {
                  setState(() {
                    _encryptOption["dir_name"] = result;
                    _option["encrypt_option"] = _encryptOption;
                  });

                  widget.form.option = jsonEncode(_option);
                },
              ),
            ),
          if (_option["encrypt"] ?? false)
            ListTile(
              title: Text('文件名称加密'.tr()),
              trailing: Switch(
                value: _encryptOption["file_name"] ?? false,
                onChanged: (result) {
                  setState(() {
                    _encryptOption["file_name"] = result;
                    _option["encrypt_option"] = _encryptOption;
                  });

                  widget.form.option = jsonEncode(_option);
                },
              ),
            ),
          ListTile(
            title: Text('文件压缩'.tr()),
            trailing: Switch(
              value: _option["compress"] ?? false,
              onChanged: (result) {
                setState(() {
                  _option["compress"] = result;
                  if (!result) {
                    _compressOption = {};
                    _option.remove("compress");
                    _option.remove("compress_option");
                  }
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
          ),
          if (_option["compress"] ?? false)
            CustomFormField(
              label: "压缩水平".tr(),
              value: _compressOption["level"],
              type: CustomFormFieldType.option,
              options: CompressLevel.values.map((v) {
                return CustomFormFieldOption(label: v.label(), value: v.name);
              }).toList(),
              isRequired: true,
              onTap: (result) {
                setState(() {
                  switch (result) {
                    case "fast":
                      _compressOption["level"] = 1;
                    case "best":
                      _compressOption["level"] = 9;
                    default:
                      _compressOption["level"] = -1;
                  }
                  _option["compress_option"] = _compressOption;
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
        ],
      ),
    );
  }
}

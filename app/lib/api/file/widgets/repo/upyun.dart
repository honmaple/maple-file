import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

part 'upyun.g.dart';
part 'upyun.freezed.dart';

@unfreezed
class UpyunOption with _$UpyunOption {
  factory UpyunOption({
    @Default("") String endpoint,
    @Default("") String bucket,
    @Default("") String operator,
    @Default("") String password,
    @Default("") @JsonKey(name: 'root_path') String rootPath,
  }) = _UpyunOption;

  factory UpyunOption.fromJson(Map<String, Object?> json) =>
      _$UpyunOptionFromJson(json);
}

class Upyun extends StatefulWidget {
  const Upyun({super.key, required this.form});

  final Repo form;

  @override
  State<Upyun> createState() => _UpyunState();
}

class _UpyunState extends State<Upyun> {
  late UpyunOption _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == ""
        ? UpyunOption()
        : UpyunOption.fromJson(jsonDecode(widget.form.option));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CustomFormField(
            label: "存储桶".tr(),
            value: _option.bucket,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.bucket = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: "操作员".tr(),
            value: _option.operator,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.operator = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            type: CustomFormFieldType.password,
            label: "操作密码".tr(),
            value: _option.password,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.password = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: "根目录".tr(),
            value: _option.rootPath,
            onTap: (result) {
              setState(() {
                _option.rootPath = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
        ],
      ),
    );
  }
}

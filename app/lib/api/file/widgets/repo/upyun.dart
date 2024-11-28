import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/list_tile.dart';
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
  }) = _UpyunOption;

  factory UpyunOption.fromJson(Map<String, Object?> json) =>
      _$UpyunOptionFromJson(json);
}

class Upyun extends ConsumerStatefulWidget {
  const Upyun({super.key, required this.form});

  final Repo form;

  @override
  ConsumerState<Upyun> createState() => _UpyunState();
}

class _UpyunState extends ConsumerState<Upyun> {
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
          CustomListTile(
            label: "接入点".tr(context),
            value: _option.endpoint,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.endpoint = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomListTile(
            label: "存储桶".tr(context),
            value: _option.bucket,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.bucket = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomListTile(
            label: "操作员".tr(context),
            value: _option.operator,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.operator = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomListTile(
            label: "操作密码".tr(context),
            value: _option.password,
            isRequired: true,
            obscureText: true,
            onTap: (result) {
              setState(() {
                _option.password = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
        ],
      ),
    );
  }
}
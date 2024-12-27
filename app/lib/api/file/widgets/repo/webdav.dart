import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

part 'webdav.g.dart';
part 'webdav.freezed.dart';

@unfreezed
class WebdavOption with _$WebdavOption {
  factory WebdavOption({
    @Default("") String endpoint,
    @Default("") String username,
    @Default("") String password,
  }) = _WebdavOption;

  factory WebdavOption.fromJson(Map<String, Object?> json) =>
      _$WebdavOptionFromJson(json);
}

class Webdav extends StatefulWidget {
  const Webdav({super.key, required this.form});

  final Repo form;

  @override
  State<Webdav> createState() => _WebdavState();
}

class _WebdavState extends State<Webdav> {
  late WebdavOption _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == ""
        ? WebdavOption()
        : WebdavOption.fromJson(jsonDecode(widget.form.option));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CustomFormField(
            label: "域名/IP".tr(),
            value: _option.endpoint,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.endpoint = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: "用户".tr(),
            value: _option.username,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.username = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            type: CustomFormFieldType.password,
            label: "密码".tr(),
            value: _option.password,
            isRequired: true,
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

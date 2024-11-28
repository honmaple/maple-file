import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/common/widgets/list_tile.dart';
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

class Webdav extends ConsumerStatefulWidget {
  const Webdav({super.key, required this.form});

  final Repo form;

  @override
  ConsumerState<Webdav> createState() => _WebdavState();
}

class _WebdavState extends ConsumerState<Webdav> {
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
          CustomListTile(
            label: "域名/IP",
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
            label: "用户名",
            value: _option.username,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.username = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomListTile(
            label: "密码",
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
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform.dart';
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
    return CustomListSection(
      hasLeading: false,
      dividerMargin: 20,
      children: [
        CustomListTileTextField(
          label: "源站".tr(),
          value: _option["endpoint"],
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["endpoint"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
        CustomListTileOptions(
          label: '源站格式'.tr(),
          options: [
            CustomOption(label: "nginx", value: "nginx"),
            CustomOption(label: "tuna", value: "tuna"),
            CustomOption(label: "aliyun", value: "aliyun"),
          ],
          onTap: (result) async {
            setState(() {
              _option["format"] = result;
            });
            widget.form.option = jsonEncode(_option);
          },
        ),
      ],
    );
  }
}

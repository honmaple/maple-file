import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

class Quark extends StatefulWidget {
  const Quark({super.key, required this.form});

  final Repo form;

  @override
  State<Quark> createState() => _QuarkState();
}

class _QuarkState extends State<Quark> {
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
          label: "Cookie",
          value: _option["cookie"],
          isRequired: true,
          onChanged: (result) {
            setState(() {
              _option["cookie"] = result;
            });

            widget.form.option = jsonEncode(_option);
          },
        ),
      ],
    );
  }
}

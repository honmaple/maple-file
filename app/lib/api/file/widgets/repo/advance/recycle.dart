import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';

part 'recycle.g.dart';
part 'recycle.freezed.dart';

@unfreezed
class RecycleOption with _$RecycleOption {
  factory RecycleOption({
    @Default("") String path,
  }) = _RecycleOption;

  factory RecycleOption.fromJson(Map<String, Object?> json) =>
      _$RecycleOptionFromJson(json);
}

class RecycleForm extends StatefulWidget {
  const RecycleForm({
    super.key,
    this.option,
    this.enabled = false,
    required this.onEnabled,
    required this.onChanged,
  });

  final bool enabled;
  final RecycleOption? option;
  final Function(bool) onEnabled;
  final Function(RecycleOption) onChanged;

  @override
  State<RecycleForm> createState() => _RecycleFormState();
}

class _RecycleFormState extends State<RecycleForm> {
  late bool _enabled;
  late RecycleOption _option;

  @override
  void initState() {
    super.initState();

    _option = widget.option ?? RecycleOption();
    _enabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return CustomListSection(
      hasLeading: false,
      dividerMargin: 20,
      children: [
        CustomListTileSwitch(
          label: '回收站'.tr(),
          subtitle: Text(
            "是否激活回收站".tr(),
            style: themeData.textTheme.bodySmall,
          ),
          value: _enabled,
          onChanged: (result) {
            setState(() {
              _enabled = result;
            });

            widget.onEnabled(result);
          },
        ),
        if (_enabled)
          CustomListTileTextField(
            label: "回收站路径".tr(),
            value: _option.path,
            subtitle: Text(
              "未设置时将在根目录创建.maplerecycle".tr(),
              style: themeData.textTheme.bodySmall,
            ),
            onChanged: (result) {
              setState(() {
                _option.path = result;
              });

              widget.onChanged(_option);
            },
          ),
      ],
    );
  }
}

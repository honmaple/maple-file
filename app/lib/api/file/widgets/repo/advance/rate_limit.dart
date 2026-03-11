import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';

part 'rate_limit.g.dart';
part 'rate_limit.freezed.dart';

@unfreezed
class RateLimitOption with _$RateLimitOption {
  factory RateLimitOption({
    @Default(false) bool wait,
    @Default(100) int burst,
    @Default(1) int limit,
  }) = _RateLimitOption;

  factory RateLimitOption.fromJson(Map<String, Object?> json) =>
      _$RateLimitOptionFromJson(json);
}

class RateLimitForm extends StatefulWidget {
  const RateLimitForm({
    super.key,
    this.option,
    this.enabled = false,
    required this.onEnabled,
    required this.onChanged,
  });

  final bool enabled;
  final RateLimitOption? option;
  final Function(bool) onEnabled;
  final Function(RateLimitOption) onChanged;

  @override
  State<RateLimitForm> createState() => _RateLimitFormState();
}

class _RateLimitFormState extends State<RateLimitForm> {
  late bool _enabled;
  late RateLimitOption _option;

  @override
  void initState() {
    super.initState();

    _option = widget.option ?? RateLimitOption();
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
          label: '访问频率'.tr(),
          value: _enabled,
          subtitle: Text(
            "访问次数/单位时间".tr(),
            style: themeData.textTheme.bodySmall,
          ),
          onChanged: (result) {
            setState(() {
              _enabled = result;
            });

            widget.onEnabled(result);
          },
        ),
        if (_enabled)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomListTileTextField(
                type: CustomListTileTextFieldType.number,
                label: "次数限制".tr(),
                value: "${_option.burst}",
                onChanged: (result) {
                  setState(() {
                    _option.burst = int.parse(result);
                  });

                  widget.onChanged(_option);
                },
              ),
              CustomListTileTextField(
                type: CustomListTileTextFieldType.number,
                label: "时间限制".tr(),
                value: "${_option.limit}",
                subtitle: Text(
                  "单位：秒".tr(),
                  style: themeData.textTheme.bodySmall,
                ),
                onChanged: (result) {
                  setState(() {
                    _option.limit = int.parse(result);
                  });

                  widget.onChanged(_option);
                },
              ),
              CustomListTileSwitch(
                label: '是否等待'.tr(),
                value: _option.wait,
                subtitle: Text(
                  "为否时将立即返回错误".tr(),
                  style: themeData.textTheme.bodySmall,
                ),
                onChanged: (result) {
                  setState(() {
                    _option.wait = result;
                  });

                  widget.onChanged(_option);
                },
              ),
            ],
          ),
      ],
    );
  }
}

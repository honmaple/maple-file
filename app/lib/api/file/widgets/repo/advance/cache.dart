import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';

part 'cache.g.dart';
part 'cache.freezed.dart';

@unfreezed
class CacheOption with _$CacheOption {
  factory CacheOption({
    @JsonKey(name: "expire_time") @Default(60) int expireTime,
  }) = _CacheOption;

  factory CacheOption.fromJson(Map<String, Object?> json) =>
      _$CacheOptionFromJson(json);
}

class CacheForm extends StatefulWidget {
  const CacheForm({
    super.key,
    this.option,
    this.enabled = false,
    required this.onEnabled,
    required this.onChanged,
  });

  final bool enabled;
  final CacheOption? option;
  final Function(bool) onEnabled;
  final Function(CacheOption) onChanged;

  @override
  State<CacheForm> createState() => _CacheFormState();
}

class _CacheFormState extends State<CacheForm> {
  late bool _enabled;
  late CacheOption _option;

  @override
  void initState() {
    super.initState();

    _option = widget.option ?? CacheOption();
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
          label: '文件缓存'.tr(),
          value: _enabled,
          subtitle: Text(
            "缓存文件列表信息".tr(),
            style: themeData.textTheme.bodySmall,
          ),
          onChanged: (result) {
            setState(() {
              _enabled = result;
            });

            widget.onEnabled(_enabled);
          },
        ),
        if (_enabled)
          CustomListTileTextField(
            type: CustomListTileTextFieldType.number,
            label: "缓存时间".tr(),
            value: "${_option.expireTime}",
            subtitle: Text(
              "默认60秒后自动清除缓存(单位：秒)".tr(),
              style: themeData.textTheme.bodySmall,
            ),
            onChanged: (result) {
              setState(() {
                _option.expireTime = int.parse(result);
              });

              widget.onChanged(_option);
            },
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform.dart';

part 'compress.g.dart';
part 'compress.freezed.dart';

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

  int value() {
    final Map<CompressLevel, int> values = {
      CompressLevel.normal: -1,
      CompressLevel.best: 9,
      CompressLevel.fast: 1,
    };
    return values[this] ?? -1;
  }
}

@unfreezed
class CompressOption with _$CompressOption {
  factory CompressOption({
    @Default(-1) int level,
  }) = _CompressOption;

  factory CompressOption.fromJson(Map<String, Object?> json) =>
      _$CompressOptionFromJson(json);
}

class CompressForm extends StatefulWidget {
  const CompressForm({
    super.key,
    this.option,
    this.enabled = false,
    required this.onEnabled,
    required this.onChanged,
  });

  final bool enabled;
  final CompressOption? option;
  final Function(bool) onEnabled;
  final Function(CompressOption) onChanged;

  @override
  State<CompressForm> createState() => _CompressFormState();
}

class _CompressFormState extends State<CompressForm> {
  late bool _enabled;
  late CompressOption _option;

  @override
  void initState() {
    super.initState();

    _option = widget.option ?? CompressOption();
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
          label: '文件压缩'.tr(),
          value: _enabled,
          subtitle: Text(
            "文件压缩创建后不可更改压缩配置".tr(),
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
          CustomListTileOptions(
            label: "压缩水平".tr(),
            value: _compressValue(_option.level),
            options: CompressLevel.values.map((v) {
              return CustomOption(label: v.label(), value: v.name);
            }).toList(),
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.level = CompressLevel.values.byName(result).value();
              });

              widget.onChanged(_option);
            },
          ),
      ],
    );
  }

  String? _compressValue(int? value) {
    if (value == null) {
      return null;
    }
    if (value == 1) {
      return CompressLevel.fast.name;
    }
    if (value == 9) {
      return CompressLevel.best.name;
    }
    return CompressLevel.normal.name;
  }
}

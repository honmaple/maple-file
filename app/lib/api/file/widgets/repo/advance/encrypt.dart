import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform.dart';

part 'encrypt.g.dart';
part 'encrypt.freezed.dart';

@unfreezed
class EncryptOption with _$EncryptOption {
  factory EncryptOption({
    @Default("CFB") String mode,
    @Default("v1") String version,
    @Default("") String suffix,
    @Default("") String password,
    @Default("") String passwordSalt,
    @JsonKey(name: "dir_name") @Default(false) bool dirName,
    @JsonKey(name: "file_name") @Default(false) bool fileName,
  }) = _EncryptOption;

  factory EncryptOption.fromJson(Map<String, Object?> json) =>
      _$EncryptOptionFromJson(json);
}

class EncryptForm extends StatefulWidget {
  const EncryptForm({
    super.key,
    this.option,
    this.enabled = false,
    required this.onEnabled,
    required this.onChanged,
  });

  final bool enabled;
  final EncryptOption? option;
  final Function(bool) onEnabled;
  final Function(EncryptOption) onChanged;

  @override
  State<EncryptForm> createState() => _EncryptFormState();
}

class _EncryptFormState extends State<EncryptForm> {
  late bool _enabled;
  late EncryptOption _option;

  @override
  void initState() {
    super.initState();

    _option = widget.option ?? EncryptOption();
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
          label: '文件加密'.tr(),
          subtitle: Text(
            "文件加密创建后不可更改加密配置".tr(),
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
            type: CustomListTileTextFieldType.password,
            label: "文件密码".tr(),
            value: _option.password,
            isRequired: true,
            onChanged: (result) {
              setState(() {
                _option.password = result;
              });

              widget.onChanged(_option);
            },
          ),
        if (_enabled)
          CustomListTileTextField(
            type: CustomListTileTextFieldType.password,
            label: "文件密码加密".tr(),
            value: _option.passwordSalt,
            subtitle: Text(
              "类似二次密码".tr(),
              style: themeData.textTheme.bodySmall,
            ),
            onChanged: (result) {
              setState(() {
                _option.passwordSalt = result;
              });

              widget.onChanged(_option);
            },
          ),
        if (_enabled)
          CustomListTileTextField(
            label: "文件后缀".tr(),
            value: _option.suffix,
            onChanged: (result) {
              setState(() {
                _option.suffix = result;
              });

              widget.onChanged(_option);
            },
          ),
        if (_enabled)
          CustomListTileSwitch(
            label: '目录名称加密'.tr(),
            value: _option.dirName,
            onChanged: (result) {
              setState(() {
                _option.dirName = result;
              });

              widget.onChanged(_option);
            },
          ),
        if (_enabled)
          CustomListTileSwitch(
            label: '文件名称加密'.tr(),
            value: _option.fileName,
            onChanged: (result) {
              setState(() {
                _option.fileName = result;
              });

              widget.onChanged(_option);
            },
          ),
        if (_enabled)
          CustomListTileOptions(
            label: "加密模式".tr(),
            value: _option.mode,
            options: [
              CustomOption(
                label: "密码反馈模式".tr(),
                value: "CFB",
              ),
              CustomOption(
                label: "输出反馈模式".tr(),
                value: "OFB",
              ),
              CustomOption(
                label: "计数器模式".tr(),
                value: "CTR",
              ),
            ],
            onTap: (result) {
              setState(() {
                _option.mode = result;
              });

              widget.onChanged(_option);
            },
          ),
        if (_enabled)
          CustomListTileOptions(
            label: "加密版本".tr(),
            value: _option.version,
            options: [
              CustomOption(
                label: "v1",
                value: "v1",
              ),
              CustomOption(
                label: "v2",
                value: "v2",
              ),
            ],
            onTap: (result) {
              setState(() {
                _option.version = result;
              });

              widget.onChanged(_option);
            },
          ),
      ],
    );
  }
}

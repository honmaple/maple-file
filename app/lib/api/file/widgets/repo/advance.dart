import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import 'advance/cache.dart';
import 'advance/recycle.dart';
import 'advance/encrypt.dart';
import 'advance/compress.dart';
import 'advance/rate_limit.dart';

part 'advance.g.dart';
part 'advance.freezed.dart';

@unfreezed
class AdvanceOption with _$AdvanceOption {
  factory AdvanceOption({
    @JsonKey(name: 'root_path') @Default("") String rootPath,
    @JsonKey(name: 'hidden_files') @Default([]) List<String> hiddenFiles,
    @Default(false) bool cache,
    @JsonKey(name: 'cache_option') CacheOption? cacheOption,
    @Default(false) bool recycle,
    @JsonKey(name: 'recycle_option') RecycleOption? recycleOption,
    @Default(false) bool encrypt,
    @JsonKey(name: 'encrypt_option') EncryptOption? encryptOption,
    @Default(false) bool compress,
    @JsonKey(name: 'compress_option') CompressOption? compressOption,
    @JsonKey(name: 'rate_limit') @Default(false) bool rateLimit,
    @JsonKey(name: 'rate_limit_option') RateLimitOption? rateLimitOption,
  }) = _AdvanceOption;

  factory AdvanceOption.fromJson(Map<String, Object?> json) =>
      _$AdvanceOptionFromJson(json);
}

class AdvanceForm extends StatefulWidget {
  const AdvanceForm({super.key, required this.form});

  final Repo form;

  @override
  State<AdvanceForm> createState() => _AdvanceFormState();
}

class _AdvanceFormState extends State<AdvanceForm> {
  late AdvanceOption _option;

  @override
  void initState() {
    super.initState();

    _option = AdvanceOption.fromJson(
      widget.form.option == "" ? {} : jsonDecode(widget.form.option),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomListSection(
          hasLeading: false,
          dividerMargin: 20,
          children: [
            CustomListTileTextField(
              label: "根目录".tr(),
              value: _option.rootPath,
              validator: (result) {
                if (result == null || result.isEmpty) return null;

                if (!result.startsWith("/")) {
                  return '{}必须以 / 开头'.tr(args: ["根目录".tr()]);
                }
                return null;
              },
              onChanged: (result) {
                setState(() {
                  _option.rootPath = result;
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
            CustomListTileFileTypeField(
              label: '隐藏文件'.tr(),
              value: List<String>.from(_option.hiddenFiles),
              onTap: (result) {
                setState(() {
                  _option.hiddenFiles = result;
                });

                widget.form.option = jsonEncode(_option);
              },
            ),
          ],
        ),
        RecycleForm(
          option: _option.recycleOption,
          enabled: _option.recycle,
          onEnabled: (result) {
            setState(() {
              _option.recycle = result;
              if (!result) {
                _option.recycleOption = null;
              }
            });
          },
          onChanged: (option) {
            setState(() {
              _option.recycleOption = option;
            });
            widget.form.option = jsonEncode(_option);
          },
        ),
        RateLimitForm(
          option: _option.rateLimitOption,
          enabled: _option.rateLimit,
          onEnabled: (result) {
            setState(() {
              _option.rateLimit = result;
              if (!result) {
                _option.rateLimitOption = null;
              }
            });
          },
          onChanged: (option) {
            setState(() {
              _option.rateLimitOption = option;
            });
            widget.form.option = jsonEncode(_option);
          },
        ),
        CacheForm(
          option: _option.cacheOption,
          enabled: _option.cache,
          onEnabled: (result) {
            setState(() {
              _option.cache = result;
              if (!result) {
                _option.cacheOption = null;
              }
            });
          },
          onChanged: (option) {
            setState(() {
              _option.cacheOption = option;
            });
            widget.form.option = jsonEncode(_option);
          },
        ),
        EncryptForm(
          option: _option.encryptOption,
          enabled: _option.encrypt,
          onEnabled: (result) {
            setState(() {
              _option.encrypt = result;
              if (!result) {
                _option.encryptOption = null;
              }
            });
          },
          onChanged: (option) {
            setState(() {
              _option.encryptOption = option;
            });
            widget.form.option = jsonEncode(_option);
          },
        ),
        CompressForm(
          option: _option.compressOption,
          enabled: _option.compress,
          onEnabled: (result) {
            setState(() {
              _option.compress = result;
              if (!result) {
                _option.compressOption = null;
              }
            });
          },
          onChanged: (option) {
            setState(() {
              _option.compressOption = option;
            });
            widget.form.option = jsonEncode(_option);
          },
        ),
      ],
    );
  }
}

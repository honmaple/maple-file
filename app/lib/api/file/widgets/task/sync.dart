import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/generated/proto/api/task/persist.pb.dart';

part 'sync.g.dart';
part 'sync.freezed.dart';

enum SyncMethod {
  a2b,
  b2a,
  b2b,
}

extension SyncMethodExtension on SyncMethod {
  String label() {
    final Map<SyncMethod, String> labels = {
      SyncMethod.a2b: "将源路径的变更同步至目标路径".tr(),
      SyncMethod.b2a: "将目标路径的变更同步至源路径".tr(),
      SyncMethod.b2b: "双向同步".tr(),
    };
    return labels[this] ?? "unknown";
  }
}

enum SyncConflict {
  skip,
  override,
  newest,
}

extension SyncConflictExtension on SyncConflict {
  String label() {
    final Map<SyncConflict, String> labels = {
      SyncConflict.skip: "跳过".tr(),
      SyncConflict.override: "覆盖".tr(),
      SyncConflict.newest: "使用新文件覆盖旧文件".tr(),
    };
    return labels[this] ?? "unknown";
  }
}

@unfreezed
class SyncOption with _$SyncOption {
  factory SyncOption({
    @Default("") @JsonKey(name: 'src_path') String srcPath,
    @Default("") @JsonKey(name: 'dst_path') String dstPath,
    @Default("") @JsonKey(name: 'method') String method,
    @Default("") @JsonKey(name: 'conflict') String conflict,
    @Default(false) @JsonKey(name: 'delete_src') bool deleteSrc,
    @Default(false) @JsonKey(name: 'delete_dst') bool deleteDst,
    @Default("") @JsonKey(name: 'custom_path') String customPath,
    @Default([]) @JsonKey(name: 'file_types') List<String> fileTypes,
  }) = _SyncOption;

  factory SyncOption.fromJson(Map<String, Object?> json) =>
      _$SyncOptionFromJson(json);
}

class Sync extends StatefulWidget {
  const Sync({super.key, required this.form});

  final PersistTask form;

  @override
  State<Sync> createState() => _SyncState();
}

class _SyncState extends State<Sync> {
  late SyncOption _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == ""
        ? SyncOption(
            method: SyncMethod.a2b.name,
            conflict: SyncConflict.skip.name,
          )
        : SyncOption.fromJson(jsonDecode(widget.form.option));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          FolderFormField(
            label: "源路径".tr(),
            value: _option.srcPath,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.srcPath = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          FolderFormField(
            label: "目标路径".tr(),
            value: _option.dstPath,
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.dstPath = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: "同步策略".tr(),
            value: _option.method,
            type: CustomFormFieldType.option,
            options: SyncMethod.values.map((v) {
              return CustomFormFieldOption(label: v.label(), value: v.name);
            }).toList(),
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.method = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          FileTypeFormField(
            label: '文件类型'.tr(),
            value: _option.fileTypes,
            onTap: (result) {
              setState(() {
                _option.fileTypes = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: "文件冲突".tr(),
            value: _option.conflict,
            type: CustomFormFieldType.option,
            options: SyncConflict.values.map((v) {
              return CustomFormFieldOption(label: v.label(), value: v.name);
            }).toList(),
            isRequired: true,
            onTap: (result) {
              setState(() {
                _option.conflict = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          CustomFormField(
            label: '文件整理'.tr(),
            value: _option.customPath,
            type: CustomFormFieldType.path,
            subtitle: Text(
              "将需要备份的文件按照时间格式重新进行分类".tr(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: (result) {
              setState(() {
                _option.customPath = result;
              });

              widget.form.option = jsonEncode(_option);
            },
          ),
          if (_option.method != SyncMethod.b2a.name)
            ListTile(
              title: Text('源文件删除'.tr()),
              subtitle: Text(
                '源路径的文件被删除或不存在时，是否同步删除目标路径的文件'.tr(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Switch(
                value: _option.deleteSrc,
                onChanged: (result) {
                  setState(() {
                    _option.deleteSrc = result;
                  });

                  widget.form.option = jsonEncode(_option);
                },
              ),
            ),
          if (_option.method != SyncMethod.a2b.name)
            ListTile(
              title: Text('目标文件删除'.tr()),
              subtitle: Text('目标路径的文件被删除或不存在时，是否同步删除源路径的文件'.tr()),
              trailing: Switch(
                value: _option.deleteSrc,
                onChanged: (result) {
                  setState(() {
                    _option.deleteSrc = result;
                  });

                  widget.form.option = jsonEncode(_option);
                },
              ),
            ),
        ],
      ),
    );
  }
}

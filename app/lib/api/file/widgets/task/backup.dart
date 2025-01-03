import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/task/persist.pb.dart';

part 'backup.g.dart';
part 'backup.freezed.dart';

enum BackupConflict {
  skip,
  override,
  newest,
}

extension BackupConflictExtension on BackupConflict {
  String label() {
    final Map<BackupConflict, String> labels = {
      BackupConflict.skip: "跳过",
      BackupConflict.override: "覆盖",
      BackupConflict.newest: "使用新文件覆盖旧文件",
    };
    return labels[this] ?? "unknown";
  }
}

@unfreezed
class BackupOption with _$BackupOption {
  factory BackupOption({
    @Default("") @JsonKey(name: 'src_path') String srcPath,
    @Default("") @JsonKey(name: 'dst_path') String dstPath,
    @Default("") @JsonKey(name: 'conflict') String conflict,
    @Default(false) @JsonKey(name: 'delete_src') bool deleteSrc,
    @Default(false) @JsonKey(name: 'delete_dst') bool deleteDst,
    @Default("") @JsonKey(name: 'custom_path') String customPath,
    @Default([]) @JsonKey(name: 'file_types') List<String> fileTypes,
  }) = _BackupOption;

  factory BackupOption.fromJson(Map<String, Object?> json) =>
      _$BackupOptionFromJson(json);
}

class Backup extends StatefulWidget {
  const Backup({super.key, required this.form});

  final PersistTask form;

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  late BackupOption _option;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == ""
        ? BackupOption(
            conflict: BackupConflict.skip.name,
          )
        : BackupOption.fromJson(jsonDecode(widget.form.option));
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
            options: BackupConflict.values.map((v) {
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
          ListTile(
            title: Text('源文件删除'.tr()),
            subtitle: Text('源路径的文件被删除或不存在时，是否同步删除目标路径的文件'.tr()),
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

  Widget _buildFormat() {
    Map<String, String> formats = {
      "文件名": "{filename}",
      "文件扩展": "{extension}",
      "年": "{time:year}",
      "月": "{time:month}",
      "日": "{time:day}",
      "时": "{time:hour}",
      "分": "{time:minute}",
      "秒": "{time:second}",
    };
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final key in formats.keys)
          ActionChip(
            label: Text(key),
            labelStyle: TextStyle(
              fontSize: kDefaultFontSize * 0.875,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              // _controller.text = "${_controller.text}${formats[key]}";
            },
          ),
      ],
    );
  }
}

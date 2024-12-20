import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/task/persist.pb.dart';

import 'form.dart';

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
      SyncMethod.a2b: "将源路径的变更同步至目标路径",
      SyncMethod.b2a: "将目标路径的变更同步至源路径",
      SyncMethod.b2b: "双向同步",
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
      SyncConflict.skip: "跳过",
      SyncConflict.override: "覆盖",
      SyncConflict.newest: "使用新文件覆盖旧文件",
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
            label: "源路径".tr(context),
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
            label: "目标路径".tr(context),
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
            label: "同步策略".tr(context),
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
            },
          ),
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('文件类型'.tr(context)),
                const SizedBox(width: 16),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          _option.fileTypes.isEmpty
                              ? "全部文件".tr(context)
                              : _option.fileTypes.join(","),
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () async {
              final result = await showListDialog2(
                context,
                child: FileTypeFormField(types: _option.fileTypes),
              );
              if (result != null) {
                setState(() {
                  _option.fileTypes = result;
                });
              }
            },
          ),
          CustomFormField(
            label: "文件冲突".tr(context),
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
            },
          ),
          if (_option.method != SyncMethod.b2a.name)
            ListTile(
              title: Text('源文件删除'.tr(context)),
              subtitle: Text('源路径的文件被删除或不存在时，是否同步删除目标路径的文件'.tr(context)),
              trailing: Switch(
                value: _option.deleteSrc,
                onChanged: (result) {
                  setState(() {
                    _option.deleteSrc = result;
                  });
                },
              ),
            ),
          if (_option.method != SyncMethod.a2b.name)
            ListTile(
              title: Text('目标文件删除'.tr(context)),
              subtitle: Text('目标路径的文件被删除或不存在时，是否同步删除源路径的文件'.tr(context)),
              trailing: Switch(
                value: _option.deleteSrc,
                onChanged: (result) {
                  setState(() {
                    _option.deleteSrc = result;
                  });
                },
              ),
            ),
          ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('文件整理'.tr(context)),
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    _option.customPath == "" ? "默认" : _option.customPath,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            onTap: () async {
              final result = await showEditingDialog(
                context,
                "Backup Format".tr(context),
                helper: _buildFormat(),
              );
              if (result != null) {}
            },
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

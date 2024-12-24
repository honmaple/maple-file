import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/api/setting/providers/setting.dart';
import 'package:maple_file/api/setting/providers/setting_appearance.dart';

part 'file_setting.g.dart';
part 'file_setting.freezed.dart';

enum FileListView {
  list,
  grid,
}

extension FileListViewExtension on FileListView {
  String label(BuildContext context) {
    Map<FileListView, String> labels = {
      FileListView.list: "列表模式".tr(),
      FileListView.grid: "宫格模式".tr(),
    };
    return labels[this] ?? "未知".tr();
  }
}

enum FileListSort {
  name,
  type,
  size,
  time,
}

extension FileListSortExtension on FileListSort {
  String label(BuildContext context) {
    Map<FileListSort, String> labels = {
      FileListSort.name: "名称".tr(),
      FileListSort.type: "类型".tr(),
      FileListSort.size: "大小".tr(),
      FileListSort.time: "修改时间".tr(),
    };

    return labels[this] ?? "未知".tr();
  }
}

enum FileListIcon {
  rectangle,
  circle,
}

extension FileListIconExtension on FileListIcon {
  String label(BuildContext context) {
    Map<FileListIcon, String> labels = {
      FileListIcon.rectangle: "默认".tr(),
      FileListIcon.circle: "圆形".tr(),
    };
    return labels[this] ?? "未知".tr();
  }
}

@freezed
class FileSetting with _$FileSetting {
  const FileSetting._();

  const factory FileSetting({
    @Default(false) @JsonKey(name: 'sortReversed') bool sortReversed,
    @Default(FileListSort.name) @JsonKey(name: 'sort') FileListSort sort,
    @Default(FileListView.list) @JsonKey(name: 'view') FileListView view,
    @Default(FileListIcon.rectangle) @JsonKey(name: 'icon') FileListIcon icon,
    @JsonKey(name: 'iconColor') String? iconColor,
    @Default("") @JsonKey(name: 'upload.format') String uploadFormat,
    @Default(false) @JsonKey(name: 'upload.rename') bool uploadRename,
    @Default(0) @JsonKey(name: 'upload.limit_size') int uploadLimitSize,
    @Default("") @JsonKey(name: 'upload.limit_type') String uploadLimitType,
    @Default(32) @JsonKey(name: 'upload.slice_size') int uploadSliceSize,
    @JsonKey(name: 'download.path') String? downloadPath,
    @Default(10) @JsonKey(name: 'download.queue_size') int downloadQueueSize,
    @Default([".*"]) @JsonKey(name: 'hide_files') List<String> hideFiles,
    @Default(0) @JsonKey(name: 'pagination.size') int paginationSize,
  }) = _FileSetting;

  factory FileSetting.fromJson(Map<String, Object?> json) =>
      _$FileSettingFromJson(json);

  Color get color => ThemeModel.themes
      .firstWhere(
        (item) => item.name == iconColor,
        orElse: () => ThemeModel.defaultTheme,
      )
      .color;
}

final fileSettingProvider = newSettingNotifier(
  "app.file",
  const FileSetting(),
  FileSetting.fromJson,
);

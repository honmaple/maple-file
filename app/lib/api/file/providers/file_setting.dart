import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/api/setting/providers/setting.dart';
import 'package:maple_file/api/setting/providers/setting_appearance.dart';

part 'file_setting.g.dart';
part 'file_setting.freezed.dart';

enum FileListView {
  LIST,
  GRID,
}

enum FileListSort {
  NAME,
  TYPE,
  SIZE,
  TIME,
}

enum FileListIcon {
  RECTANGLE,
  CIRCLE,
}

Map<FileListView, String> fileListViewLabel = {
  FileListView.LIST: "列表模式",
  FileListView.GRID: "宫格模式",
};

Map<FileListSort, String> fileListSortLabel = {
  FileListSort.NAME: "名称",
  FileListSort.TYPE: "类型",
  FileListSort.SIZE: "大小",
  FileListSort.TIME: "修改时间",
};

Map<FileListIcon, String> fileListIconLabel = {
  FileListIcon.RECTANGLE: "默认",
  FileListIcon.CIRCLE: "圆形",
};

@freezed
class FileSetting with _$FileSetting {
  const FileSetting._();

  const factory FileSetting({
    @Default(false) @JsonKey(name: 'sortReversed') bool sortReversed,
    @Default(FileListSort.NAME) @JsonKey(name: 'sort') FileListSort sort,
    @Default(FileListView.LIST) @JsonKey(name: 'view') FileListView view,
    @Default(FileListIcon.RECTANGLE) @JsonKey(name: 'icon') FileListIcon icon,
    @JsonKey(name: 'iconColor') String? iconColor,
    @Default("") @JsonKey(name: 'upload.format') String uploadFormat,
    @Default(false) @JsonKey(name: 'upload.rename') bool uploadRename,
    @Default(0) @JsonKey(name: 'upload.limit_size') int uploadLimitSize,
    @Default("") @JsonKey(name: 'upload.limit_type') String uploadLimitType,
    @Default(32) @JsonKey(name: 'upload.slice_size') int uploadSliceSize,
    @JsonKey(name: 'download.path') String? downloadPath,
    @Default(10) @JsonKey(name: 'download.queue_size') int downloadQueueSize,
    @Default([".*"]) @JsonKey(name: 'hide_files') List<String> hideFiles,
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

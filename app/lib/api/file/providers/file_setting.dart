import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/api/setting/providers/setting.dart';
import 'package:maple_file/api/setting/providers/setting_appearance.dart';

part 'file_setting.g.dart';
part 'file_setting.freezed.dart';

enum FileUploadPolicy {
  @JsonValue('preserve')
  preserve,
  @JsonValue('rename')
  rename;

  String get label => switch (this) {
    FileUploadPolicy.preserve => '保留文件名'.tr(),
    FileUploadPolicy.rename => '自动重命名'.tr(),
  };
}

enum FileListView { list, grid }

extension FileListViewExtension on FileListView {
  String get label {
    Map<FileListView, String> labels = {
      FileListView.list: "列表模式".tr(),
      FileListView.grid: "宫格模式".tr(),
    };
    return labels[this] ?? "未知".tr();
  }
}

enum FileListSort { name, type, size, time }

extension FileListSortExtension on FileListSort {
  String get label {
    Map<FileListSort, String> labels = {
      FileListSort.name: "名称".tr(),
      FileListSort.type: "类型".tr(),
      FileListSort.size: "大小".tr(),
      FileListSort.time: "修改时间".tr(),
    };

    return labels[this] ?? "未知".tr();
  }
}

enum FileListIcon { rectangle, circle, thumb }

extension FileListIconExtension on FileListIcon {
  String get label {
    Map<FileListIcon, String> labels = {
      FileListIcon.rectangle: "默认".tr(),
      FileListIcon.circle: "圆形".tr(),
      FileListIcon.thumb: "缩略图".tr(),
    };
    return labels[this] ?? "未知".tr();
  }
}

@freezed
abstract class FileThumbSetting with _$FileThumbSetting {
  const factory FileThumbSetting({@Default(false) bool video}) =
      _FileThumbSetting;

  factory FileThumbSetting.fromJson(Map<String, Object?> json) =>
      _$FileThumbSettingFromJson(json);
}

@freezed
abstract class FileSetting with _$FileSetting {
  const FileSetting._();

  const factory FileSetting({
    @Default(false) @JsonKey(name: 'sortDir') bool sortDir,
    @Default(false) @JsonKey(name: 'sortReversed') bool sortReversed,
    @Default(FileListSort.name) @JsonKey(name: 'sort') FileListSort sort,
    @Default(FileListView.list) @JsonKey(name: 'view') FileListView view,
    @Default(FileListIcon.rectangle) @JsonKey(name: 'icon') FileListIcon icon,
    @Default(FileThumbSetting()) FileThumbSetting thumb,
    @JsonKey(name: 'iconColor') String? iconColor,
    @Default(FileUploadPolicy.preserve)
    @JsonKey(name: 'upload.policy', unknownEnumValue: FileUploadPolicy.preserve)
    FileUploadPolicy uploadPolicy,
    @JsonKey(name: 'download.path') String? downloadPath,
    @Default(10) @JsonKey(name: 'download.queue_size') int downloadQueueSize,
    @Default(0) @JsonKey(name: 'pagination.size') int paginationSize,
  }) = _FileSetting;

  factory FileSetting.fromJson(Map<String, Object?> json) =>
      _$FileSettingFromJson(json);

  FlexScheme get scheme => FlexScheme.values.firstWhere(
    (item) => item.name == iconColor,
    orElse: () => defaultFlexScheme,
  );
}

final fileSettingProvider = newSettingNotifier(
  "app.file",
  const FileSetting(),
  FileSetting.fromJson,
);

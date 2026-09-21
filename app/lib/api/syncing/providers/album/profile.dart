import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

part 'profile.g.dart';
part 'profile.freezed.dart';

enum AlbumTargetLayout {
  @JsonValue('flat')
  flat('flat'),
  @JsonValue('year_month')
  yearMonth('year_month'),
  @JsonValue('year_month_day')
  yearMonthDay('year_month_day');

  const AlbumTargetLayout(this.value);

  final String value;

  String get label => switch (this) {
        AlbumTargetLayout.flat => '平铺整理'.tr(),
        AlbumTargetLayout.yearMonth => '按年月整理'.tr(),
        AlbumTargetLayout.yearMonthDay => '按年月日整理'.tr(),
      };

  static AlbumTargetLayout fromValue(String? value) {
    return AlbumTargetLayout.values.firstWhere(
      (layout) => layout.value == value,
      orElse: () => AlbumTargetLayout.yearMonthDay,
    );
  }
}

@freezed
class AlbumBackupSourceConfig with _$AlbumBackupSourceConfig {
  const factory AlbumBackupSourceConfig({
    @JsonKey(name: 'album_ids') @Default(<String>[]) List<String> albumIds,
  }) = _AlbumBackupSourceConfig;

  factory AlbumBackupSourceConfig.fromJson(Map<String, Object?> json) =>
      _$AlbumBackupSourceConfigFromJson(json);
}

@freezed
class AlbumBackupTargetConfig with _$AlbumBackupTargetConfig {
  const factory AlbumBackupTargetConfig({
    @Default('') String path,
    @Default(AlbumTargetLayout.yearMonthDay) AlbumTargetLayout layout,
    @JsonKey(name: 'append_device_model') @Default(true) bool appendDeviceModel,
  }) = _AlbumBackupTargetConfig;

  factory AlbumBackupTargetConfig.fromJson(Map<String, Object?> json) =>
      _$AlbumBackupTargetConfigFromJson(json);
}

@freezed
class AlbumBackupIssueContext with _$AlbumBackupIssueContext {
  @JsonSerializable(includeIfNull: false)
  const factory AlbumBackupIssueContext({
    @JsonKey(name: 'album_label') String? albumLabel,
    @JsonKey(name: 'local_path') String? localPath,
  }) = _AlbumBackupIssueContext;

  factory AlbumBackupIssueContext.fromJson(Map<String, Object?> json) =>
      _$AlbumBackupIssueContextFromJson(json);
}

class AlbumBackupProfile {
  AlbumBackupProfile._({
    required SyncProfile profile,
    required this.sourceConfig,
    required this.targetConfig,
  }) : _profile = SyncProfile()..mergeFromMessage(profile);

  factory AlbumBackupProfile.create({required String name}) {
    return AlbumBackupProfile._(
      profile: SyncProfile(
        name: name,
        enabled: true,
        mode: SyncProfile_Mode.MODE_BACKUP,
        sourceType: SyncSourceType.album.value,
        sourceConfig: '{}',
        targetType: SyncTargetType.repoDirectory.value,
        targetConfig: '{}',
        policyConfig: '{}',
      ),
      sourceConfig: AlbumBackupSourceConfig(),
      targetConfig: const AlbumBackupTargetConfig(),
    );
  }

  factory AlbumBackupProfile.fromSyncProfile(SyncProfile profile) {
    if (SyncSourceType.fromValue(profile.sourceType) != SyncSourceType.album ||
        profile.mode != SyncProfile_Mode.MODE_BACKUP ||
        SyncTargetType.fromValue(profile.targetType) !=
            SyncTargetType.repoDirectory) {
      throw const FormatException('此同步配置不是相册备份');
    }
    final source = _decodeConfig(profile.sourceConfig, '备份源');
    final target = _decodeConfig(profile.targetConfig, '备份目标');
    return AlbumBackupProfile._(
      profile: profile,
      sourceConfig: AlbumBackupSourceConfig.fromJson(source),
      targetConfig: AlbumBackupTargetConfig.fromJson(target),
    );
  }

  final SyncProfile _profile;
  final AlbumBackupSourceConfig sourceConfig;
  final AlbumBackupTargetConfig targetConfig;

  int get id => _profile.id;
  String get name => _profile.name;
  bool get enabled => _profile.enabled;
  int get configVersion => _profile.configVersion.toInt();

  AlbumBackupProfile copyWith({
    String? name,
    bool? enabled,
    AlbumBackupSourceConfig? sourceConfig,
    AlbumBackupTargetConfig? targetConfig,
  }) {
    final profile = SyncProfile()
      ..mergeFromMessage(_profile)
      ..name = name ?? this.name
      ..enabled = enabled ?? this.enabled;
    return AlbumBackupProfile._(
      profile: profile,
      sourceConfig: sourceConfig ?? this.sourceConfig,
      targetConfig: targetConfig ?? this.targetConfig,
    );
  }

  SyncProfile toSyncProfile() {
    return SyncProfile()
      ..mergeFromMessage(_profile)
      ..sourceConfig = jsonEncode(sourceConfig.toJson())
      ..targetConfig = jsonEncode(targetConfig.toJson());
  }

  static Map<String, dynamic> _decodeConfig(String value, String name) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    throw FormatException('$name配置格式错误');
  }
}

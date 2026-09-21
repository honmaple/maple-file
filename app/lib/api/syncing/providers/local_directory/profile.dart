import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class LocalDirectorySourceConfig with _$LocalDirectorySourceConfig {
  const factory LocalDirectorySourceConfig({
    @Default('') String path,
    @Default('') String bookmark,
  }) = _LocalDirectorySourceConfig;

  factory LocalDirectorySourceConfig.fromJson(Map<String, Object?> json) =>
      _$LocalDirectorySourceConfigFromJson(json);
}

@freezed
class LocalDirectoryTargetConfig with _$LocalDirectoryTargetConfig {
  const factory LocalDirectoryTargetConfig({
    @Default('') String path,
  }) = _LocalDirectoryTargetConfig;

  factory LocalDirectoryTargetConfig.fromJson(Map<String, Object?> json) =>
      _$LocalDirectoryTargetConfigFromJson(json);
}

class LocalDirectorySyncProfile {
  LocalDirectorySyncProfile._({
    required SyncProfile profile,
    required this.sourceConfig,
    required this.targetConfig,
  }) : _profile = SyncProfile()..mergeFromMessage(profile);

  factory LocalDirectorySyncProfile.create({required String name}) {
    return LocalDirectorySyncProfile._(
      profile: SyncProfile(
        name: name,
        mode: SyncProfile_Mode.MODE_ONE_WAY,
        enabled: true,
        sourceType: SyncSourceType.localDirectory.value,
        sourceConfig: '{}',
        targetType: SyncTargetType.repoDirectory.value,
        targetConfig: '{}',
        policyConfig: '{}',
      ),
      sourceConfig: const LocalDirectorySourceConfig(),
      targetConfig: const LocalDirectoryTargetConfig(),
    );
  }

  factory LocalDirectorySyncProfile.fromSyncProfile(SyncProfile profile) {
    if (SyncSourceType.fromValue(profile.sourceType) !=
            SyncSourceType.localDirectory ||
        profile.mode != SyncProfile_Mode.MODE_ONE_WAY ||
        SyncTargetType.fromValue(profile.targetType) !=
            SyncTargetType.repoDirectory) {
      throw const FormatException('此同步配置不是本地目录同步');
    }
    return LocalDirectorySyncProfile._(
      profile: profile,
      sourceConfig: LocalDirectorySourceConfig.fromJson(
        _decodeConfig(profile.sourceConfig, '本地来源'),
      ),
      targetConfig: LocalDirectoryTargetConfig.fromJson(
        _decodeConfig(profile.targetConfig, '同步目标'),
      ),
    );
  }

  final SyncProfile _profile;
  final LocalDirectorySourceConfig sourceConfig;
  final LocalDirectoryTargetConfig targetConfig;

  int get id => _profile.id;
  String get name => _profile.name;
  bool get enabled => _profile.enabled;
  int get configVersion => _profile.configVersion.toInt();

  LocalDirectorySyncProfile copyWith({
    String? name,
    bool? enabled,
    LocalDirectorySourceConfig? sourceConfig,
    LocalDirectoryTargetConfig? targetConfig,
  }) {
    final profile = SyncProfile()
      ..mergeFromMessage(_profile)
      ..name = name ?? this.name
      ..enabled = enabled ?? this.enabled;
    return LocalDirectorySyncProfile._(
      profile: profile,
      sourceConfig: sourceConfig ?? this.sourceConfig,
      targetConfig: targetConfig ?? this.targetConfig,
    );
  }

  SyncProfile toSyncProfile() {
    return SyncProfile()
      ..mergeFromMessage(_profile)
      ..sourceConfig = jsonEncode(sourceConfig.toJson())
      ..targetConfig = jsonEncode(targetConfig.toJson())
      ..policyConfig = '{}';
  }

  static Map<String, dynamic> _decodeConfig(String value, String name) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    throw FormatException('$name配置格式错误');
  }
}

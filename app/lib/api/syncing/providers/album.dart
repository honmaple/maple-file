import 'dart:convert';
import 'dart:io' as io;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as filepath;
import 'package:photo_manager/photo_manager.dart';

import 'package:maple_file/api/file/providers/service.dart';
import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/api/syncing/providers/target.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

part 'album.freezed.dart';
part 'album.g.dart';

enum AlbumTargetLayout {
  @JsonValue('year_month_day')
  yearMonthDay('year_month_day'),
  @JsonValue('year_month')
  yearMonth('year_month'),
  @JsonValue('filename_asset_id')
  filenameAssetId('filename_asset_id');

  const AlbumTargetLayout(this.value);

  final String value;

  String get label => switch (this) {
        AlbumTargetLayout.yearMonthDay => '按年月日整理'.tr(),
        AlbumTargetLayout.yearMonth => '按年月整理'.tr(),
        AlbumTargetLayout.filenameAssetId => '文件名加资产 ID'.tr(),
      };

  static AlbumTargetLayout fromValue(String? value) {
    return AlbumTargetLayout.values.firstWhere(
      (layout) => layout.value == value,
      orElse: () => AlbumTargetLayout.yearMonthDay,
    );
  }

  List<String> pathParts(DateTime date) => switch (this) {
        AlbumTargetLayout.yearMonthDay => [
            date.year.toString().padLeft(4, '0'),
            date.month.toString().padLeft(2, '0'),
            date.day.toString().padLeft(2, '0'),
          ],
        AlbumTargetLayout.yearMonth => [
            date.year.toString().padLeft(4, '0'),
            date.month.toString().padLeft(2, '0'),
          ],
        AlbumTargetLayout.filenameAssetId => const [],
      };
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

class AlbumBackupResult {
  final int scanned;
  final int uploaded;
  final int skipped;
  final List<AlbumBackupFailure> failures;

  int get failed => failures.length;

  const AlbumBackupResult({
    required this.scanned,
    required this.uploaded,
    required this.skipped,
    required this.failures,
  });
}

String albumBackupFilename(String originalName, String assetId) {
  final name = filepath.posix.basename(originalName.replaceAll('\\', '/'));
  final extension = filepath.extension(name);
  final stem = filepath.basenameWithoutExtension(name);
  final safeId = assetId.replaceAll(RegExp(r'[/\\]'), '_');
  return '${stem}_$safeId$extension';
}

bool albumBackupRecordMatches(
  SyncRecord record,
  DateTime modifiedAt,
  String targetDirectory,
  String? expectedName,
  int configVersion,
) {
  return record.state == SyncRecord_State.STATE_ACTIVE &&
      record.configVersion.toInt() == configVersion &&
      record.hasSourceModifiedAt() &&
      record.sourceModifiedAt.toDateTime().millisecondsSinceEpoch ==
          modifiedAt.millisecondsSinceEpoch &&
      filepath.posix.dirname(record.targetPath) == targetDirectory &&
      (expectedName == null ||
          filepath.posix.basename(record.targetPath) == expectedName);
}

String albumBackupTargetPath(
  AlbumBackupTargetConfig config,
  String deviceModel,
) {
  final model =
      deviceModel.replaceAll(RegExp(r'[/\\:*?"<>|\x00-\x1F]'), '_').trim();
  if (!config.appendDeviceModel || model.isEmpty) return config.path;
  if (filepath.posix.basename(config.path) == model) return config.path;
  return filepath.posix.join(config.path, model);
}

Future<String> albumBackupDeviceModel() async {
  try {
    final deviceInfo = DeviceInfoPlugin();
    if (Util.isAndroid) return (await deviceInfo.androidInfo).model;
    if (Util.isIOS) return (await deviceInfo.iosInfo).modelName;
  } catch (_) {
    // The base target remains usable when device information is unavailable.
  }
  return '';
}

class AlbumBackupService {
  static AlbumBackupService get instance => _instance;
  static final AlbumBackupService _instance = AlbumBackupService._internal();

  factory AlbumBackupService() => _instance;

  AlbumBackupService._internal();

  Future<SyncHistory> run(AlbumBackupProfile profile) async {
    final startedAt = DateTime.now();
    final runId = await SyncHistoryStore.start(profile.id, startedAt);
    AlbumBackupResult? result;
    String? errorMessage;
    try {
      result = await _run(profile);
    } catch (error) {
      errorMessage = '$error';
    }
    final history = buildAlbumSyncHistory(
      profileId: profile.id,
      runId: runId,
      startedAt: startedAt,
      finishedAt: DateTime.now(),
      result: result,
      error: errorMessage,
    );
    try {
      return await SyncHistoryStore.finish(history);
    } catch (error) {
      throw StateError('保存备份记录失败：$error');
    }
  }

  Future<List<AssetPathEntity>> requestAlbums(
      {bool includeEmpty = false}) async {
    final state = await PhotoManager.requestPermissionExtend();
    if (!state.hasAccess) {
      throw StateError('请在系统设置中允许访问照片和视频');
    }
    final albums =
        await PhotoManager.getAssetPathList(type: RequestType.common);
    if (includeEmpty) return albums;
    final counts =
        await Future.wait(albums.map((album) => album.assetCountAsync));
    return [
      for (var index = 0; index < albums.length; index++)
        if (counts[index] > 0) albums[index],
    ];
  }

  Future<AlbumBackupResult> _run(AlbumBackupProfile profile) async {
    if (profile.targetConfig.path.isEmpty) {
      throw StateError('备份目录配置无效');
    }
    final targetPath = albumBackupTargetPath(
      profile.targetConfig,
      await albumBackupDeviceModel(),
    );
    final targetDirectory = SyncTargetDirectory();
    await targetDirectory.ensure(targetPath);
    final albums = await requestAlbums(includeEmpty: true);
    final paths = {for (final album in albums) album.id: album};
    var uploaded = 0;
    var skipped = 0;
    var scanned = 0;
    final failures = <AlbumBackupFailure>[];
    final verifiedAssets = <String, SyncRecord>{};
    for (final sourceKey in profile.sourceConfig.albumIds) {
      final album = paths[sourceKey];
      if (album == null) {
        failures.add(AlbumBackupFailure(
          album: sourceKey,
          item: sourceKey,
          reason: '相册不可访问或已删除',
          sourceKey: sourceKey,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
          errorCode: 'source_unavailable',
        ));
        continue;
      }
      try {
        final result = await _runAlbumSource(
          profile,
          sourceKey,
          album,
          targetPath,
          profile.targetConfig.layout,
          targetDirectory,
          verifiedAssets,
        );
        uploaded += result.uploaded;
        skipped += result.skipped;
        scanned += result.scanned;
        failures.addAll(result.failures);
      } catch (error) {
        failures.add(AlbumBackupFailure(
          album: album.name,
          item: '',
          reason: '$error',
          sourceKey: sourceKey,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        ));
      }
    }
    return AlbumBackupResult(
      scanned: scanned,
      uploaded: uploaded,
      skipped: skipped,
      failures: failures,
    );
  }

  Future<AlbumBackupResult> _runAlbumSource(
    AlbumBackupProfile profile,
    String sourceKey,
    AssetPathEntity album,
    String targetPath,
    AlbumTargetLayout layout,
    SyncTargetDirectory targetStore,
    Map<String, SyncRecord> verifiedAssets,
  ) async {
    var uploaded = 0;
    var skipped = 0;
    var scanned = 0;
    final failures = <AlbumBackupFailure>[];
    for (var page = 0;; page++) {
      List<AssetEntity> assets;
      try {
        assets = await album.getAssetListPaged(page: page, size: 100);
      } catch (error) {
        failures.add(AlbumBackupFailure(
          album: album.name,
          item: '',
          reason: '读取相册失败：$error',
          sourceKey: sourceKey,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        ));
        break;
      }
      if (assets.isEmpty) break;
      scanned += assets.length;
      Map<String, SyncRecord> recorded;
      try {
        recorded =
            await _listRecorded(profile.id, sourceKey, assets.map((e) => e.id));
      } catch (error) {
        failures.add(AlbumBackupFailure(
          album: album.name,
          item: '',
          reason: '查询已备份文件失败：$error',
          sourceKey: sourceKey,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        ));
        break;
      }
      for (final asset in assets) {
        var itemName = asset.id;
        var stage = '检查备份记录';
        var targetItemPath = '';
        var sourceItemPath = '';
        try {
          final title = await asset.titleAsync;
          if (title.isNotEmpty) itemName = title;
          final targetDirectory = _targetDirectory(targetPath, layout, asset);
          final expectedName =
              title.isEmpty ? null : albumBackupFilename(title, asset.id);
          final verifiedKey = '$sourceKey:${asset.id}';
          final verified = verifiedAssets[verifiedKey];
          if (verified != null &&
              albumBackupRecordMatches(
                verified,
                asset.modifiedDateTime,
                targetDirectory,
                expectedName,
                profile.configVersion,
              )) {
            skipped++;
            continue;
          }
          final record = recorded[asset.id];
          if (record != null &&
              albumBackupRecordMatches(
                record,
                asset.modifiedDateTime,
                targetDirectory,
                expectedName,
                profile.configVersion,
              )) {
            stage = '检查云端文件';
            final remoteFiles = await targetStore.ensure(targetDirectory);
            final remoteFile = targetStore.find(
              remoteFiles,
              filepath.posix.basename(record.targetPath),
            );
            if (record.hasTargetSize() &&
                remoteFile != null &&
                remoteFile.type != 'DIR' &&
                remoteFile.size == record.targetSize) {
              verifiedAssets[verifiedKey] = record;
              skipped++;
              continue;
            }
          }
          stage = '读取相册文件';
          final file = await asset.originFile;
          if (file == null) {
            failures.add(AlbumBackupFailure(
              album: album.name,
              item: itemName,
              reason: '无法读取原始文件',
              sourceKey: sourceKey,
              itemKey: asset.id,
              errorCode: 'source_unreadable',
            ));
            continue;
          }
          if (!await file.exists()) {
            failures.add(AlbumBackupFailure(
              album: album.name,
              item: itemName,
              reason: '本地照片文件不存在：${file.path}',
              sourceKey: sourceKey,
              itemKey: asset.id,
              sourcePath: file.path,
              errorCode: 'source_missing',
            ));
            continue;
          }
          sourceItemPath = file.path;
          stage = '准备云端目录';
          final uploadTarget = await _prepareTarget(
            targetPath,
            layout,
            asset,
            file,
            targetStore,
            title,
          );
          targetItemPath =
              filepath.posix.join(uploadTarget.directory, uploadTarget.name);
          stage = '上传到 ${uploadTarget.directory}/${uploadTarget.name}';
          final (uploadedFile, hashAlgorithm, sourceHash) =
              await FileService.instance.uploadFilePreservingName(
            uploadTarget.directory,
            file,
            uploadTarget.name,
          );
          final uploadedRecord = SyncRecord(
            profileId: profile.id,
            sourcePath: sourceKey,
            sourceKey: asset.id,
            configVersion: fixnum.Int64(profile.configVersion),
            targetPath:
                filepath.posix.join(uploadedFile.path, uploadedFile.name),
            sourceSize: fixnum.Int64(file.lengthSync()),
            targetSize: uploadedFile.size,
            sourceModifiedAt: Timestamp.fromDateTime(asset.modifiedDateTime),
            targetModifiedAt:
                uploadedFile.hasUpdatedAt() ? uploadedFile.updatedAt : null,
            sourceHashAlgorithm: hashAlgorithm,
            sourceHash: sourceHash,
            state: SyncRecord_State.STATE_ACTIVE,
            syncedAt: Timestamp.fromDateTime(DateTime.now()),
          );
          stage = '保存备份记录';
          await SyncingService.instance.upsertRecords([uploadedRecord]);
          verifiedAssets[verifiedKey] = uploadedRecord;
          targetStore.record(uploadTarget.directory, uploadedFile);
          uploaded++;
        } catch (error) {
          failures.add(AlbumBackupFailure(
            album: album.name,
            item: itemName,
            reason: '$stage：$error',
            sourceKey: sourceKey,
            itemKey: asset.id,
            sourcePath: sourceItemPath,
            targetPath: targetItemPath,
            operation: stage == '检查备份记录'
                ? SyncHistoryIssue_Operation.OPERATION_SCAN
                : stage == '检查云端文件'
                    ? SyncHistoryIssue_Operation.OPERATION_VERIFY
                    : SyncHistoryIssue_Operation.OPERATION_UPLOAD,
            errorCode: stage == '保存备份记录'
                ? 'record_write_failed'
                : stage == '检查云端文件'
                    ? 'target_check_failed'
                    : stage.startsWith('上传')
                        ? 'upload_failed'
                        : 'backup_error',
          ));
        }
      }
      if (assets.length < 100) break;
    }
    return AlbumBackupResult(
      scanned: scanned,
      uploaded: uploaded,
      skipped: skipped,
      failures: failures,
    );
  }

  Future<Map<String, SyncRecord>> _listRecorded(
      int profileId, String albumId, Iterable<String> assetIds) async {
    final records = await SyncingService.instance.listRecords(
      SyncRecord_ListRequest(
        profileId: profileId,
        sourcePath: albumId,
        sourceKeys: assetIds,
      ),
    );
    return {for (final record in records) record.sourceKey: record};
  }

  String _targetDirectory(
    String targetPath,
    AlbumTargetLayout layout,
    AssetEntity asset,
  ) {
    return filepath.posix.joinAll([
      targetPath,
      ...layout.pathParts(asset.createDateTime),
    ]);
  }

  Future<_AlbumBackupTarget> _prepareTarget(
    String targetPath,
    AlbumTargetLayout layout,
    AssetEntity asset,
    io.File file,
    SyncTargetDirectory targetStore,
    String original,
  ) async {
    final sourceName =
        original.isEmpty ? filepath.basename(file.path) : original;
    var path = targetPath;
    for (final part in layout.pathParts(asset.createDateTime)) {
      final nextPath = filepath.posix.join(path, part);
      await targetStore.ensure(nextPath);
      path = nextPath;
    }
    return _AlbumBackupTarget(
      path,
      albumBackupFilename(sourceName, asset.id),
    );
  }
}

class _AlbumBackupTarget {
  final String directory;
  final String name;

  const _AlbumBackupTarget(this.directory, this.name);
}

class AlbumBackupFailure {
  const AlbumBackupFailure(
      {required this.album,
      required this.item,
      required this.reason,
      this.sourceKey = '',
      this.itemKey = '',
      this.sourcePath = '',
      this.targetPath = '',
      this.operation = SyncHistoryIssue_Operation.OPERATION_UPLOAD,
      this.errorCode = ''});

  final String album;
  final String item;
  final String reason;
  final String sourceKey;
  final String itemKey;
  final String sourcePath;
  final String targetPath;
  final SyncHistoryIssue_Operation operation;
  final String errorCode;

  SyncHistoryIssue toIssue() {
    final context = AlbumBackupIssueContext(
      albumLabel: album.isEmpty ? null : album,
      localPath: sourcePath.isEmpty ? null : sourcePath,
    ).toJson();
    return SyncHistoryIssue(
      sourceLabel: item.isEmpty ? album : item,
      sourcePath: sourceKey,
      sourceKey: itemKey,
      targetPath: targetPath,
      errorOperation: operation,
      errorCode: errorCode,
      kind: SyncHistoryIssue_Kind.KIND_ERROR,
      errorMessage: reason,
      context: context.isEmpty ? '' : jsonEncode(context),
    );
  }
}

SyncHistory buildAlbumSyncHistory({
  required int profileId,
  required String runId,
  required DateTime startedAt,
  required DateTime finishedAt,
  AlbumBackupResult? result,
  String? error,
}) {
  final failures = result?.failures ?? const <AlbumBackupFailure>[];
  return SyncHistory(
    profileId: profileId,
    runId: runId,
    startedAt: Timestamp.fromDateTime(startedAt),
    finishedAt: Timestamp.fromDateTime(finishedAt),
    status: error != null
        ? SyncHistory_Status.STATUS_FAILED
        : failures.isNotEmpty
            ? SyncHistory_Status.STATUS_PARTIAL
            : SyncHistory_Status.STATUS_SUCCEEDED,
    trigger: SyncHistory_Trigger.TRIGGER_MANUAL,
    scanned: result?.scanned ?? 0,
    synced: result?.uploaded ?? 0,
    skipped: result?.skipped ?? 0,
    failed: failures.length + (error == null ? 0 : 1),
    errorSummary: error ?? '',
    issues: [for (final failure in failures) failure.toIssue()],
  );
}

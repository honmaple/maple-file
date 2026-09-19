import 'dart:convert';
import 'dart:io' as io;

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:path/path.dart' as filepath;
import 'package:photo_manager/photo_manager.dart';

import 'package:maple_file/api/file/providers/service.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

enum AlbumDestinationLayout {
  yearMonthDay('year_month_day', '按年月日整理'),
  yearMonth('year_month', '按年月整理'),
  filenameAssetId('filename_asset_id', '文件名加资产 ID');

  const AlbumDestinationLayout(this.value, this.label);

  final String value;
  final String label;

  static AlbumDestinationLayout fromValue(String? value) {
    return AlbumDestinationLayout.values.firstWhere(
      (layout) => layout.value == value,
      orElse: () => AlbumDestinationLayout.yearMonthDay,
    );
  }

  List<String> pathParts(DateTime date) => switch (this) {
        AlbumDestinationLayout.yearMonthDay => [
            date.year.toString().padLeft(4, '0'),
            date.month.toString().padLeft(2, '0'),
            date.day.toString().padLeft(2, '0'),
          ],
        AlbumDestinationLayout.yearMonth => [
            date.year.toString().padLeft(4, '0'),
            date.month.toString().padLeft(2, '0'),
          ],
        AlbumDestinationLayout.filenameAssetId => const [],
      };
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
  String destinationPath,
  String? expectedName,
  int configVersion,
) {
  return record.state == SyncRecord_State.STATE_ACTIVE &&
      record.configVersion.toInt() == configVersion &&
      record.hasSourceModifiedAt() &&
      record.sourceModifiedAt.toDateTime().millisecondsSinceEpoch ==
          modifiedAt.millisecondsSinceEpoch &&
      filepath.posix.dirname(record.targetPath) == destinationPath &&
      (expectedName == null ||
          filepath.posix.basename(record.targetPath) == expectedName);
}

class AlbumBackupService {
  static AlbumBackupService get instance => _instance;
  static final AlbumBackupService _instance = AlbumBackupService._internal();

  factory AlbumBackupService() => _instance;

  AlbumBackupService._internal();

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

  Future<AlbumBackupResult> run(SyncProfile profile) async {
    if (!profile.enabled) {
      throw StateError('请先启用此相册备份');
    }
    if (SyncSourceType.fromValue(profile.sourceType) != SyncSourceType.album ||
        profile.mode != SyncProfile_Mode.MODE_BACKUP ||
        SyncTargetType.fromValue(profile.targetType) !=
            SyncTargetType.repoDirectory) {
      throw StateError('此同步配置不能作为相册备份执行');
    }
    final target = _json(profile.targetConfig);
    final targetPath = target['path'] as String?;
    if (targetPath == null || targetPath.isEmpty) {
      throw StateError('备份目录配置无效');
    }
    final albums = await requestAlbums(includeEmpty: true);
    final paths = {for (final album in albums) album.id: album};
    final sourceIds = (_json(profile.sourceConfig)['album_ids'] as List?)
            ?.whereType<String>()
            .toList() ??
        const <String>[];
    var uploaded = 0;
    var skipped = 0;
    var scanned = 0;
    final failures = <AlbumBackupFailure>[];
    await _ensureTargetDirectory(targetPath);
    final createdDirectories = <String>{targetPath};
    final remoteDirectories = <String, Map<String, int>>{};
    final verifiedAssets = <String, SyncRecord>{};
    for (final sourceKey in sourceIds) {
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
          AlbumDestinationLayout.fromValue(target['layout'] as String?),
          createdDirectories,
          remoteDirectories,
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
    SyncProfile profile,
    String sourceKey,
    AssetPathEntity album,
    String targetPath,
    AlbumDestinationLayout layout,
    Set<String> createdDirectories,
    Map<String, Map<String, int>> remoteDirectories,
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
          final path = _destinationPath(targetPath, layout, asset);
          final expectedName =
              title.isEmpty ? null : albumBackupFilename(title, asset.id);
          final verifiedKey = '$sourceKey:${asset.id}';
          final verified = verifiedAssets[verifiedKey];
          if (verified != null &&
              albumBackupRecordMatches(verified, asset.modifiedDateTime, path,
                  expectedName, profile.configVersion.toInt())) {
            skipped++;
            continue;
          }
          final record = recorded[asset.id];
          if (record != null &&
              albumBackupRecordMatches(
                record,
                asset.modifiedDateTime,
                path,
                expectedName,
                profile.configVersion.toInt(),
              )) {
            stage = '检查云端文件';
            var remoteFiles = remoteDirectories[path];
            if (remoteFiles == null) {
              try {
                final files =
                    await FileService.instance.list(filter: {'path': path});
                remoteFiles = {
                  for (final file in files)
                    if (file.type != 'DIR') file.name: file.size.toInt(),
                };
              } catch (error) {
                final message = error.toString().toLowerCase();
                if (!message.contains('does not exist') &&
                    !message.contains('not found') &&
                    !message.contains('no such file')) {
                  rethrow;
                }
                remoteFiles = {};
              }
              remoteDirectories[path] = remoteFiles;
            }
            if (record.hasTargetSize() &&
                remoteFiles[filepath.posix.basename(record.targetPath)] ==
                    record.targetSize.toInt()) {
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
          final destination = await _destination(
            targetPath,
            layout,
            asset,
            file,
            createdDirectories,
            title,
          );
          targetItemPath =
              filepath.posix.join(destination.path, destination.name);
          stage = '上传到 ${destination.path}/${destination.name}';
          final (uploadedFile, hashAlgorithm, sourceHash) =
              await FileService.instance.uploadFilePreservingName(
                  destination.path, file, destination.name);
          final uploadedRecord = SyncRecord(
            profileId: profile.id,
            sourcePath: sourceKey,
            sourceKey: asset.id,
            configVersion: profile.configVersion,
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
          remoteDirectories[destination.path]?[destination.name] =
              uploadedFile.size.toInt();
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

  String _destinationPath(
    String targetPath,
    AlbumDestinationLayout layout,
    AssetEntity asset,
  ) {
    return filepath.posix.joinAll([
      targetPath,
      ...layout.pathParts(asset.createDateTime),
    ]);
  }

  Future<_BackupDestination> _destination(
    String targetPath,
    AlbumDestinationLayout layout,
    AssetEntity asset,
    io.File file,
    Set<String> createdDirectories,
    String original,
  ) async {
    final sourceName =
        original.isEmpty ? filepath.basename(file.path) : original;
    var path = targetPath;
    for (final part in layout.pathParts(asset.createDateTime)) {
      final nextPath = filepath.posix.join(path, part);
      if (!createdDirectories.contains(nextPath)) {
        final files = await FileService.instance.list(filter: {'path': path});
        if (!files.any((file) => file.name == part && file.type == 'DIR')) {
          await FileService.instance.mkdir(path, part);
        }
        createdDirectories.add(nextPath);
      }
      path = nextPath;
    }
    return _BackupDestination(
      path,
      albumBackupFilename(sourceName, asset.id),
    );
  }

  Future<void> _ensureTargetDirectory(String path) async {
    try {
      await FileService.instance.list(filter: {'path': path});
      return;
    } catch (error) {
      final message = error.toString().toLowerCase();
      if (!message.contains('does not exist') &&
          !message.contains('not found') &&
          !message.contains('no such file')) {
        rethrow;
      }
    }
    final parent = filepath.posix.dirname(path);
    final name = filepath.posix.basename(path);
    if (name.isEmpty || name == '/' || parent == path) {
      throw StateError('备份目录不存在：$path');
    }
    final files = await FileService.instance.list(filter: {'path': parent});
    if (!files.any((file) => file.name == name && file.type == 'DIR')) {
      await FileService.instance.mkdir(parent, name);
    }
  }

  Map<String, dynamic> _json(String value) {
    final decoded = jsonDecode(value);
    if (decoded is! Map<String, dynamic>) throw const FormatException('配置格式错误');
    return decoded;
  }
}

class _BackupDestination {
  final String path;
  final String name;

  const _BackupDestination(this.path, this.name);
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

  factory AlbumBackupFailure.fromHistory(SyncHistoryIssue issue) {
    Map<String, dynamic> context = const {};
    try {
      final value = jsonDecode(issue.context);
      if (value is Map<String, dynamic>) context = value;
    } catch (_) {}
    return AlbumBackupFailure(
      album: context['album_label'] as String? ?? '',
      item: issue.sourceKey.isEmpty ? '' : issue.sourceLabel,
      reason: issue.errorMessage,
      sourceKey: issue.sourcePath,
      itemKey: issue.sourceKey,
      sourcePath: context['local_path'] as String? ?? '',
      targetPath: issue.targetPath,
      operation: issue.errorOperation,
      errorCode: issue.errorCode,
    );
  }

  SyncHistoryIssue toHistory() {
    final context = <String, String>{
      if (album.isNotEmpty) 'album_label': album,
      if (sourcePath.isNotEmpty) 'local_path': sourcePath,
    };
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

class AlbumBackupHistory {
  const AlbumBackupHistory(
      {required this.startedAt,
      required this.finishedAt,
      required this.uploaded,
      required this.skipped,
      this.scanned = 0,
      required this.failures,
      this.error,
      this.status = SyncHistory_Status.STATUS_UNSPECIFIED,
      this.historyId = 0});

  final DateTime startedAt;
  final DateTime finishedAt;
  final int uploaded;
  final int skipped;
  final int scanned;
  final List<AlbumBackupFailure> failures;
  final String? error;
  final SyncHistory_Status status;
  final int historyId;

  int get failed => failures.length + (error == null ? 0 : 1);
  bool get hasFailed => failed > 0;
  bool get isRunning => status == SyncHistory_Status.STATUS_RUNNING;
  bool get isInterrupted => status == SyncHistory_Status.STATUS_INTERRUPTED;

  factory AlbumBackupHistory.fromHistory(SyncHistory history) =>
      AlbumBackupHistory(
        startedAt: history.startedAt.toDateTime(),
        finishedAt: history.hasFinishedAt()
            ? history.finishedAt.toDateTime()
            : history.startedAt.toDateTime(),
        uploaded: history.synced,
        skipped: history.skipped,
        scanned: history.scanned,
        failures: [
          for (final issue in history.issues)
            AlbumBackupFailure.fromHistory(issue)
        ],
        error: history.errorSummary.isEmpty ? null : history.errorSummary,
        status: history.status,
        historyId: history.id.toInt(),
      );

  SyncHistory toHistory(int profileId, String runId) => SyncHistory(
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
        scanned: scanned,
        synced: uploaded,
        skipped: skipped,
        failed: failed,
        errorSummary: error ?? '',
        issues: [for (final failure in failures) failure.toHistory()],
      );
}

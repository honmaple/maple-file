import 'dart:convert';
import 'dart:io' as io;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:path/path.dart' as filepath;
import 'package:photo_manager/photo_manager.dart';

import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

import 'package:maple_file/api/file/providers/service.dart';
import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/providers/service.dart';

import 'profile.dart';

class _AlbumBackupTarget {
  final String directory;
  final String name;

  const _AlbumBackupTarget(this.directory, this.name);
}

class AlbumBackupResult {
  const AlbumBackupResult({
    required this.scanned,
    required this.uploaded,
    required this.skipped,
    required this.issues,
  });

  final int scanned;
  final int uploaded;
  final int skipped;
  final List<SyncHistoryIssue> issues;

  int get failed => issues.length;
}

class AlbumBackupService {
  static AlbumBackupService get instance => _instance;
  static final AlbumBackupService _instance = AlbumBackupService._internal();

  factory AlbumBackupService() => _instance;

  AlbumBackupService._internal();

  static String filename(String originalName) {
    return filepath.posix.basename(originalName.replaceAll('\\', '/'));
  }

  static List<String> layoutPathParts({
    required AlbumTargetLayout layout,
    required DateTime createdAt,
    required String albumName,
    required bool isAndroid,
    String? relativePath,
  }) {
    return switch (layout) {
      AlbumTargetLayout.flat => _flatPathParts(
          albumName: albumName,
          isAndroid: isAndroid,
          relativePath: relativePath,
        ),
      AlbumTargetLayout.yearMonth => [
          createdAt.year.toString().padLeft(4, '0'),
          createdAt.month.toString().padLeft(2, '0'),
        ],
      AlbumTargetLayout.yearMonthDay => [
          createdAt.year.toString().padLeft(4, '0'),
          createdAt.month.toString().padLeft(2, '0'),
          createdAt.day.toString().padLeft(2, '0'),
        ],
    };
  }

  static List<String> _flatPathParts({
    required String albumName,
    required bool isAndroid,
    String? relativePath,
  }) {
    if (!isAndroid) return [_safePathComponent(albumName)];
    var path = (relativePath ?? '').replaceAll('\\', '/');
    if (path.startsWith('/')) {
      final storageRoot = RegExp(
        r'^/(?:storage/emulated/\d+|storage/self/primary|storage/[^/]+|sdcard|mnt/media_rw/[^/]+)(?:/|$)',
      ).firstMatch(path);
      if (storageRoot == null) return [_safePathComponent(albumName)];
      path = path.substring(storageRoot.end);
    }
    final parts = path
        .split('/')
        .where((part) => part.isNotEmpty && part != '.' && part != '..')
        .map(_safePathComponent)
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? [_safePathComponent(albumName)] : parts;
  }

  static String _safePathComponent(String value) {
    final result =
        value.replaceAll(RegExp(r'[/\\:*?"<>|\x00-\x1F]'), '_').trim();
    return result.isEmpty ? '未命名相册' : result;
  }

  static bool recordMatches(
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

  static String targetPath(
    AlbumBackupTargetConfig config,
    String deviceModel,
  ) {
    final model =
        deviceModel.replaceAll(RegExp(r'[/\\:*?"<>|\x00-\x1F]'), '_').trim();
    if (!config.appendDeviceModel || model.isEmpty) return config.path;
    if (filepath.posix.basename(config.path) == model) return config.path;
    return filepath.posix.join(config.path, model);
  }

  static Future<String> deviceModel() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Util.isAndroid) return (await deviceInfo.androidInfo).model;
      if (Util.isIOS) return (await deviceInfo.iosInfo).modelName;
    } catch (_) {
      // The base target remains usable when device information is unavailable.
    }
    return '';
  }

  static SyncHistoryIssue _issue({
    required String albumLabel,
    required String itemLabel,
    required String message,
    String albumId = '',
    String assetId = '',
    String localPath = '',
    String targetPath = '',
    SyncHistoryIssue_Operation operation =
        SyncHistoryIssue_Operation.OPERATION_UPLOAD,
    String errorCode = '',
  }) {
    final context = AlbumBackupIssueContext(
      albumLabel: albumLabel.isEmpty ? null : albumLabel,
      localPath: localPath.isEmpty ? null : localPath,
    ).toJson();
    return SyncHistoryIssue(
      sourceLabel: itemLabel.isEmpty ? albumLabel : itemLabel,
      sourcePath: albumId,
      sourceKey: assetId,
      targetPath: targetPath,
      errorOperation: operation,
      errorCode: errorCode,
      kind: SyncHistoryIssue_Kind.KIND_ERROR,
      errorMessage: message,
      context: context.isEmpty ? '' : jsonEncode(context),
    );
  }

  static SyncHistory buildHistory({
    required int profileId,
    required String runId,
    required DateTime startedAt,
    required DateTime finishedAt,
    AlbumBackupResult? result,
    String? error,
  }) {
    final issues = result?.issues ?? const <SyncHistoryIssue>[];
    return SyncHistory(
      profileId: profileId,
      runId: runId,
      startedAt: Timestamp.fromDateTime(startedAt),
      finishedAt: Timestamp.fromDateTime(finishedAt),
      status: error != null
          ? SyncHistory_Status.STATUS_FAILED
          : issues.isNotEmpty
              ? SyncHistory_Status.STATUS_PARTIAL
              : SyncHistory_Status.STATUS_SUCCEEDED,
      trigger: SyncHistory_Trigger.TRIGGER_MANUAL,
      scanned: result?.scanned ?? 0,
      synced: result?.uploaded ?? 0,
      skipped: result?.skipped ?? 0,
      failed: issues.length + (error == null ? 0 : 1),
      errorSummary: error ?? '',
      issues: issues,
    );
  }

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
    final history = AlbumBackupService.buildHistory(
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
    final targetPath = AlbumBackupService.targetPath(
      profile.targetConfig,
      await AlbumBackupService.deviceModel(),
    );
    final targetDirectory = SyncTargetDirectory();
    await targetDirectory.ensure(targetPath);
    final albums = await requestAlbums(includeEmpty: true);
    final paths = {for (final album in albums) album.id: album};
    var uploaded = 0;
    var skipped = 0;
    var scanned = 0;
    final issues = <SyncHistoryIssue>[];
    final verifiedAssets = <String, SyncRecord>{};
    for (final sourceKey in profile.sourceConfig.albumIds) {
      final album = paths[sourceKey];
      if (album == null) {
        issues.add(_issue(
          albumLabel: sourceKey,
          itemLabel: sourceKey,
          message: '相册不可访问或已删除',
          albumId: sourceKey,
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
        issues.addAll(result.issues);
      } catch (error) {
        issues.add(_issue(
          albumLabel: album.name,
          itemLabel: '',
          message: '$error',
          albumId: sourceKey,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        ));
      }
    }
    return AlbumBackupResult(
      scanned: scanned,
      uploaded: uploaded,
      skipped: skipped,
      issues: issues,
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
    final issues = <SyncHistoryIssue>[];
    for (var page = 0;; page++) {
      List<AssetEntity> assets;
      try {
        assets = await album.getAssetListPaged(page: page, size: 100);
      } catch (error) {
        issues.add(_issue(
          albumLabel: album.name,
          itemLabel: '',
          message: '读取相册失败：$error',
          albumId: sourceKey,
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
        issues.add(_issue(
          albumLabel: album.name,
          itemLabel: '',
          message: '查询已备份文件失败：$error',
          albumId: sourceKey,
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
          final targetDirectory =
              _targetDirectory(targetPath, layout, album.name, asset);
          final expectedName =
              title.isEmpty ? null : AlbumBackupService.filename(title);
          final verifiedKey = '$sourceKey:${asset.id}';
          final verified = verifiedAssets[verifiedKey];
          if (verified != null &&
              AlbumBackupService.recordMatches(
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
              AlbumBackupService.recordMatches(
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
            issues.add(_issue(
              albumLabel: album.name,
              itemLabel: itemName,
              message: '无法读取原始文件',
              albumId: sourceKey,
              assetId: asset.id,
              errorCode: 'source_unreadable',
            ));
            continue;
          }
          if (!await file.exists()) {
            issues.add(_issue(
              albumLabel: album.name,
              itemLabel: itemName,
              message: '本地照片文件不存在：${file.path}',
              albumId: sourceKey,
              assetId: asset.id,
              localPath: file.path,
              errorCode: 'source_missing',
            ));
            continue;
          }
          sourceItemPath = file.path;
          stage = '准备云端目录';
          final uploadTarget = await _prepareTarget(
            targetPath,
            layout,
            album.name,
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
          issues.add(_issue(
            albumLabel: album.name,
            itemLabel: itemName,
            message: '$stage：$error',
            albumId: sourceKey,
            assetId: asset.id,
            localPath: sourceItemPath,
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
      issues: issues,
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
    String albumName,
    AssetEntity asset,
  ) {
    return filepath.posix.joinAll([
      targetPath,
      ...AlbumBackupService.layoutPathParts(
        layout: layout,
        createdAt: asset.createDateTime,
        albumName: albumName,
        isAndroid: Util.isAndroid,
        relativePath: asset.relativePath,
      ),
    ]);
  }

  Future<_AlbumBackupTarget> _prepareTarget(
    String targetPath,
    AlbumTargetLayout layout,
    String albumName,
    AssetEntity asset,
    io.File file,
    SyncTargetDirectory targetStore,
    String original,
  ) async {
    final sourceName =
        original.isEmpty ? filepath.basename(file.path) : original;
    var path = targetPath;
    final parts = AlbumBackupService.layoutPathParts(
      layout: layout,
      createdAt: asset.createDateTime,
      albumName: albumName,
      isAndroid: Util.isAndroid,
      relativePath: asset.relativePath,
    );
    for (final part in parts) {
      final nextPath = filepath.posix.join(path, part);
      await targetStore.ensure(nextPath);
      path = nextPath;
    }
    return _AlbumBackupTarget(
      path,
      AlbumBackupService.filename(sourceName),
    );
  }
}

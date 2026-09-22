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

class AlbumBackupService {
  static AlbumBackupService get instance => _instance;
  static final AlbumBackupService _instance = AlbumBackupService._internal();

  factory AlbumBackupService() => _instance;

  AlbumBackupService._internal();

  static String filename(String originalName) {
    return filepath.posix.basename(originalName.replaceAll('\\', '/'));
  }

  static String _safePathComponent(String value) {
    final result =
        value.replaceAll(RegExp(r'[/\\:*?"<>|\x00-\x1F]'), '_').trim();
    return result.isEmpty ? '未命名相册' : result;
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

  static SyncHistory buildHistory({
    required int profileId,
    required String runId,
    required DateTime startedAt,
    required DateTime finishedAt,
    required SyncRunProgress progress,
    SyncException? error,
  }) {
    return SyncHistory(
      profileId: profileId,
      runId: runId,
      startedAt: Timestamp.fromDateTime(startedAt),
      finishedAt: Timestamp.fromDateTime(finishedAt),
      status: error != null
          ? SyncHistory_Status.STATUS_FAILED
          : progress.issues.isNotEmpty
              ? SyncHistory_Status.STATUS_PARTIAL
              : SyncHistory_Status.STATUS_SUCCEEDED,
      trigger: SyncHistory_Trigger.TRIGGER_MANUAL,
      scanned: progress.scanned,
      synced: progress.synced,
      skipped: progress.skipped,
      failed: progress.failed,
      conflicted: progress.conflicted,
      errorSummary: error?.message ?? '',
      issues: progress.issues,
    );
  }

  Future<SyncHistory> run(AlbumBackupProfile profile) async {
    final startedAt = DateTime.now();
    final runId = await SyncHistoryStore.start(profile.id, startedAt);
    final progress = SyncRunProgress();
    SyncException? failure;
    try {
      await _run(profile, progress);
    } catch (error) {
      failure = SyncErrorClassifier.classify(
        error,
        fallbackCode: SyncErrorCode.internalItemError,
        operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
      );
      progress.addRunFailure(failure);
    }
    final history = AlbumBackupService.buildHistory(
      profileId: profile.id,
      runId: runId,
      startedAt: startedAt,
      finishedAt: DateTime.now(),
      progress: progress,
      error: failure,
    );
    return SyncHistoryStore.finish(history);
  }

  Future<void> _run(
    AlbumBackupProfile profile,
    SyncRunProgress progress,
  ) async {
    if (profile.targetConfig.path.isEmpty) {
      throw const SyncException(
        code: SyncErrorCode.targetConfigInvalid,
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
        message: '备份目录配置无效',
      );
    }
    final targetPath = AlbumBackupService.targetPath(
      profile.targetConfig,
      await AlbumBackupService.deviceModel(),
    );
    final targetDirectory = SyncTargetDirectory();
    await targetDirectory.ensure(targetPath);
    List<AssetPathEntity> albums;
    try {
      albums = await requestAlbums(includeEmpty: true);
    } catch (error) {
      if (error is SyncException) rethrow;
      throw SyncException(
        code: SyncErrorCode.sourceRootUnreadable,
        operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        message: '无法读取系统相册：$error',
        cause: error,
      );
    }
    final paths = {for (final album in albums) album.id: album};
    final verifiedAssets = <String, SyncRecord>{};
    for (final sourceKey in profile.sourceConfig.albumIds) {
      final album = paths[sourceKey];
      if (album == null) {
        progress.issues.add(_issue(
          albumLabel: sourceKey,
          itemLabel: sourceKey,
          message: '相册不可访问或已删除',
          albumId: sourceKey,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
          errorCode: SyncErrorCode.sourceUnavailable,
        ));
        continue;
      }
      try {
        await _runAlbumBackup(
          profile,
          sourceKey,
          album,
          targetPath,
          profile.targetConfig.layout,
          targetDirectory,
          verifiedAssets,
          progress,
        );
      } catch (error) {
        final failure = SyncErrorClassifier.classify(
          error,
          fallbackCode: SyncErrorCode.sourceScanFailed,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        );
        if (failure.scope == SyncErrorScope.run) rethrow;
        progress.issues.add(_issue(
          albumLabel: album.name,
          itemLabel: '',
          message: failure.message,
          albumId: sourceKey,
          operation: failure.operation,
          errorCode: failure.code,
        ));
      }
    }
  }

  Future<List<AssetPathEntity>> requestAlbums(
      {bool includeEmpty = false}) async {
    final state = await PhotoManager.requestPermissionExtend();
    if (!state.hasAccess) {
      throw const SyncException(
        code: SyncErrorCode.sourcePermissionDenied,
        operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        message: '请在系统设置中允许访问照片和视频',
      );
    }
    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.common,
    );
    if (includeEmpty) return albums;
    final counts =
        await Future.wait(albums.map((album) => album.assetCountAsync));
    return [
      for (var index = 0; index < albums.length; index++)
        if (counts[index] > 0) albums[index],
    ];
  }

  Future<void> _runAlbumBackup(
    AlbumBackupProfile profile,
    String sourceKey,
    AssetPathEntity album,
    String targetPath,
    AlbumTargetLayout layout,
    SyncTargetDirectory targetStore,
    Map<String, SyncRecord> verifiedAssets,
    SyncRunProgress progress,
  ) async {
    for (var page = 0;; page++) {
      List<AssetEntity> assets;
      try {
        assets = await album.getAssetListPaged(page: page, size: 100);
      } catch (error) {
        final failure = SyncErrorClassifier.classify(
          error,
          fallbackCode: SyncErrorCode.sourceScanFailed,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        );
        if (failure.scope == SyncErrorScope.run) rethrow;
        progress.issues.add(_issue(
          albumLabel: album.name,
          itemLabel: '',
          message: '读取相册失败：${failure.message}',
          albumId: sourceKey,
          operation: failure.operation,
          errorCode: failure.code,
        ));
        break;
      }
      if (assets.isEmpty) break;
      progress.scanned += assets.length;
      final recorded = await SyncErrorClassifier.execute(
        action: () => _listRecorded(
          profile.id,
          sourceKey,
          assets.map((asset) => asset.id),
        ),
        fallbackCode: SyncErrorCode.recordReadFailed,
        unavailableCode: SyncErrorCode.syncServiceUnavailable,
        timeoutCode: SyncErrorCode.syncServiceUnavailable,
        operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
      );
      for (final asset in assets) {
        var itemName = asset.id;
        var stage = '检查备份记录';
        var targetItemPath = '';
        var sourceItemPath = '';
        var fallbackCode = SyncErrorCode.sourceUnreadable;
        var operation = SyncHistoryIssue_Operation.OPERATION_SCAN;
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
            progress.skipped++;
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
            fallbackCode = SyncErrorCode.targetAccessFailed;
            operation = SyncHistoryIssue_Operation.OPERATION_VERIFY;
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
              progress.skipped++;
              continue;
            }
          }
          stage = '读取相册文件';
          final file = await asset.originFile;
          if (file == null) {
            progress.issues.add(_issue(
              albumLabel: album.name,
              itemLabel: itemName,
              message: '无法读取原始文件',
              albumId: sourceKey,
              assetId: asset.id,
              operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
              errorCode: SyncErrorCode.sourceUnreadable,
            ));
            continue;
          }
          if (!await file.exists()) {
            progress.issues.add(_issue(
              albumLabel: album.name,
              itemLabel: itemName,
              message: '本地照片文件不存在：${file.path}',
              albumId: sourceKey,
              assetId: asset.id,
              localPath: file.path,
              operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
              errorCode: SyncErrorCode.sourceMissing,
            ));
            continue;
          }
          sourceItemPath = file.path;
          final sourceStat = await file.stat();
          stage = '准备云端目录';
          fallbackCode = SyncErrorCode.targetAccessFailed;
          operation = SyncHistoryIssue_Operation.OPERATION_VERIFY;
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
          fallbackCode = SyncErrorCode.uploadFailed;
          operation = SyncHistoryIssue_Operation.OPERATION_UPLOAD;
          final (uploadedFile, hashAlgorithm, sourceHash) =
              await SyncErrorClassifier.execute(
            action: () => FileService.instance.uploadFilePreservingName(
              uploadTarget.directory,
              file,
              uploadTarget.name,
              showError: false,
            ),
            fallbackCode: SyncErrorCode.uploadFailed,
            operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
          );
          fallbackCode = SyncErrorCode.sourceChangedDuringUpload;
          if (!await file.exists()) {
            throw const SyncException(
              code: SyncErrorCode.sourceMissing,
              operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
              message: '上传期间本地照片文件消失',
            );
          }
          final finalStat = await file.stat();
          if (finalStat.size != sourceStat.size ||
              finalStat.modified != sourceStat.modified) {
            throw const SyncException(
              code: SyncErrorCode.sourceChangedDuringUpload,
              operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
              message: '上传期间本地照片文件发生变化',
            );
          }
          final uploadedPath = filepath.posix.normalize(
            filepath.posix.join(uploadedFile.path, uploadedFile.name),
          );
          if (uploadedFile.name != uploadTarget.name ||
              uploadedFile.size.toInt() != sourceStat.size ||
              uploadedPath != targetItemPath) {
            throw const SyncException(
              code: SyncErrorCode.uploadResultMismatch,
              operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
              message: '云端返回的文件信息与备份目标不一致',
            );
          }
          final uploadedRecord = SyncRecord(
            profileId: profile.id,
            sourcePath: sourceKey,
            sourceKey: asset.id,
            configVersion: fixnum.Int64(profile.configVersion),
            targetPath: uploadedPath,
            sourceSize: fixnum.Int64(sourceStat.size),
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
          fallbackCode = SyncErrorCode.recordWriteFailed;
          await SyncErrorClassifier.execute(
            action: () => SyncingService.instance.upsertRecords([
              uploadedRecord,
            ]),
            fallbackCode: SyncErrorCode.recordWriteFailed,
            unavailableCode: SyncErrorCode.syncServiceUnavailable,
            timeoutCode: SyncErrorCode.syncServiceUnavailable,
            operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
          );
          verifiedAssets[verifiedKey] = uploadedRecord;
          targetStore.record(uploadTarget.directory, uploadedFile);
          progress.synced++;
        } catch (error) {
          final failure = SyncErrorClassifier.classify(
            error,
            fallbackCode: fallbackCode,
            operation: operation,
          );
          if (failure.scope == SyncErrorScope.run) rethrow;
          if (failure.scope == SyncErrorScope.source) {
            progress.issues.add(_issue(
              albumLabel: album.name,
              itemLabel: '',
              message: failure.message,
              albumId: sourceKey,
              operation: failure.operation,
              errorCode: failure.code,
            ));
            return;
          }
          progress.issues.add(_issue(
            albumLabel: album.name,
            itemLabel: itemName,
            message: '$stage：${failure.message}',
            albumId: sourceKey,
            assetId: asset.id,
            localPath: sourceItemPath,
            targetPath: targetItemPath,
            operation: failure.operation,
            errorCode: failure.code,
          ));
        }
      }
      if (assets.length < 100) break;
    }
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

  SyncHistoryIssue _issue({
    required String albumLabel,
    required String itemLabel,
    required String message,
    String albumId = '',
    String assetId = '',
    String localPath = '',
    String targetPath = '',
    SyncHistoryIssue_Operation operation =
        SyncHistoryIssue_Operation.OPERATION_UPLOAD,
    required SyncErrorCode errorCode,
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
      errorCode: errorCode.value,
      kind: errorCode.conflict
          ? SyncHistoryIssue_Kind.KIND_CONFLICT
          : SyncHistoryIssue_Kind.KIND_ERROR,
      errorMessage: message,
      context: context.isEmpty ? '' : jsonEncode(context),
    );
  }
}

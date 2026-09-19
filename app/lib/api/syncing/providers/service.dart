import 'dart:convert';
import 'dart:io' as io;

import 'package:grpc/grpc.dart';
import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:path/path.dart' as filepath;
import 'package:photo_manager/photo_manager.dart';

import 'package:maple_file/api/file/providers/service.dart';
import 'package:maple_file/api/syncing/providers/album_backup_run.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pbgrpc.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

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

class SyncingService {
  static SyncingService get instance => _instance;
  static final SyncingService _instance = SyncingService._internal();
  factory SyncingService() => _instance;
  SyncingService._internal();

  SyncServiceClient? _client;
  DateTime _clientTime = DateTime.now();

  SyncServiceClient get client {
    if (_client == null || Grpc.instance.connectTime.isAfter(_clientTime)) {
      _client = SyncServiceClient(
        Grpc.instance.client,
        options: CallOptions(metadata: Grpc.instance.metadata),
      );
      _clientTime = Grpc.instance.connectTime;
    }
    return _client!;
  }

  Future<List<SyncProfile>> listProfiles() => doFuture(() async {
        final response = await client.listProfiles(SyncProfile_ListRequest());
        return response.results;
      });

  Future<SyncProfile> createProfile(SyncProfile profile) => doFuture(() async {
        final response = await client.createProfile(
          SyncProfile_CreateRequest(payload: profile),
        );
        return response.result;
      });

  Future<SyncProfile> updateProfile(SyncProfile profile) => doFuture(() async {
        final response = await client.updateProfile(
          SyncProfile_UpdateRequest(payload: profile),
        );
        return response.result;
      });

  Future<void> deleteProfile(int id) => doFuture(() async {
        await client.deleteProfile(SyncProfile_DeleteRequest(id: id));
      });

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

  Future<AlbumBackupResult> runAlbumBackup(SyncProfile profile) async {
    if (!profile.enabled) {
      throw StateError('请先启用此相册备份');
    }
    if (profile.sourceType != 'album' ||
        profile.mode != SyncProfile_Mode.MODE_BACKUP ||
        profile.targetType != 'repo_directory') {
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
          target['layout'] as String? ?? 'year_month_day',
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
    String layout,
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
          await doFuture(() => client.upsertRecords(
                SyncRecord_UpsertRequest(results: [uploadedRecord]),
              ));
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
          int profileId, String albumId, Iterable<String> assetIds) =>
      doFuture(() async {
        final response = await client.listRecords(
          SyncRecord_ListRequest(
            profileId: profileId,
            sourcePath: albumId,
            sourceKeys: assetIds,
          ),
        );
        return {
          for (final record in response.results) record.sourceKey: record,
        };
      });

  String _destinationPath(String targetPath, String layout, AssetEntity asset) {
    if (layout != 'year_month_day') return targetPath;
    final date = asset.createDateTime;
    return filepath.posix.join(
      targetPath,
      date.year.toString().padLeft(4, '0'),
      date.month.toString().padLeft(2, '0'),
      date.day.toString().padLeft(2, '0'),
    );
  }

  Future<_BackupDestination> _destination(
    String targetPath,
    String layout,
    AssetEntity asset,
    io.File file,
    Set<String> createdDirectories,
    String original,
  ) async {
    final sourceName =
        original.isEmpty ? filepath.basename(file.path) : original;
    var path = targetPath;
    if (layout == 'year_month_day') {
      final date = asset.createDateTime;
      for (final part in [
        date.year.toString().padLeft(4, '0'),
        date.month.toString().padLeft(2, '0'),
        date.day.toString().padLeft(2, '0'),
      ]) {
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

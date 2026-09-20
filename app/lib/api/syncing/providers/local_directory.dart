import 'dart:convert';
import 'dart:io' as io;

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:path/path.dart' as filepath;
import 'package:permission_handler/permission_handler.dart';

import 'package:maple_file/api/file/providers/service.dart';
import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/api/syncing/providers/target.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart' as file_proto;
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

part 'local_directory.freezed.dart';
part 'local_directory.g.dart';

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
        enabled: true,
        mode: SyncProfile_Mode.MODE_ONE_WAY,
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

enum LocalDirectorySyncDecision {
  upload,
  skip,
  conflictWithoutBaseline,
  conflictModified
}

({List<io.Directory> directories, List<io.File> files})
    localDirectoryScanEntries(Iterable<io.FileSystemEntity> entries) {
  return (
    directories: entries.whereType<io.Directory>().toList(),
    files: entries.whereType<io.File>().toList(),
  );
}

String localDirectoryTargetPath({
  required String sourceRoot,
  required String sourceFile,
  required String targetRoot,
}) {
  final relative = filepath.relative(sourceFile, from: sourceRoot);
  if (relative == '..' ||
      relative.startsWith('..${filepath.separator}') ||
      filepath.isAbsolute(relative)) {
    throw StateError('本地文件超出同步目录：$sourceFile');
  }
  return filepath.posix.joinAll([
    targetRoot,
    ...filepath.split(relative),
  ]);
}

LocalDirectorySyncDecision localDirectorySyncDecision({
  required SyncRecord? record,
  required io.FileStat source,
  required String targetPath,
  required file_proto.File? target,
  required int configVersion,
}) {
  if (record == null ||
      record.state != SyncRecord_State.STATE_ACTIVE ||
      record.configVersion.toInt() != configVersion ||
      record.targetPath != targetPath) {
    return target == null
        ? LocalDirectorySyncDecision.upload
        : LocalDirectorySyncDecision.conflictWithoutBaseline;
  }
  if (target == null) return LocalDirectorySyncDecision.upload;
  if (!_targetMatches(record, target)) {
    return LocalDirectorySyncDecision.conflictModified;
  }
  return _sourceMatches(record, source)
      ? LocalDirectorySyncDecision.skip
      : LocalDirectorySyncDecision.upload;
}

bool _sourceMatches(SyncRecord record, io.FileStat source) {
  return record.hasSourceSize() &&
      record.sourceSize.toInt() == source.size &&
      record.hasSourceModifiedAt() &&
      record.sourceModifiedAt.toDateTime().millisecondsSinceEpoch ==
          source.modified.millisecondsSinceEpoch;
}

bool _targetMatches(SyncRecord record, file_proto.File target) {
  if (target.type == 'DIR') return false;
  if (!record.hasTargetSize() || record.targetSize != target.size) return false;
  if (record.targetHash.isNotEmpty &&
      target.hash.isNotEmpty &&
      record.targetHash != target.hash) {
    return false;
  }
  if (record.hasTargetModifiedAt() && target.hasUpdatedAt()) {
    return record.targetModifiedAt.toDateTime().millisecondsSinceEpoch ==
        target.updatedAt.toDateTime().millisecondsSinceEpoch;
  }
  return true;
}

class LocalDirectorySyncResult {
  const LocalDirectorySyncResult({
    required this.scanned,
    required this.synced,
    required this.skipped,
    required this.issues,
  });

  final int scanned;
  final int synced;
  final int skipped;
  final List<SyncHistoryIssue> issues;

  int get failed => issues
      .where((issue) => issue.kind == SyncHistoryIssue_Kind.KIND_ERROR)
      .length;
  int get conflicted => issues
      .where((issue) => issue.kind == SyncHistoryIssue_Kind.KIND_CONFLICT)
      .length;
}

class LocalDirectorySyncService {
  static final LocalDirectorySyncService instance =
      LocalDirectorySyncService._internal();

  LocalDirectorySyncService._internal();

  Future<SyncHistory> run(LocalDirectorySyncProfile profile) async {
    final startedAt = DateTime.now();
    final runId = await SyncHistoryStore.start(profile.id, startedAt);
    LocalDirectorySyncResult? result;
    String? errorMessage;
    try {
      result = await _run(profile);
    } catch (error) {
      errorMessage = '$error';
    }
    final issues = result?.issues ?? const <SyncHistoryIssue>[];
    return SyncHistoryStore.finish(
      SyncHistory(
        profileId: profile.id,
        runId: runId,
        configVersion: fixnum.Int64(profile.configVersion),
        startedAt: Timestamp.fromDateTime(startedAt),
        finishedAt: Timestamp.fromDateTime(DateTime.now()),
        status: errorMessage != null
            ? SyncHistory_Status.STATUS_FAILED
            : issues.isNotEmpty
                ? SyncHistory_Status.STATUS_PARTIAL
                : SyncHistory_Status.STATUS_SUCCEEDED,
        trigger: SyncHistory_Trigger.TRIGGER_MANUAL,
        scanned: result?.scanned ?? 0,
        synced: result?.synced ?? 0,
        skipped: result?.skipped ?? 0,
        failed: (result?.failed ?? 0) + (errorMessage == null ? 0 : 1),
        conflicted: result?.conflicted ?? 0,
        errorSummary: errorMessage ?? '',
        issues: issues,
      ),
    );
  }

  Future<LocalDirectorySyncResult> _run(
    LocalDirectorySyncProfile profile,
  ) async {
    if (!isLocalDirectorySyncSupported) {
      throw UnsupportedError('当前平台不支持本地目录同步');
    }
    if (Util.isAndroid) {
      final permission = await Permission.manageExternalStorage.request();
      if (!permission.isGranted) {
        throw StateError('需要“所有文件访问权限”才能读取本地目录');
      }
    }
    await SyncTargetRepository.requireRemote(profile.targetConfig.path);

    SecureBookmarks? bookmarks;
    io.Directory? securedDirectory;
    var accessingSecurityScopedResource = false;
    var sourcePath =
        filepath.normalize(filepath.absolute(profile.sourceConfig.path));
    try {
      if (Util.isMacOS) {
        if (profile.sourceConfig.bookmark.isEmpty) {
          throw StateError('本地目录授权已失效，请重新选择目录');
        }
        bookmarks = SecureBookmarks();
        securedDirectory = await bookmarks.resolveBookmark(
          profile.sourceConfig.bookmark,
          isDirectory: true,
        ) as io.Directory;
        final resolvedPath =
            filepath.normalize(filepath.absolute(securedDirectory.path));
        if (resolvedPath != sourcePath) {
          throw StateError('本地目录授权与当前配置不一致，请重新选择目录');
        }
        await bookmarks.startAccessingSecurityScopedResource(securedDirectory);
        accessingSecurityScopedResource = true;
        sourcePath = resolvedPath;
      }
      final source = io.Directory(sourcePath);
      if (!await source.exists()) throw StateError('本地来源目录不存在');
      await source.list(followLinks: false).take(1).drain<void>();
      final targetStore = SyncTargetDirectory();
      await targetStore.ensure(profile.targetConfig.path);
      return _scanDirectory(profile, source, sourcePath, targetStore);
    } on io.FileSystemException catch (error) {
      throw StateError('无法访问本地来源目录：${error.message}');
    } finally {
      if (bookmarks != null &&
          securedDirectory != null &&
          accessingSecurityScopedResource) {
        await bookmarks.stopAccessingSecurityScopedResource(securedDirectory);
      }
    }
  }

  Future<LocalDirectorySyncResult> _scanDirectory(
    LocalDirectorySyncProfile profile,
    io.Directory root,
    String sourceRoot,
    SyncTargetDirectory targetStore,
  ) async {
    var scanned = 0;
    var synced = 0;
    var skipped = 0;
    final issues = <SyncHistoryIssue>[];
    final directories = <io.Directory>[root];
    while (directories.isNotEmpty) {
      final directory = directories.removeLast();
      List<io.File> files;
      try {
        final entries = await directory.list(followLinks: false).toList();
        final scanEntries = localDirectoryScanEntries(entries);
        directories.addAll(scanEntries.directories);
        files = scanEntries.files;
      } catch (error) {
        issues.add(_errorIssue(
          sourceRoot: sourceRoot,
          sourceFile: directory.path,
          message: '读取目录失败：$error',
          code: 'source_scan_failed',
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        ));
        continue;
      }
      scanned += files.length;
      final parent = filepath.normalize(filepath.absolute(directory.path));
      Map<String, SyncRecord> records;
      try {
        final results = await SyncingService.instance.listRecords(
          SyncRecord_ListRequest(
            profileId: profile.id,
            sourcePath: parent,
            sourceKeys: files.map((file) => filepath.basename(file.path)),
          ),
        );
        records = {for (final record in results) record.sourceKey: record};
      } catch (error) {
        for (final file in files) {
          issues.add(_errorIssue(
            sourceRoot: sourceRoot,
            sourceFile: file.path,
            message: '查询同步记录失败：$error',
            code: 'record_read_failed',
            operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
          ));
        }
        continue;
      }
      for (final file in files) {
        final name = filepath.basename(file.path);
        final targetPath = localDirectoryTargetPath(
          sourceRoot: sourceRoot,
          sourceFile: file.path,
          targetRoot: profile.targetConfig.path,
        );
        final targetDirectory = filepath.posix.dirname(targetPath);
        try {
          final sourceStat = await file.stat();
          final targetEntries = await targetStore.ensure(targetDirectory);
          final target = targetStore.find(targetEntries, name);
          final decision = localDirectorySyncDecision(
            record: records[name],
            source: sourceStat,
            targetPath: targetPath,
            target: target,
            configVersion: profile.configVersion,
          );
          if (decision == LocalDirectorySyncDecision.skip) {
            skipped++;
            continue;
          }
          if (decision == LocalDirectorySyncDecision.conflictWithoutBaseline ||
              decision == LocalDirectorySyncDecision.conflictModified) {
            issues.add(_conflictIssue(
              sourceRoot: sourceRoot,
              sourceFile: file.path,
              targetPath: targetPath,
              code:
                  decision == LocalDirectorySyncDecision.conflictWithoutBaseline
                      ? 'target_exists_without_baseline'
                      : 'target_modified',
            ));
            continue;
          }
          final (uploaded, hashAlgorithm, sourceHash) = await FileService
              .instance
              .uploadFilePreservingName(targetDirectory, file, name);
          final finalStat = await file.stat();
          if (finalStat.size != sourceStat.size ||
              finalStat.modified != sourceStat.modified) {
            throw StateError('上传期间本地文件发生变化');
          }
          final uploadedPath = filepath.posix.normalize(
            filepath.posix.join(uploaded.path, uploaded.name),
          );
          if (uploaded.name != name ||
              uploaded.size.toInt() != sourceStat.size ||
              uploadedPath != targetPath) {
            throw StateError('云端返回的文件信息与同步目标不一致');
          }
          await SyncingService.instance.upsertRecords([
            SyncRecord(
              profileId: profile.id,
              state: SyncRecord_State.STATE_ACTIVE,
              configVersion: fixnum.Int64(profile.configVersion),
              sourcePath: parent,
              sourceKey: name,
              sourceSize: fixnum.Int64(sourceStat.size),
              sourceHash: sourceHash,
              sourceHashAlgorithm: hashAlgorithm,
              sourceModifiedAt: Timestamp.fromDateTime(sourceStat.modified),
              targetPath: uploadedPath,
              targetSize: uploaded.size,
              targetHash: uploaded.hash,
              targetModifiedAt:
                  uploaded.hasUpdatedAt() ? uploaded.updatedAt : null,
              syncedAt: Timestamp.fromDateTime(DateTime.now()),
            ),
          ]);
          targetStore.record(targetDirectory, uploaded);
          synced++;
        } catch (error) {
          issues.add(_errorIssue(
            sourceRoot: sourceRoot,
            sourceFile: file.path,
            targetPath: targetPath,
            message: '$error',
            code: 'sync_failed',
            operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
          ));
        }
      }
    }
    return LocalDirectorySyncResult(
      scanned: scanned,
      synced: synced,
      skipped: skipped,
      issues: issues,
    );
  }

  SyncHistoryIssue _errorIssue({
    required String sourceRoot,
    required String sourceFile,
    required String message,
    required String code,
    required SyncHistoryIssue_Operation operation,
    String targetPath = '',
  }) {
    return _issue(
      sourceRoot: sourceRoot,
      sourceFile: sourceFile,
      targetPath: targetPath,
      message: message,
      code: code,
      operation: operation,
      kind: SyncHistoryIssue_Kind.KIND_ERROR,
    );
  }

  SyncHistoryIssue _conflictIssue({
    required String sourceRoot,
    required String sourceFile,
    required String targetPath,
    required String code,
  }) {
    return _issue(
      sourceRoot: sourceRoot,
      sourceFile: sourceFile,
      targetPath: targetPath,
      message: code == 'target_modified' ? '云端文件已被修改' : '云端存在同名文件',
      code: code,
      operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
      kind: SyncHistoryIssue_Kind.KIND_CONFLICT,
    );
  }

  SyncHistoryIssue _issue({
    required String sourceRoot,
    required String sourceFile,
    required String targetPath,
    required String message,
    required String code,
    required SyncHistoryIssue_Operation operation,
    required SyncHistoryIssue_Kind kind,
  }) {
    final relative = filepath.relative(sourceFile, from: sourceRoot);
    return SyncHistoryIssue(
      sourcePath: filepath.normalize(
        filepath.absolute(filepath.dirname(sourceFile)),
      ),
      sourceKey: filepath.basename(sourceFile),
      sourceLabel: relative == '.' ? filepath.basename(sourceFile) : relative,
      targetPath: targetPath,
      errorCode: code,
      errorMessage: message,
      errorOperation: operation,
      kind: kind,
    );
  }
}

bool get isLocalDirectorySyncSupported =>
    SyncSourceType.localDirectory.isSupported;

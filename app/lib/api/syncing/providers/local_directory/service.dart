import 'dart:io' as io;

import 'package:fixnum/fixnum.dart' as fixnum;
import 'package:macos_secure_bookmarks/macos_secure_bookmarks.dart';
import 'package:path/path.dart' as filepath;
import 'package:permission_handler/permission_handler.dart';

import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart' as filepb;
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';
import 'package:maple_file/generated/proto/google/protobuf/timestamp.pb.dart';

import 'package:maple_file/api/file/providers/service.dart';
import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/providers/service.dart';

import 'profile.dart';

enum LocalDirectorySyncDecision {
  upload,
  skip,
  conflictWithoutBaseline,
  conflictModified
}

class LocalDirectorySyncService {
  static LocalDirectorySyncService get instance => _instance;
  static final LocalDirectorySyncService _instance =
      LocalDirectorySyncService._internal();

  factory LocalDirectorySyncService() => _instance;

  LocalDirectorySyncService._internal();

  static ({List<io.Directory> directories, List<io.File> files}) scanEntries(
    Iterable<io.FileSystemEntity> entries,
  ) {
    return (
      directories: entries.whereType<io.Directory>().toList(),
      files: entries.whereType<io.File>().toList(),
    );
  }

  static String targetPath({
    required String sourceRoot,
    required String sourceFile,
    required String targetRoot,
  }) {
    final relative = filepath.relative(sourceFile, from: sourceRoot);
    if (relative == '..' ||
        relative.startsWith('..${filepath.separator}') ||
        filepath.isAbsolute(relative)) {
      throw SyncException(
        code: SyncErrorCode.sourceOutsideRoot,
        operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        message: '本地文件超出同步目录：$sourceFile',
      );
    }
    return filepath.posix.joinAll([
      targetRoot,
      ...filepath.split(relative),
    ]);
  }

  static LocalDirectorySyncDecision decide({
    required SyncRecord? record,
    required io.FileStat source,
    required String targetPath,
    required filepb.File? target,
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

  static bool _sourceMatches(SyncRecord record, io.FileStat source) {
    return record.hasSourceSize() &&
        record.sourceSize.toInt() == source.size &&
        record.hasSourceModifiedAt() &&
        record.sourceModifiedAt.toDateTime().millisecondsSinceEpoch ==
            source.modified.millisecondsSinceEpoch;
  }

  static bool _targetMatches(SyncRecord record, filepb.File target) {
    if (target.type == 'DIR') return false;
    if (!record.hasTargetSize() || record.targetSize != target.size) {
      return false;
    }
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

  Future<SyncHistory> run(LocalDirectorySyncProfile profile) async {
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
    return SyncHistoryStore.finish(
      SyncHistory(
        profileId: profile.id,
        runId: runId,
        configVersion: fixnum.Int64(profile.configVersion),
        startedAt: Timestamp.fromDateTime(startedAt),
        finishedAt: Timestamp.fromDateTime(DateTime.now()),
        status: failure != null
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
        errorSummary: failure?.message ?? '',
        issues: progress.issues,
      ),
    );
  }

  Future<void> _run(
    LocalDirectorySyncProfile profile,
    SyncRunProgress progress,
  ) async {
    if (!SyncSourceType.localDirectory.isSupported) {
      throw const SyncException(
        code: SyncErrorCode.unsupportedPlatform,
        operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        message: '当前平台不支持本地目录同步',
      );
    }
    if (profile.sourceConfig.path.trim().isEmpty) {
      throw const SyncException(
        code: SyncErrorCode.sourceRootMissing,
        operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        message: '本地来源目录未配置',
      );
    }
    if (profile.targetConfig.path.trim().isEmpty) {
      throw const SyncException(
        code: SyncErrorCode.targetConfigInvalid,
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
        message: '同步目标目录未配置',
      );
    }
    if (Util.isAndroid) {
      late final PermissionStatus permission;
      try {
        permission = await Permission.manageExternalStorage.request();
      } catch (error) {
        throw SyncException(
          code: SyncErrorCode.sourcePermissionDenied,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
          message: '无法确认本地目录访问权限',
          cause: error,
        );
      }
      if (!permission.isGranted) {
        throw const SyncException(
          code: SyncErrorCode.sourcePermissionDenied,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
          message: '需要“所有文件访问权限”才能读取本地目录',
        );
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
          throw const SyncException(
            code: SyncErrorCode.sourceAuthorizationInvalid,
            operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
            message: '本地目录授权已失效，请重新选择目录',
          );
        }
        bookmarks = SecureBookmarks();
        try {
          securedDirectory = await bookmarks.resolveBookmark(
            profile.sourceConfig.bookmark,
            isDirectory: true,
          ) as io.Directory;
        } catch (error) {
          throw SyncException(
            code: SyncErrorCode.sourceAuthorizationInvalid,
            operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
            message: '本地目录授权已失效，请重新选择目录',
            cause: error,
          );
        }
        final resolvedPath =
            filepath.normalize(filepath.absolute(securedDirectory.path));
        if (resolvedPath != sourcePath) {
          throw const SyncException(
            code: SyncErrorCode.sourceAuthorizationMismatch,
            operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
            message: '本地目录授权与当前配置不一致，请重新选择目录',
          );
        }
        try {
          await bookmarks.startAccessingSecurityScopedResource(
            securedDirectory,
          );
        } catch (error) {
          throw SyncException(
            code: SyncErrorCode.sourceAuthorizationInvalid,
            operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
            message: '无法使用本地目录授权，请重新选择目录',
            cause: error,
          );
        }
        accessingSecurityScopedResource = true;
        sourcePath = resolvedPath;
      }
      final source = io.Directory(sourcePath);
      if (!await source.exists()) {
        throw const SyncException(
          code: SyncErrorCode.sourceRootMissing,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
          message: '本地来源目录不存在',
        );
      }
      await source.list(followLinks: false).take(1).drain<void>();
      final targetStore = SyncTargetDirectory();
      await targetStore.ensure(profile.targetConfig.path);
      await _scanDirectory(
        profile,
        source,
        sourcePath,
        targetStore,
        progress,
      );
    } on io.FileSystemException catch (error) {
      throw SyncException(
        code: SyncErrorCode.sourceRootUnreadable,
        operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        message: '无法访问本地来源目录：${error.message}',
        cause: error,
      );
    } finally {
      if (bookmarks != null &&
          securedDirectory != null &&
          accessingSecurityScopedResource) {
        try {
          await bookmarks.stopAccessingSecurityScopedResource(
            securedDirectory,
          );
        } catch (_) {
          // Access has already ended with this run; cleanup failure must not
          // replace the synchronization result.
        }
      }
    }
  }

  Future<void> _scanDirectory(
    LocalDirectorySyncProfile profile,
    io.Directory root,
    String sourceRoot,
    SyncTargetDirectory targetStore,
    SyncRunProgress progress,
  ) async {
    final directories = <io.Directory>[root];
    while (directories.isNotEmpty) {
      final directory = directories.removeLast();
      List<io.File> files;
      try {
        final entries = await directory.list(followLinks: false).toList();
        final scanEntries = LocalDirectorySyncService.scanEntries(entries);
        directories.addAll(scanEntries.directories);
        files = scanEntries.files;
      } catch (error) {
        progress.issues.add(_sourceIssue(
          sourceRoot: sourceRoot,
          sourcePath: directory.path,
          message: '读取目录失败：$error',
          code: SyncErrorCode.sourceScanFailed,
          operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
        ));
        continue;
      }
      progress.scanned += files.length;
      final parent = filepath.normalize(filepath.absolute(directory.path));
      final results = await SyncErrorClassifier.execute(
        action: () => SyncingService.instance.listRecords(
          SyncRecord_ListRequest(
            profileId: profile.id,
            sourcePath: parent,
            sourceKeys: files.map((file) => filepath.basename(file.path)),
          ),
        ),
        fallbackCode: SyncErrorCode.recordReadFailed,
        unavailableCode: SyncErrorCode.syncServiceUnavailable,
        timeoutCode: SyncErrorCode.syncServiceUnavailable,
        operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
      );
      final records = {for (final record in results) record.sourceKey: record};
      for (final file in files) {
        final name = filepath.basename(file.path);
        var targetPath = '';
        var operation = SyncHistoryIssue_Operation.OPERATION_SCAN;
        var fallbackCode = SyncErrorCode.sourceUnreadable;
        try {
          targetPath = LocalDirectorySyncService.targetPath(
            sourceRoot: sourceRoot,
            sourceFile: file.path,
            targetRoot: profile.targetConfig.path,
          );
          final targetDirectory = filepath.posix.dirname(targetPath);
          if (!await file.exists()) {
            throw const SyncException(
              code: SyncErrorCode.sourceMissing,
              operation: SyncHistoryIssue_Operation.OPERATION_SCAN,
              message: '本地文件不存在',
            );
          }
          final sourceStat = await file.stat();
          operation = SyncHistoryIssue_Operation.OPERATION_VERIFY;
          fallbackCode = SyncErrorCode.targetAccessFailed;
          final targetEntries = await targetStore.ensure(targetDirectory);
          final target = targetStore.find(targetEntries, name);
          final decision = LocalDirectorySyncService.decide(
            record: records[name],
            source: sourceStat,
            targetPath: targetPath,
            target: target,
            configVersion: profile.configVersion,
          );
          if (decision == LocalDirectorySyncDecision.skip) {
            progress.skipped++;
            continue;
          }
          if (decision == LocalDirectorySyncDecision.conflictWithoutBaseline ||
              decision == LocalDirectorySyncDecision.conflictModified) {
            progress.issues.add(_conflictIssue(
              sourceRoot: sourceRoot,
              sourceFile: file.path,
              targetPath: targetPath,
              code:
                  decision == LocalDirectorySyncDecision.conflictWithoutBaseline
                      ? SyncErrorCode.targetExistsWithoutBaseline
                      : SyncErrorCode.targetModified,
            ));
            continue;
          }
          operation = SyncHistoryIssue_Operation.OPERATION_UPLOAD;
          fallbackCode = SyncErrorCode.uploadFailed;
          final uploaded = await SyncErrorClassifier.execute(
            action: () => FileService.instance.uploadFile(
              targetDirectory,
              file,
              name,
              uploadPolicy: filepb.File_UploadPolicy.UPLOAD_POLICY_PRESERVE,
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
              message: '上传期间本地文件消失',
            );
          }
          final finalStat = await file.stat();
          if (finalStat.size != sourceStat.size ||
              finalStat.modified != sourceStat.modified) {
            throw const SyncException(
              code: SyncErrorCode.sourceChangedDuringUpload,
              operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
              message: '上传期间本地文件发生变化',
            );
          }
          final uploadedPath = filepath.posix.normalize(
            filepath.posix.join(uploaded.path, uploaded.name),
          );
          if (uploaded.name != name ||
              uploaded.size.toInt() != sourceStat.size ||
              uploadedPath != targetPath ||
              uploaded.hash.isEmpty) {
            throw const SyncException(
              code: SyncErrorCode.uploadResultMismatch,
              operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
              message: '云端返回的文件信息与同步目标不一致',
            );
          }
          final record = SyncRecord(
            profileId: profile.id,
            state: SyncRecord_State.STATE_ACTIVE,
            configVersion: fixnum.Int64(profile.configVersion),
            sourcePath: parent,
            sourceKey: name,
            sourceSize: fixnum.Int64(sourceStat.size),
            sourceHash: uploaded.hash,
            sourceHashAlgorithm: FileService.hashAlgorithm,
            sourceModifiedAt: Timestamp.fromDateTime(sourceStat.modified),
            targetPath: uploadedPath,
            targetSize: uploaded.size,
            targetHash: uploaded.hash,
            targetModifiedAt:
                uploaded.hasUpdatedAt() ? uploaded.updatedAt : null,
            syncedAt: Timestamp.fromDateTime(DateTime.now()),
          );
          fallbackCode = SyncErrorCode.recordWriteFailed;
          await SyncErrorClassifier.execute(
            action: () => SyncingService.instance.upsertRecords([record]),
            fallbackCode: SyncErrorCode.recordWriteFailed,
            unavailableCode: SyncErrorCode.syncServiceUnavailable,
            timeoutCode: SyncErrorCode.syncServiceUnavailable,
            operation: SyncHistoryIssue_Operation.OPERATION_UPLOAD,
          );
          targetStore.record(targetDirectory, uploaded);
          progress.synced++;
        } catch (error) {
          final failure = SyncErrorClassifier.classify(
            error,
            fallbackCode: fallbackCode,
            operation: operation,
          );
          if (failure.scope == SyncErrorScope.run) rethrow;
          if (failure.scope == SyncErrorScope.source) {
            progress.issues.add(_sourceIssue(
              sourceRoot: sourceRoot,
              sourcePath: filepath.dirname(file.path),
              message: failure.message,
              code: failure.code,
              operation: failure.operation,
            ));
            break;
          }
          progress.issues.add(_errorIssue(
            sourceRoot: sourceRoot,
            sourceFile: file.path,
            targetPath: targetPath,
            message: failure.message,
            code: failure.code,
            operation: failure.operation,
          ));
        }
      }
    }
  }

  SyncHistoryIssue _issue({
    required String sourceRoot,
    required String sourceFile,
    required String targetPath,
    required String message,
    required SyncErrorCode code,
    required SyncHistoryIssue_Operation operation,
  }) {
    final relative = filepath.relative(sourceFile, from: sourceRoot);
    return SyncHistoryIssue(
      sourcePath: filepath.normalize(
        filepath.absolute(filepath.dirname(sourceFile)),
      ),
      sourceKey: filepath.basename(sourceFile),
      sourceLabel: relative == '.' ? filepath.basename(sourceFile) : relative,
      targetPath: targetPath,
      errorCode: code.value,
      errorMessage: message,
      errorOperation: operation,
      kind: code.conflict
          ? SyncHistoryIssue_Kind.KIND_CONFLICT
          : SyncHistoryIssue_Kind.KIND_ERROR,
    );
  }

  SyncHistoryIssue _errorIssue({
    required String sourceRoot,
    required String sourceFile,
    required String message,
    required SyncErrorCode code,
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
    );
  }

  SyncHistoryIssue _sourceIssue({
    required String sourceRoot,
    required String sourcePath,
    required String message,
    required SyncErrorCode code,
    required SyncHistoryIssue_Operation operation,
  }) {
    final relative = filepath.relative(sourcePath, from: sourceRoot);
    return SyncHistoryIssue(
      sourcePath: filepath.normalize(filepath.absolute(sourcePath)),
      sourceLabel: relative == '.' ? filepath.basename(sourcePath) : relative,
      errorCode: code.value,
      errorMessage: message,
      errorOperation: operation,
      kind: SyncHistoryIssue_Kind.KIND_ERROR,
    );
  }

  SyncHistoryIssue _conflictIssue({
    required String sourceRoot,
    required String sourceFile,
    required String targetPath,
    required SyncErrorCode code,
  }) {
    return _issue(
      sourceRoot: sourceRoot,
      sourceFile: sourceFile,
      targetPath: targetPath,
      message: code == SyncErrorCode.targetModified ? '云端文件已被修改' : '云端存在同名文件',
      code: code,
      operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
    );
  }
}

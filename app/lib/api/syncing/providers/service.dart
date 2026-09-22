import 'dart:io' as io;

import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as filepath;

import 'package:maple_file/api/file/providers/repo.dart';
import 'package:maple_file/api/file/providers/service.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart' as filepb;
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pbgrpc.dart';

enum SyncErrorScope { run, source, item }

enum SyncErrorCode {
  unsupportedPlatform('unsupported_platform', SyncErrorScope.run),
  sourcePermissionDenied('source_permission_denied', SyncErrorScope.run),
  sourceAuthorizationInvalid(
    'source_authorization_invalid',
    SyncErrorScope.run,
  ),
  sourceAuthorizationMismatch(
    'source_authorization_mismatch',
    SyncErrorScope.run,
  ),
  sourceRootMissing('source_root_missing', SyncErrorScope.run),
  sourceRootUnreadable('source_root_unreadable', SyncErrorScope.run),
  targetConfigInvalid('target_config_invalid', SyncErrorScope.run),
  targetRepositoryUnavailable(
    'target_repository_unavailable',
    SyncErrorScope.run,
  ),
  targetRepositoryDisabled(
    'target_repository_disabled',
    SyncErrorScope.run,
  ),
  targetRepositoryLocalUnsupported(
    'target_repository_local_unsupported',
    SyncErrorScope.run,
  ),
  targetDirectoryInvalid('target_directory_invalid', SyncErrorScope.run),
  targetNotDirectory('target_not_directory', SyncErrorScope.run),
  targetAuthenticationFailed(
    'target_authentication_failed',
    SyncErrorScope.run,
  ),
  targetStorageFull('target_storage_full', SyncErrorScope.run),
  recordReadFailed('record_read_failed', SyncErrorScope.run),
  recordWriteFailed('record_write_failed', SyncErrorScope.run),
  syncServiceUnavailable(
    'sync_service_unavailable',
    SyncErrorScope.run,
    retryable: true,
  ),
  targetUnavailable(
    'target_unavailable',
    SyncErrorScope.run,
    retryable: true,
  ),
  targetTimeout(
    'target_timeout',
    SyncErrorScope.run,
    retryable: true,
  ),
  targetAccessFailed(
    'target_access_failed',
    SyncErrorScope.run,
    retryable: true,
  ),
  sourceUnavailable('source_unavailable', SyncErrorScope.source),
  sourceScanFailed('source_scan_failed', SyncErrorScope.source),
  sourceUnreadable('source_unreadable', SyncErrorScope.item),
  sourceMissing('source_missing', SyncErrorScope.item),
  sourceOutsideRoot('source_outside_root', SyncErrorScope.item),
  sourceChangedDuringUpload(
    'source_changed_during_upload',
    SyncErrorScope.item,
  ),
  uploadRejected('upload_rejected', SyncErrorScope.item),
  uploadFailed('upload_failed', SyncErrorScope.item),
  uploadResultMismatch('upload_result_mismatch', SyncErrorScope.item),
  internalItemError('internal_item_error', SyncErrorScope.item),
  targetExistsWithoutBaseline(
    'target_exists_without_baseline',
    SyncErrorScope.item,
    conflict: true,
  ),
  targetModified(
    'target_modified',
    SyncErrorScope.item,
    conflict: true,
  );

  const SyncErrorCode(
    this.value,
    this.scope, {
    this.retryable = false,
    this.conflict = false,
  });

  final String value;
  final SyncErrorScope scope;
  final bool retryable;
  final bool conflict;
}

class SyncException implements Exception {
  const SyncException({
    required this.code,
    required this.operation,
    required this.message,
    this.cause,
  });

  final SyncErrorCode code;
  final SyncHistoryIssue_Operation operation;
  final String message;
  final Object? cause;

  SyncErrorScope get scope => code.scope;

  @override
  String toString() => message;
}

class SyncErrorClassifier {
  const SyncErrorClassifier._();

  static SyncException classify(
    Object error, {
    SyncErrorCode fallbackCode = SyncErrorCode.internalItemError,
    required SyncHistoryIssue_Operation operation,
    SyncErrorCode unavailableCode = SyncErrorCode.targetUnavailable,
    SyncErrorCode timeoutCode = SyncErrorCode.targetTimeout,
  }) {
    if (error is SyncException) return error;
    final original = _originalError(error);
    if (original is SyncException) return original;
    var code = fallbackCode;
    if (original is GrpcError) {
      code = switch (original.code) {
        StatusCode.unauthenticated ||
        StatusCode.permissionDenied =>
          SyncErrorCode.targetAuthenticationFailed,
        StatusCode.unavailable => unavailableCode,
        StatusCode.deadlineExceeded => timeoutCode,
        StatusCode.resourceExhausted => SyncErrorCode.targetStorageFull,
        StatusCode.invalidArgument
            when fallbackCode == SyncErrorCode.uploadFailed =>
          SyncErrorCode.uploadRejected,
        _ => fallbackCode,
      };
    } else if (original is io.FileSystemException) {
      code = _isMissingFile(original)
          ? SyncErrorCode.sourceMissing
          : SyncErrorCode.sourceUnreadable;
    } else if (original is io.SocketException) {
      code = unavailableCode;
    }
    return SyncException(
      code: code,
      operation: operation,
      message: error is FutureException ? error.message : _message(original),
      cause: original,
    );
  }

  static Future<T> execute<T>({
    required Future<T> Function() action,
    required SyncErrorCode fallbackCode,
    required SyncHistoryIssue_Operation operation,
    SyncErrorCode unavailableCode = SyncErrorCode.targetUnavailable,
    SyncErrorCode timeoutCode = SyncErrorCode.targetTimeout,
    int maxAttempts = 3,
    Duration retryDelay = const Duration(milliseconds: 200),
  }) async {
    assert(maxAttempts > 0);
    for (var attempt = 1;; attempt++) {
      try {
        return await action();
      } catch (error) {
        final failure = classify(
          error,
          fallbackCode: fallbackCode,
          operation: operation,
          unavailableCode: unavailableCode,
          timeoutCode: timeoutCode,
        );
        if (!failure.code.retryable || attempt >= maxAttempts) throw failure;
        if (retryDelay > Duration.zero) {
          await Future<void>.delayed(retryDelay * attempt);
        }
      }
    }
  }

  static String _message(Object error) {
    if (error is SyncException) return error.message;
    if (error is GrpcError) return error.message ?? error.toString();
    if (error is io.SocketException) return error.message;
    if (error is io.FileSystemException) {
      return error.message.isEmpty ? error.toString() : error.message;
    }
    return error.toString();
  }

  static Object _originalError(Object error) {
    var result = error;
    while (result is FutureException && !identical(result, result.cause)) {
      result = result.cause;
    }
    return result;
  }

  static bool _isMissingFile(io.FileSystemException error) {
    return switch (error.osError?.errorCode) {
      2 || 3 => true,
      _ => false,
    };
  }
}

class SyncRunProgress {
  int scanned = 0;
  int synced = 0;
  int skipped = 0;
  final List<SyncHistoryIssue> issues = [];

  int get failed => issues
      .where((issue) => issue.kind == SyncHistoryIssue_Kind.KIND_ERROR)
      .length;

  int get conflicted => issues
      .where((issue) => issue.kind == SyncHistoryIssue_Kind.KIND_CONFLICT)
      .length;

  void addRunFailure(SyncException failure) {
    issues.add(SyncHistoryIssue(
      errorCode: failure.code.value,
      errorMessage: failure.message,
      errorOperation: failure.operation,
      kind: SyncHistoryIssue_Kind.KIND_ERROR,
    ));
  }
}

enum SyncSourceType {
  unknown(''),
  album('album'),
  localDirectory('local_directory');

  const SyncSourceType(this.value);

  final String value;

  String get label => switch (this) {
        SyncSourceType.unknown => '未知同步类型'.tr(),
        SyncSourceType.album => '相册备份'.tr(),
        SyncSourceType.localDirectory => '本地目录同步'.tr(),
      };

  bool get isSupported => switch (this) {
        SyncSourceType.unknown => false,
        SyncSourceType.album => !Util.isWeb && (Util.isAndroid || Util.isIOS),
        SyncSourceType.localDirectory =>
          !Util.isWeb && (Util.isAndroid || Util.isDesktop),
      };

  static bool get hasSupportedType => values.any((type) => type.isSupported);

  static SyncSourceType fromValue(String value) {
    for (final type in SyncSourceType.values) {
      if (type.value == value) return type;
    }
    return SyncSourceType.unknown;
  }
}

enum SyncTargetType {
  repoDirectory('repo_directory');

  const SyncTargetType(this.value);

  final String value;

  static SyncTargetType? fromValue(String value) {
    for (final type in SyncTargetType.values) {
      if (type.value == value) return type;
    }
    return null;
  }
}

abstract class SyncTargetGateway {
  Future<List<filepb.File>> list(String path);

  Future<void> mkdir(String path, String name);
}

class FileSyncTargetGateway implements SyncTargetGateway {
  const FileSyncTargetGateway();

  @override
  Future<List<filepb.File>> list(String path) {
    return FileService.instance.list(
      filter: {'path': path},
      showError: false,
    );
  }

  @override
  Future<void> mkdir(String path, String name) {
    return FileService.instance.mkdir(
      path,
      name,
      showError: false,
    );
  }
}

/// Resolves and creates remote directories by inspecting their parent.
///
/// Some WebDAV servers return an empty list both for an empty directory and for
/// a missing directory. Checking the parent avoids treating those two cases as
/// equivalent.
class SyncTargetDirectory {
  SyncTargetDirectory({SyncTargetGateway? gateway})
      : _gateway = gateway ?? const FileSyncTargetGateway();

  final SyncTargetGateway _gateway;
  final Map<String, List<filepb.File>> _entries = {};

  Future<List<filepb.File>> ensure(String path) async {
    final normalized = filepath.posix.normalize(path);
    if (!filepath.posix.isAbsolute(normalized)) {
      throw SyncException(
        code: SyncErrorCode.targetDirectoryInvalid,
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
        message: '同步目标目录无效：$path',
      );
    }
    final cached = _entries[normalized];
    if (cached != null) return cached;
    if (normalized == '/') {
      final files = await _list(normalized);
      return _cache(normalized, files);
    }

    final parent = filepath.posix.dirname(normalized);
    final name = filepath.posix.basename(normalized);
    if (name.isEmpty || name == '/' || parent == normalized) {
      throw SyncException(
        code: SyncErrorCode.targetDirectoryInvalid,
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
        message: '同步目标目录无效：$path',
      );
    }
    final parentEntries = await ensure(parent);
    final existing = find(parentEntries, name);
    if (existing == null) {
      await SyncErrorClassifier.execute(
        action: () => _gateway.mkdir(parent, name),
        fallbackCode: SyncErrorCode.targetAccessFailed,
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
      );
      return _cache(normalized, const <filepb.File>[]);
    }
    if (existing.type != 'DIR') {
      throw SyncException(
        code: SyncErrorCode.targetNotDirectory,
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
        message: '同步目标不是目录：$normalized',
      );
    }
    final files = await _list(normalized);
    return _cache(normalized, files);
  }

  filepb.File? find(Iterable<filepb.File> entries, String name) {
    for (final entry in entries) {
      if (entry.name == name) return entry;
    }
    return null;
  }

  void record(String directory, filepb.File file) {
    final normalized = filepath.posix.normalize(directory);
    final entries = _entries[normalized];
    if (entries == null) return;
    entries.removeWhere((entry) => entry.name == file.name);
    entries.add(file);
  }

  List<filepb.File> _cache(
    String path,
    Iterable<filepb.File> entries,
  ) {
    return _entries[path] = List<filepb.File>.of(entries);
  }

  Future<List<filepb.File>> _list(String path) {
    return SyncErrorClassifier.execute(
      action: () => _gateway.list(path),
      fallbackCode: SyncErrorCode.targetAccessFailed,
      operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
    );
  }
}

class SyncTargetRepository {
  const SyncTargetRepository._();

  static Future<Repo> requireRemote(String path) async {
    final repos = await SyncErrorClassifier.execute(
      action: () => RepoService.instance.list(
        showError: false,
      ),
      operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
      fallbackCode: SyncErrorCode.targetRepositoryUnavailable,
    );
    return requireRemoteFrom(path, repos);
  }

  static Repo requireRemoteFrom(String path, Iterable<Repo> repos) {
    if (!filepath.posix.isAbsolute(filepath.posix.normalize(path))) {
      throw const SyncException(
        code: SyncErrorCode.targetConfigInvalid,
        message: '同步目标目录配置无效',
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
      );
    }
    final repository = resolve(path, repos);
    if (repository == null) {
      throw const SyncException(
        code: SyncErrorCode.targetRepositoryUnavailable,
        message: '同步目标不属于可用的存储仓库',
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
      );
    }
    if (!repository.status) {
      throw const SyncException(
        code: SyncErrorCode.targetRepositoryDisabled,
        message: '同步目标所属的存储仓库已停用',
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
      );
    }
    if (repository.driver == 'local') {
      throw const SyncException(
        code: SyncErrorCode.targetRepositoryLocalUnsupported,
        message: '本地目录同步不能选择本地存储仓库作为目标',
        operation: SyncHistoryIssue_Operation.OPERATION_VERIFY,
      );
    }
    return repository;
  }

  static Repo? resolve(String path, Iterable<Repo> repos) {
    final normalized = filepath.posix.normalize(path);
    Repo? result;
    var matchedLength = -1;
    for (final repository in repos) {
      final root = filepath.posix.normalize(
        filepath.posix.join(repository.path, repository.name),
      );
      if (normalized != root && !filepath.posix.isWithin(root, normalized)) {
        continue;
      }
      if (root.length > matchedLength) {
        result = repository;
        matchedLength = root.length;
      }
    }
    return result;
  }

  static Set<String> localRoots(Iterable<Repo> repos) {
    return {
      for (final repository in repos)
        if (repository.driver == 'local')
          filepath.posix.normalize(
            filepath.posix.join(repository.path, repository.name),
          ),
    };
  }
}

/// Common persistence API shared by all sync and backup implementations.
class SyncingService {
  static SyncingService get instance => _instance;
  static final SyncingService _instance = SyncingService._internal();

  factory SyncingService() => _instance;

  SyncingService._internal();

  SyncServiceClient? _client;
  DateTime _clientTime = DateTime.now();

  SyncServiceClient get _syncClient {
    if (_client == null || Grpc.instance.connectTime.isAfter(_clientTime)) {
      _client = SyncServiceClient(
        Grpc.instance.client,
        options: CallOptions(metadata: Grpc.instance.metadata),
      );
      _clientTime = Grpc.instance.connectTime;
    }
    return _client!;
  }

  Future<T> _request<T>(Future<T> Function() callback) {
    return doFuture(
      callback,
      showError: false,
    );
  }

  Future<List<SyncProfile>> listProfiles() => _request(() async {
        final response =
            await _syncClient.listProfiles(SyncProfile_ListRequest());
        return response.results;
      });

  Future<SyncProfile> createProfile(SyncProfile profile) => _request(() async {
        final response = await _syncClient.createProfile(
          SyncProfile_CreateRequest(payload: profile),
        );
        return response.result;
      });

  Future<SyncProfile> updateProfile(SyncProfile profile) => _request(() async {
        final response = await _syncClient.updateProfile(
          SyncProfile_UpdateRequest(payload: profile),
        );
        return response.result;
      });

  Future<void> deleteProfile(int id) => _request(() async {
        await _syncClient.deleteProfile(SyncProfile_DeleteRequest(id: id));
      });

  Future<List<SyncRecord>> listRecords(SyncRecord_ListRequest request) =>
      _request(() async {
        final response = await _syncClient.listRecords(request);
        return response.results;
      });

  Future<void> upsertRecords(Iterable<SyncRecord> records) =>
      _request(() async {
        await _syncClient.upsertRecords(
          SyncRecord_UpsertRequest(results: records),
        );
      });

  Future<List<SyncHistory>> listHistories(SyncHistory_ListRequest request) =>
      _request(() async {
        final response = await _syncClient.listHistories(request);
        return response.results;
      });

  Future<SyncHistory> createHistory(SyncHistory history) => _request(() async {
        final response = await _syncClient.createHistory(
          SyncHistory_CreateRequest(payload: history),
        );
        return response.result;
      });

  Future<SyncHistory> startHistory(SyncHistory history) => _request(() async {
        final response = await _syncClient.startHistory(
          SyncHistory_StartRequest(payload: history),
        );
        return response.result;
      });

  Future<SyncHistory> finishHistory(SyncHistory history) => _request(() async {
        final response = await _syncClient.finishHistory(
          SyncHistory_FinishRequest(payload: history),
        );
        return response.result;
      });

  Future<List<SyncHistoryIssue>> listHistoryIssues(
    SyncHistoryIssue_ListRequest request,
  ) =>
      _request(() async {
        final response = await _syncClient.listHistoryIssues(request);
        return response.results;
      });
}

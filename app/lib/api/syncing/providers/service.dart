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
    return FileService.instance.list(filter: {'path': path});
  }

  @override
  Future<void> mkdir(String path, String name) {
    return FileService.instance.mkdir(path, name);
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
      throw StateError('同步目标目录无效：$path');
    }
    final cached = _entries[normalized];
    if (cached != null) return cached;
    if (normalized == '/') {
      final files = await _gateway.list(normalized);
      return _cache(normalized, files);
    }

    final parent = filepath.posix.dirname(normalized);
    final name = filepath.posix.basename(normalized);
    if (name.isEmpty || name == '/' || parent == normalized) {
      throw StateError('同步目标目录无效：$path');
    }
    final parentEntries = await ensure(parent);
    final existing = find(parentEntries, name);
    if (existing == null) {
      await _gateway.mkdir(parent, name);
      return _cache(normalized, const <filepb.File>[]);
    }
    if (existing.type != 'DIR') {
      throw StateError('同步目标不是目录：$normalized');
    }
    final files = await _gateway.list(normalized);
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
}

class SyncTargetRepository {
  const SyncTargetRepository._();

  static Future<Repo> requireRemote(String path) async {
    final repositories = await RepoService.instance.list();
    return requireRemoteFrom(path, repositories);
  }

  static Repo requireRemoteFrom(String path, Iterable<Repo> repositories) {
    final repository = resolve(path, repositories);
    if (repository == null) {
      throw StateError('同步目标不属于可用的存储仓库');
    }
    if (!repository.status) {
      throw StateError('同步目标所属的存储仓库已停用');
    }
    if (repository.driver == 'local') {
      throw StateError('本地目录同步不能选择本地存储仓库作为目标');
    }
    return repository;
  }

  static Repo? resolve(String path, Iterable<Repo> repositories) {
    final normalized = filepath.posix.normalize(path);
    Repo? result;
    var matchedLength = -1;
    for (final repository in repositories) {
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

  static Set<String> localRoots(Iterable<Repo> repositories) {
    return {
      for (final repository in repositories)
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

  Future<List<SyncProfile>> listProfiles() => doFuture(() async {
        final response =
            await _syncClient.listProfiles(SyncProfile_ListRequest());
        return response.results;
      });

  Future<SyncProfile> createProfile(SyncProfile profile) => doFuture(() async {
        final response = await _syncClient.createProfile(
          SyncProfile_CreateRequest(payload: profile),
        );
        return response.result;
      });

  Future<SyncProfile> updateProfile(SyncProfile profile) => doFuture(() async {
        final response = await _syncClient.updateProfile(
          SyncProfile_UpdateRequest(payload: profile),
        );
        return response.result;
      });

  Future<void> deleteProfile(int id) => doFuture(() async {
        await _syncClient.deleteProfile(SyncProfile_DeleteRequest(id: id));
      });

  Future<List<SyncRecord>> listRecords(SyncRecord_ListRequest request) =>
      doFuture(() async {
        final response = await _syncClient.listRecords(request);
        return response.results;
      });

  Future<void> upsertRecords(Iterable<SyncRecord> records) =>
      doFuture(() async {
        await _syncClient.upsertRecords(
          SyncRecord_UpsertRequest(results: records),
        );
      });

  Future<List<SyncHistory>> listHistories(SyncHistory_ListRequest request) =>
      doFuture(() async {
        final response = await _syncClient.listHistories(request);
        return response.results;
      });

  Future<SyncHistory> createHistory(SyncHistory history) => doFuture(() async {
        final response = await _syncClient.createHistory(
          SyncHistory_CreateRequest(payload: history),
        );
        return response.result;
      });

  Future<SyncHistory> startHistory(SyncHistory history) => doFuture(() async {
        final response = await _syncClient.startHistory(
          SyncHistory_StartRequest(payload: history),
        );
        return response.result;
      });

  Future<SyncHistory> finishHistory(SyncHistory history) => doFuture(() async {
        final response = await _syncClient.finishHistory(
          SyncHistory_FinishRequest(payload: history),
        );
        return response.result;
      });

  Future<List<SyncHistoryIssue>> listHistoryIssues(
    SyncHistoryIssue_ListRequest request,
  ) =>
      doFuture(() async {
        final response = await _syncClient.listHistoryIssues(request);
        return response.results;
      });
}

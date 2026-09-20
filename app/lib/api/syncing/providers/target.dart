import 'package:path/path.dart' as filepath;

import 'package:maple_file/api/file/providers/repo.dart';
import 'package:maple_file/api/file/providers/service.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart' as file_proto;
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

abstract class SyncTargetGateway {
  Future<List<file_proto.File>> list(String path);

  Future<void> mkdir(String path, String name);
}

class FileSyncTargetGateway implements SyncTargetGateway {
  const FileSyncTargetGateway();

  @override
  Future<List<file_proto.File>> list(String path) {
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
  final Map<String, List<file_proto.File>> _entries = {};

  Future<List<file_proto.File>> ensure(String path) async {
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
      return _cache(normalized, const <file_proto.File>[]);
    }
    if (existing.type != 'DIR') {
      throw StateError('同步目标不是目录：$normalized');
    }
    final files = await _gateway.list(normalized);
    return _cache(normalized, files);
  }

  file_proto.File? find(Iterable<file_proto.File> entries, String name) {
    for (final entry in entries) {
      if (entry.name == name) return entry;
    }
    return null;
  }

  void record(String directory, file_proto.File file) {
    final normalized = filepath.posix.normalize(directory);
    final entries = _entries[normalized];
    if (entries == null) return;
    entries.removeWhere((entry) => entry.name == file.name);
    entries.add(file);
  }

  List<file_proto.File> _cache(
    String path,
    Iterable<file_proto.File> entries,
  ) {
    return _entries[path] = List<file_proto.File>.of(entries);
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

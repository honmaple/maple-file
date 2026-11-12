import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as filepath;

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import '../services/thumbnail.dart';
import 'file_setting.dart';
import 'repo.dart';

Future<String> _repositoryVersion(Ref ref, File file) async {
  final path = filepath.posix.join(file.path, file.name);
  try {
    final repos = await ref.read(repoProvider.future);
    String? version;
    var mountLength = 0;
    for (final repo in repos) {
      final mount = filepath.posix.join(repo.path, repo.name);
      if (repo.status &&
          mount.length > mountLength &&
          filepath.posix.isWithin(mount, path)) {
        mountLength = mount.length;
        final revision = repo.updatedAt;
        version = '${repo.id}:${revision.seconds}:${revision.nanos}';
      }
    }
    if (version != null) return version;
  } on Exception {
    // Use a session-local cache key when repository metadata is unavailable.
  }
  return Grpc.instance.connectTime.toIso8601String();
}

final thumbnailServiceProvider = Provider((ref) => ThumbnailService());

final thumbnailProvider = FutureProvider.autoDispose.family<Uint8List?, File>((
  ref,
  file,
) async {
  final mimeType = ThumbnailService.mimeTypeForFile(file);
  if (mimeType == null) return null;
  if (mimeType.startsWith('video/') &&
      !ref.watch(
        fileSettingProvider.select((setting) => setting.thumb.video),
      )) {
    return null;
  }
  final service = ref.watch(thumbnailServiceProvider);
  var cancelled = false;
  ref.onDispose(() => cancelled = true);
  return service.generate(
    file,
    repositoryVersion: file.hasUpdatedAt()
        ? await _repositoryVersion(ref, file)
        : null,
    isCancelled: () => cancelled,
  );
});

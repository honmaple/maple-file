import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as filepath;

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

import 'thumbnail/thumbnail.dart' as thumbnail;

export 'thumbnail/thumbnail.dart' show ThumbnailOption;

class ThumbnailService {
  final _service = thumbnail.Thumbnail.create();

  static String _cacheKey(
    String path,
    File file,
    thumbnail.ThumbnailOption option,
    String? repositoryVersion,
  ) {
    return sha256
        .convert(
          utf8.encode(
            jsonEncode([
              1,
              repositoryVersion,
              path,
              file.updatedAt.seconds.toInt(),
              file.updatedAt.nanos,
              file.size.toInt(),
              option.width,
              option.height,
              option.quality,
            ]),
          ),
        )
        .toString();
  }

  static String? mimeTypeForFile(File file) {
    final name = file.name;
    if (name.isEmpty || PathUtil.isDir(name, type: file.type)) return null;

    final type = file.type.split(';').first.trim().toLowerCase();
    if (type.isNotEmpty && type != 'application/octet-stream') return type;

    final inferred = PathUtil.mimeType(name).toLowerCase();
    if (!inferred.startsWith('video/') && PathUtil.isVideo(name)) {
      return 'video/unknown';
    }
    return inferred.isEmpty ? null : inferred;
  }

  Future<Uint8List?> generate(
    File file, {
    String? repositoryVersion,
    bool Function()? isCancelled,
  }) async {
    final mimeType = mimeTypeForFile(file);
    if (mimeType == null || (isCancelled?.call() ?? false)) {
      return null;
    }
    final maxSourceBytes = _service.maxSourceBytes;
    if (mimeType.startsWith('image/') &&
        maxSourceBytes != null &&
        file.size > maxSourceBytes) {
      return null;
    }
    final path = filepath.posix.join(file.path, file.name);
    final isVideo = mimeType.startsWith('video/');
    final option = (
      width: isVideo ? 192 : 200,
      height: isVideo ? 192 : 200,
      quality: isVideo ? 80 : 100,
    );
    return _service.generate(
      Uri.parse(Grpc.instance.previewURL(path)),
      mimeType: mimeType,
      option: option,
      cache:
          file.hasUpdatedAt()
              ? thumbnail.ThumbnailCacheOption(
                key: _cacheKey(path, file, option, repositoryVersion),
              )
              : const thumbnail.ThumbnailCacheOption(enabled: false),
      isCancelled: isCancelled,
    );
  }

  Future<bool> clearCache() => _service.clearCache();
}

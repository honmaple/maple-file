import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'platform.dart';

class ThumbnailNativeService extends ThumbnailImageService {
  ThumbnailNativeService() : super(cache: _ThumbnailDiskCache());
}

class ThumbnailMobileService extends ThumbnailNativeService {
  ThumbnailMobileService.android() : _usesHeightLimit = false;

  ThumbnailMobileService.ios() : _usesHeightLimit = true;

  final bool _usesHeightLimit;

  @override
  bool supports(String mimeType) =>
      mimeType.startsWith('video/') || super.supports(mimeType);

  @override
  Future<Uint8List?> generateThumbnail(
    Uri source, {
    required String mimeType,
    required ThumbnailOption option,
  }) {
    if (!mimeType.startsWith('video/')) {
      return super.generateThumbnail(
        source,
        mimeType: mimeType,
        option: option,
      );
    }
    return VideoThumbnail.thumbnailData(
      video: source.toString(),
      maxWidth: option.width,
      maxHeight: _usesHeightLimit ? option.height : 0,
      quality: option.quality,
      imageFormat: ImageFormat.JPEG,
    ).timeout(const Duration(seconds: 15));
  }
}

class _ThumbnailDiskCache implements ThumbnailCache {
  static final _manager = CacheManager(
    Config(
      'maple_thumbnails_v1',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 1024,
    ),
  );

  @override
  Future<void> clear() => _manager.emptyCache();

  @override
  Future<Uint8List?> read(String key) async {
    final entry = await _manager.getFileFromCache(key);
    return entry?.file.readAsBytes();
  }

  @override
  Future<void> write(String key, Uint8List bytes) async {
    // Store only the generated image, without a source URL containing credentials.
    await _manager.putFile(key, bytes, key: key, fileExtension: 'jpg');
  }
}

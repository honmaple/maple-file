import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart' show compute, protected;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;

typedef ThumbnailOption = ({int width, int height, int quality});

class ThumbnailCacheOption {
  const ThumbnailCacheOption({this.enabled = true, this.key = ''});

  final bool enabled;

  /// An empty key derives a cache key from the source URI and output options.
  final String key;
}

abstract interface class ThumbnailCache {
  Future<Uint8List?> read(String key);
  Future<void> write(String key, Uint8List bytes);
  Future<void> clear();
}

abstract interface class ThumbnailService {
  /// Clears persisted thumbnails, returning false if no cache is configured.
  Future<bool> clearCache();

  /// The input size limit for original images, if this implementation reads them.
  int? get maxSourceBytes;

  /// Returns encoded image bytes, or null if no thumbnail is available.
  /// A null cache option uses the default settings.
  Future<Uint8List?> generate(
    Uri source, {
    required String mimeType,
    required ThumbnailOption option,
    ThumbnailCacheOption? cache,
    bool Function()? isCancelled,
  });
}

abstract class ThumbnailQueuedService implements ThumbnailService {
  ThumbnailQueuedService({ThumbnailCache? cache}) : _cache = cache;

  final ThumbnailCache? _cache;
  final _queues = <String, _ThumbnailQueue>{};
  final _inFlight =
      <
        (String, int),
        ({Future<Uint8List?> result, bool Function() cancelled})
      >{};
  final _cacheWrites = _ThumbnailQueue(1);
  Future<void>? _cacheClearing;
  int _cacheRevision = 0;

  @override
  Future<bool> clearCache() async {
    final storage = _cache;
    if (storage == null) return false;

    var clearing = _cacheClearing;
    if (clearing == null) {
      _cacheRevision++;
      clearing = _cacheWrites.run(storage.clear).whenComplete(() {
        _cacheClearing = null;
      });
      _cacheClearing = clearing;
    }
    await clearing;
    return true;
  }

  @override
  int? get maxSourceBytes => null;

  @protected
  bool supports(String mimeType);

  @protected
  Future<Uint8List?> generateThumbnail(
    Uri source, {
    required String mimeType,
    required ThumbnailOption option,
  });

  @override
  Future<Uint8List?> generate(
    Uri source, {
    required String mimeType,
    required ThumbnailOption option,
    ThumbnailCacheOption? cache,
    bool Function()? isCancelled,
  }) async {
    bool cancelled() => isCancelled?.call() ?? false;
    final sourceMimeType = mimeType.split(';').first.trim().toLowerCase();
    if (!supports(sourceMimeType) || cancelled()) return null;

    final storage = cache?.enabled == false ? null : _cache;
    if (storage == null) {
      return _load(source, sourceMimeType, option, cancelled);
    }

    final clearing = _cacheClearing;
    if (clearing != null) {
      try {
        await clearing;
      } on Exception {
        // Clearing failures are reported to the caller that requested it.
      }
      if (cancelled()) return null;
    }
    final revision = _cacheRevision;
    final customKey = cache?.key ?? '';
    final key = customKey.isEmpty
        ? _defaultCacheKey(source, option)
        : customKey;
    final requestKey = (key, revision);
    while (_inFlight[requestKey] != null) {
      final pending = _inFlight[requestKey]!;
      final bytes = await pending.result;
      if (cancelled()) return null;
      if (bytes != null || !pending.cancelled()) return bytes;
    }

    final result = _load(
      source,
      sourceMimeType,
      option,
      cancelled,
      storage: storage,
      key: key,
      cacheRevision: revision,
    ).whenComplete(() => _inFlight.remove(requestKey));
    _inFlight[requestKey] = (result: result, cancelled: cancelled);
    return result;
  }

  Future<Uint8List?> _load(
    Uri source,
    String mimeType,
    ThumbnailOption option,
    bool Function() cancelled, {
    ThumbnailCache? storage,
    String? key,
    int? cacheRevision,
  }) async {
    if (storage != null && key != null) {
      final cached = await _read(storage, key);
      if (cancelled()) return null;
      if (cached != null && cached.isNotEmpty) return cached;
    }
    try {
      final mediaType = mimeType.split('/').first;
      final queue = _queues.putIfAbsent(
        mediaType,
        () => _ThumbnailQueue(mediaType == 'image' ? 2 : 1),
      );
      return await queue.run(() async {
        if (cancelled()) return null;
        final bytes = await generateThumbnail(
          source,
          mimeType: mimeType,
          option: option,
        );
        if (bytes == null || bytes.isEmpty) return null;
        if (key != null && storage != null && cacheRevision == _cacheRevision) {
          await _cacheWrites.run(() async {
            if (cacheRevision == _cacheRevision) {
              await _write(storage, key, bytes);
            }
          });
        }
        return bytes;
      });
    } on Exception {
      return null;
    }
  }

  static String _defaultCacheKey(Uri source, ThumbnailOption option) {
    final input = jsonEncode([
      source.toString(),
      option.width,
      option.height,
      option.quality,
    ]);
    return 'uri-v1-${sha256.convert(utf8.encode(input))}';
  }

  Future<Uint8List?> _read(ThumbnailCache cache, String key) async {
    try {
      return await cache.read(key);
    } on Exception {
      return null;
    }
  }

  Future<void> _write(ThumbnailCache cache, String key, Uint8List bytes) async {
    try {
      await cache.write(key, bytes);
    } on Exception {
      // A cache write failure should still display the generated thumbnail.
    }
  }
}

class _ThumbnailQueue {
  _ThumbnailQueue(this._limit);

  final int _limit;
  final _waiting = Queue<Completer<void>>();
  int _running = 0;

  Future<T> run<T>(Future<T> Function() task) async {
    if (_running < _limit) {
      _running++;
    } else {
      final ready = Completer<void>();
      _waiting.addLast(ready);
      await ready.future;
    }
    try {
      return await task();
    } finally {
      if (_waiting.isEmpty) {
        _running--;
      } else {
        _waiting.removeFirst().complete();
      }
    }
  }
}

class ThumbnailImageService extends ThumbnailQueuedService {
  ThumbnailImageService({super.cache});

  static const _maxSourceBytes = 20 * 1024 * 1024;
  static const _maxSourcePixels = 32 * 1024 * 1024;

  @override
  bool supports(String mimeType) => mimeType.startsWith('image/');

  @override
  int get maxSourceBytes => _maxSourceBytes;

  @override
  Future<Uint8List?> generateThumbnail(
    Uri source, {
    required String mimeType,
    required ThumbnailOption option,
  }) async {
    final bytes = await _readSource(source);
    if (bytes == null || bytes.isEmpty) return null;
    return compute(_resize, (
      source: bytes,
      width: option.width,
      height: option.height,
      quality: option.quality,
    ));
  }

  static Uint8List? _resize(
    ({Uint8List source, int width, int height, int quality}) job,
  ) {
    final decoder = image.findDecoderForData(job.source);
    final info = decoder?.startDecode(job.source);
    if (info == null ||
        info.width <= 0 ||
        info.height <= 0 ||
        info.width * info.height > _maxSourcePixels) {
      return null;
    }
    final frame = decoder!.decodeFrame(0);
    if (frame == null) return null;
    final oriented = image.bakeOrientation(frame);
    final scale = math.min(
      1.0,
      math.min(job.width / oriented.width, job.height / oriented.height),
    );
    final resized = scale == 1.0
        ? oriented
        : image.copyResize(
            oriented,
            width: math.max(1, (oriented.width * scale).round()),
            height: math.max(1, (oriented.height * scale).round()),
            interpolation: image.Interpolation.average,
          );
    return image.encodeJpg(resized, quality: job.quality);
  }

  Future<Uint8List?> _readSource(Uri uri) async {
    final client = http.Client();
    final abort = Completer<void>();
    final timer = Timer(const Duration(seconds: 15), abort.complete);
    try {
      final response = await client.send(
        http.AbortableRequest('GET', uri, abortTrigger: abort.future),
      );
      if (response.statusCode != 200 ||
          (response.contentLength ?? 0) > _maxSourceBytes) {
        return null;
      }
      final data = BytesBuilder(copy: false);
      await for (final chunk in response.stream) {
        if (data.length + chunk.length > _maxSourceBytes) return null;
        data.add(chunk);
      }
      return data.takeBytes();
    } finally {
      timer.cancel();
      client.close();
    }
  }
}

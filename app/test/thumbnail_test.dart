import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:maple_file/api/file/providers/file_setting.dart';
import 'package:maple_file/api/file/providers/thumbnail.dart';
import 'package:maple_file/api/file/services/thumbnail.dart' as app;
import 'package:maple_file/api/file/services/thumbnail/platform.dart';
import 'package:maple_file/api/file/services/thumbnail/thumbnail.dart'
    show Thumbnail;
import 'package:maple_file/api/file/services/thumbnail/web.dart';
import 'package:maple_file/api/setting/providers/setting.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/generated/proto/api/file/file.pb.dart';

const _option = (width: 192, height: 192, quality: 80);
const _noCache = ThumbnailCacheOption(enabled: false);

Uint8List _bytes(int value) => Uint8List.fromList([value]);

class _MemoryCache implements ThumbnailCache {
  final entries = <String, Uint8List>{};

  @override
  Future<void> clear() async => entries.clear();

  @override
  Future<Uint8List?> read(String key) async => entries[key];

  @override
  Future<void> write(String key, Uint8List bytes) async {
    entries[key] = bytes;
  }
}

class _QueuedService extends ThumbnailQueuedService {
  _QueuedService(this._generate, {super.cache});

  final Future<Uint8List?> Function(String path) _generate;

  @override
  bool supports(String mimeType) => true;

  @override
  Future<Uint8List?> generateThumbnail(
    Uri source, {
    required String mimeType,
    required ThumbnailOption option,
  }) => _generate(source.path);

  Future<Uint8List?> request(
    String path, {
    String mimeType = 'image/jpeg',
    ThumbnailOption option = _option,
    ThumbnailCacheOption? cache,
    bool Function()? isCancelled,
    int port = 8000,
  }) => generate(
    Uri.http('127.0.0.1:$port', path),
    mimeType: mimeType,
    option: option,
    cache: cache,
    isCancelled: isCancelled,
  );
}

class _FileSettings extends SettingNotifier<FileSetting> {
  _FileSettings()
    : super(
        key: 'app.file',
        value: const FileSetting(),
        fromJson: FileSetting.fromJson,
      );

  @override
  FileSetting build() => value;

  void enableVideo(bool enabled) =>
      state = state.copyWith.thumb(video: enabled);
}

class _AppService extends app.ThumbnailService {
  final generated = <String>[];

  @override
  Future<Uint8List?> generate(
    File file, {
    String? repositoryVersion,
    bool Function()? isCancelled,
  }) async {
    generated.add(file.name);
    return _bytes(1);
  }
}

void main() {
  test('native and Web resize the original image from the same URL', () async {
    final source = image.encodePng(image.Image(width: 320, height: 160));
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));
    final requests = <Uri>[];
    server.listen((request) {
      requests.add(request.uri);
      request.response
        ..contentLength = source.length
        ..add(source)
        ..close();
    });
    final uri = Uri.http('127.0.0.1:${server.port}', '/preview/blob', {
      'path': '/photo.png',
      'token': 'test-token',
    });
    const option = (width: 80, height: 200, quality: 100);
    final native = await Thumbnail.create().generate(
      uri,
      mimeType: 'image/png',
      option: option,
      cache: _noCache,
    );
    expect(
      await ThumbnailWebService().generate(
        uri,
        mimeType: 'image/png',
        option: option,
      ),
      native,
    );
    final resized = image.decodeJpg(native!);
    expect((resized?.width, resized?.height), (80, 40));

    expect(
      await app.ThumbnailService().generate(
        File(
          name: 'photo.png',
          type: 'image/png',
          size: Int64(21 * 1024 * 1024),
        ),
      ),
      isNull,
    );
    expect(requests.map((request) => request.queryParameters), [
      uri.queryParameters,
      uri.queryParameters,
    ]);
  });

  test('video preference defaults off and round-trips under thumb', () {
    final setting = FileSetting.fromJson(const {});
    final legacy = FileSetting.fromJson(const {
      'thumb': {'width': 320, 'height': 320, 'quality': 60},
    });
    expect(setting.thumb.video, isFalse);
    expect(legacy.thumb.toJson(), {'video': false});
    final json =
        jsonDecode(jsonEncode(setting.copyWith.thumb(video: true)))
            as Map<String, Object?>;
    expect(json['thumb'], {'video': true});
    expect(FileSetting.fromJson(json).thumb.video, isTrue);
  });

  test(
    'the video toggle gates MKV requests and leaves images available',
    () async {
      final settings = _FileSettings();
      final service = _AppService();
      final container = ProviderContainer(
        overrides: [
          fileSettingProvider.overrideWith(() => settings),
          thumbnailServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);
      const generic = 'application/octet-stream';
      final videoFile = File(name: 'clip.MKV', type: generic);
      expect(PathUtil.isVideo(videoFile.name, type: generic), isTrue);
      expect(PathUtil.isVideo('archive.zip', type: generic), isFalse);
      expect(PathUtil.isVideo('directory.mkv', type: 'DIR'), isFalse);
      expect(
        app.ThumbnailService.mimeTypeForFile(videoFile),
        'video/x-matroska',
      );

      final video = thumbnailProvider(videoFile);
      final photo = thumbnailProvider(
        File(name: 'photo.jpg', type: 'image/jpeg'),
      );
      container.listen(video, (_, _) {});
      container.listen(photo, (_, _) {});
      expect(await container.read(video.future), isNull);
      expect(await container.read(photo.future), [1]);

      settings.enableVideo(true);
      expect(await container.read(video.future), [1]);
      settings.enableVideo(false);
      expect(await container.read(video.future), isNull);
      expect(service.generated, ['photo.jpg', 'clip.MKV']);
    },
  );

  test('cache defaults on, supports stable keys and can be disabled', () async {
    final cache = _MemoryCache();
    var generated = 0;
    final service = _QueuedService(
      (_) async => _bytes(++generated),
      cache: cache,
    );
    const key = ThumbnailCacheOption(key: 'photo-v1');

    expect(await service.request('/photo.jpg'), [1]);
    expect(
      await service.request('/photo.jpg', cache: const ThumbnailCacheOption()),
      [1],
    );
    expect(
      await service.request(
        '/photo.jpg',
        option: (width: 96, height: 96, quality: 80),
      ),
      [2],
    );
    expect(await service.request('/photo.jpg', cache: key), [3]);
    expect(await service.request('/photo.jpg', cache: key, port: 8001), [3]);
    expect(
      await service.request(
        '/photo.jpg',
        cache: const ThumbnailCacheOption(key: 'photo-v2'),
      ),
      [4],
    );
    expect(
      await service.request(
        '/photo.jpg',
        cache: const ThumbnailCacheOption(enabled: false, key: 'photo-v1'),
      ),
      [5],
    );
    expect(await cache.read(key.key), [3]);
  });

  test(
    'images and videos have separate limits, and hits bypass generation',
    () async {
      final cache = _MemoryCache();
      await cache.write('cached', _bytes(9));
      final started = <String>[];
      final firstBatch = Completer<void>();
      final release = Completer<void>();
      addTearDown(() {
        if (!release.isCompleted) release.complete();
      });
      final service = _QueuedService((path) async {
        started.add(path);
        if (started.length == 3) firstBatch.complete();
        await release.future;
        return _bytes(1);
      }, cache: cache);

      final video = service.request('/video.mp4', mimeType: 'video/mp4');
      final first = service.request('/first.jpg');
      final second = service.request('/second.png', mimeType: 'image/png');
      await firstBatch.future.timeout(const Duration(seconds: 2));
      var cancelled = false;
      final skipped = service.request(
        '/skipped.mkv',
        mimeType: 'video/x-matroska',
        isCancelled: () => cancelled,
      );
      final nextVideo = service.request(
        '/next.mkv',
        mimeType: 'video/x-matroska',
      );
      final third = service.request('/third.jpg');
      final duplicate = service.request('/first.jpg');
      final cached = await service
          .request(
            '/cached.jpg',
            cache: const ThumbnailCacheOption(key: 'cached'),
          )
          .timeout(const Duration(seconds: 2));
      expect(cached, [9]);
      expect(
        started,
        unorderedEquals(['/video.mp4', '/first.jpg', '/second.png']),
      );

      cancelled = true;
      release.complete();
      expect(await skipped, isNull);
      expect(
        await Future.wait([video, first, second, nextVideo, third, duplicate]),
        everyElement([1]),
      );
      expect(
        started,
        unorderedEquals([
          '/video.mp4',
          '/first.jpg',
          '/second.png',
          '/next.mkv',
          '/third.jpg',
        ]),
      );
    },
  );

  test('clearing the cache discards writes from earlier generation', () async {
    final cache = _MemoryCache();
    await cache.write('old', _bytes(9));
    final started = Completer<void>();
    final frame = Completer<Uint8List>();
    final service = _QueuedService((_) async {
      if (started.isCompleted) return _bytes(2);
      started.complete();
      return frame.future;
    }, cache: cache);
    const key = ThumbnailCacheOption(key: 'photo');
    final pending = service.request('/photo.jpg', cache: key);
    await started.future;
    expect(await service.clearCache(), isTrue);
    expect(cache.entries, isEmpty);

    frame.complete(_bytes(1));
    expect(await pending, [1]);
    expect(cache.entries, isEmpty);
    expect(await service.request('/photo.jpg', cache: key), [2]);
    expect(await cache.read(key.key), [2]);
  });
}

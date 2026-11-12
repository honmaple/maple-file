import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

import 'web.dart';
import 'mobile.dart';
import 'platform.dart';

export 'platform.dart'
    show ThumbnailCacheOption, ThumbnailService, ThumbnailOption;

abstract final class Thumbnail {
  static ThumbnailService create() {
    if (kIsWeb) return ThumbnailWebService();
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => ThumbnailMobileService.android(),
      TargetPlatform.iOS => ThumbnailMobileService.ios(),
      _ => ThumbnailNativeService(),
    };
  }
}

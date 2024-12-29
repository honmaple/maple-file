import 'dart:io';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';

class Util {
  static bool get isWeb {
    return kIsWeb;
  }

  static bool get isIOS {
    return !kIsWeb && Platform.isIOS;
  }

  static bool get isAndroid {
    return !kIsWeb && Platform.isAndroid;
  }

  static bool get isMacos {
    return !kIsWeb && Platform.isMacOS;
  }

  static bool get isLinux {
    return !kIsWeb && Platform.isLinux;
  }

  static bool get isWindows {
    return !kIsWeb && Platform.isWindows;
  }

  static bool get isMobile {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  static bool get isDesktop {
    if (kIsWeb) {
      return false;
    }
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  static String mimeType(String name) {
    return lookupMimeType(name) ?? "";
  }

  static String formatSize(int size) {
    if (size == 0) {
      return "0";
    } else if (size < 1024) {
      return '${size}B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(2)}KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / 1024 / 1024).toStringAsFixed(2)}MB';
    } else {
      return '${(size / 1024 / 1024 / 1024).toStringAsFixed(2)}GB';
    }
  }
}

import 'dart:io';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';

class Util {
  static isWeb() {
    return kIsWeb;
  }

  static isIOS() {
    return !kIsWeb && Platform.isIOS;
  }

  static isAndroid() {
    return !kIsWeb && Platform.isAndroid;
  }

  static isMacos() {
    return !kIsWeb && Platform.isMacOS;
  }

  static isLinux() {
    return !kIsWeb && Platform.isLinux;
  }

  static isWindows() {
    return !kIsWeb && Platform.isWindows;
  }

  static isMobile() {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  static isDesktop() {
    if (kIsWeb) {
      return false;
    }
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  static String mimeType(String name) {
    return lookupMimeType(name) ?? "";
  }
}

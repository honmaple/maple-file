import 'dart:io';
import 'package:mime/mime.dart';
import 'package:flutter/foundation.dart';
import 'package:network_info_plus/network_info_plus.dart';

class Util {
  static bool get isWeb {
    return kIsWeb;
  }

  static bool get isIOS {
    return Platform.isIOS;
  }

  static bool get isAndroid {
    return Platform.isAndroid;
  }

  static bool get isMacOS {
    return Platform.isMacOS;
  }

  static bool get isLinux {
    return Platform.isLinux;
  }

  static bool get isWindows {
    return Platform.isWindows;
  }

  static bool get isMobile {
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool get isDesktop {
    if (kIsWeb) {
      return false;
    }
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  static String? get fontFamily {
    // if (Platform.isIOS) {
    //   return "PingFang SC";
    // }
    if (Platform.isWindows) {
      return "Microsoft YaHei";
    }
    return null;
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

  static bool isPrivateIP(String ip) {
    final List<String> masks = ["10.", "172.16.", "192.168."];
    for (final mask in masks) {
      if (ip.startsWith(mask)) {
        return true;
      }
    }
    return false;
  }

  static Future<String?> localIP() async {
    String? ip;

    try {
      ip = await NetworkInfo().getWifiIP();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    if (ip == null || ip == "") {
      for (final interface
          in await NetworkInterface.list(type: InternetAddressType.IPv4)) {
        for (final addr in interface.addresses) {
          if (isPrivateIP(addr.address)) {
            return addr.address;
          }
        }
      }
    }
    return ip;
  }
}

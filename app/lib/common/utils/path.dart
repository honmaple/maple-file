import 'dart:io' show Directory, Platform, File;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as filepath;
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';

class PathUtil {
  static Future<String> getDownloadsPath() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS,
        );
        return dir != "" ? dir : '/storage/emulated/0/Download';
      case TargetPlatform.iOS:
        return (await getApplicationDocumentsDirectory()).path;
      default:
        var downloadDir = await getDownloadsDirectory();
        if (downloadDir == null) {
          if (defaultTargetPlatform == TargetPlatform.windows) {
            downloadDir =
                Directory('${Platform.environment['HOMEPATH']}/Downloads');
            if (!downloadDir.existsSync()) {
              downloadDir = Directory(Platform.environment['HOMEPATH']!);
            }
          } else {
            downloadDir =
                Directory('${Platform.environment['HOME']}/Downloads');
            if (!downloadDir.existsSync()) {
              downloadDir = Directory(Platform.environment['HOME']!);
            }
          }
        }
        return downloadDir.path.replaceAll('\\', '/');
    }
  }

  static RegExp exp = RegExp(r'(.*?)\.(\d+)$');

  static String autoRename(String path) {
    if (File(path).existsSync()) {
      final match = exp.firstMatch(path);
      if (match == null) {
        return autoRename("$path.1");
      }
      final next = int.parse(match[2]!) + 1;
      return autoRename("${match[1]}.$next");
    }
    return path;
  }
}

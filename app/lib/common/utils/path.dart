import 'dart:io' show Directory, Platform, File;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
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

  static String mimeType(String name) {
    return lookupMimeType(name) ?? "";
  }

  static IconData icon(String name, {String? type}) {
    if (type == null || type == "") {
      type = mimeType(name);
    }
    if (type == "DIR") {
      return Icons.folder;
    } else if (type.startsWith("text/")) {
      return Icons.note;
    } else if (type.startsWith("image/")) {
      return Icons.image;
    } else if (type.startsWith("video/")) {
      return Icons.video_file;
    } else if (type.startsWith("audio/")) {
      return Icons.audio_file;
    }
    Map<String, IconData> icons = {
      ".apk": Icons.android,
    };
    return icons[filepath.extension(name)] ?? Icons.note;
  }

  static bool isText(String name, {String? type}) {
    if (type == null || type == "") {
      type = mimeType(name);
    }
    return type.startsWith("text/");
  }

  static bool isImage(String name, {String? type}) {
    if (type == null || type == "") {
      type = mimeType(name);
    }
    return type.startsWith("image/");
  }

  static bool isVideo(String name, {String? type}) {
    if (type == null || type == "") {
      type = mimeType(name);
    }
    return type.startsWith("video/");
  }

  static bool isAudio(String name, {String? type}) {
    if (type == null || type == "") {
      type = mimeType(name);
    }
    return type.startsWith("audio/");
  }

  static bool isMedia(String name, {String? type}) {
    if (type == null || type == "") {
      type = mimeType(name);
    }
    return isImage(name, type: type) || isVideo(name, type: type);
  }

  static bool isFolder(String name, {String? type}) {
    return type == "DIR" || name.endsWith("/");
  }
}

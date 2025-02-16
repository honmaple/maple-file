import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:macos_secure_bookmarks/macos_secure_bookmarks.dart";

import "package:maple_file/app/app.dart";
import "package:maple_file/common/utils/util.dart";

import 'setting.dart';

const _bookmark = "app.macos.bookmark";

Future<void> loadBookmark(
  String bookmark, {
  SecureBookmarks? secureBookmarks,
}) async {
  if (!Util.isMacOS) {
    return;
  }

  try {
    secureBookmarks ??= SecureBookmarks();

    final resolvedFile = await secureBookmarks.resolveBookmark(
      bookmark,
      isDirectory: true,
    );
    await secureBookmarks.startAccessingSecurityScopedResource(resolvedFile);
  } catch (e) {
    App.logger.warning(e.toString());
  }
}

Future<void> loadBookmarks(ProviderContainer container) async {
  if (!Util.isMacOS) {
    return;
  }
  await container.read(bookmarkProvider.notifier).init();

  final bookmarks = container.read(bookmarkProvider);
  final secureBookmarks = SecureBookmarks();

  for (final entry in bookmarks.entries) {
    await loadBookmark(entry.value, secureBookmarks: secureBookmarks);
  }
}

Map<String, String> bookmarkFromJson(Map<String, dynamic> json) {
  return json.map((key, value) => MapEntry(key, value.toString()));
}

final bookmarkProvider = newSettingNotifier(
  _bookmark,
  Map<String, String>.from({}),
  bookmarkFromJson,
);

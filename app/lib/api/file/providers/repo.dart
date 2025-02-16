import 'dart:io' as io;
import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:macos_secure_bookmarks/macos_secure_bookmarks.dart";

import "package:maple_file/common/utils/util.dart";
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';
import 'package:maple_file/api/setting/providers/setting_bookmark.dart';

import 'service.dart';

class RepoNotifier extends AsyncNotifier<List<Repo>> {
  final _service = FileService();

  @override
  FutureOr<List<Repo>> build() async {
    return await _service.listRepos();
  }

  Future<void> saveBookmarks() async {
    if (!Util.isMacOS) {
      return;
    }
    final bookmarks = ref.read(bookmarkProvider);
    final secureBookmarks = SecureBookmarks();

    Map<String, String> newBookmarks = {};

    final repos = await future;
    for (final repo in repos) {
      if (repo.driver != "local") {
        continue;
      }
      final option = jsonDecode(repo.option) as Map<String, dynamic>;
      final path = option["path"] as String;
      if (bookmarks.containsKey(path)) {
        newBookmarks[path] = bookmarks[path]!;
      } else {
        newBookmarks[path] = await secureBookmarks.bookmark(
          io.Directory(path),
        );
      }
    }
    ref.read(bookmarkProvider.notifier).update((_) {
      return newBookmarks;
    });
  }
}

final repoProvider = AsyncNotifierProvider<RepoNotifier, List<Repo>>(() {
  return RepoNotifier();
});

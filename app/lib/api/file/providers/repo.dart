import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:macos_secure_bookmarks/macos_secure_bookmarks.dart";

import "package:maple_file/app/app.dart";
import "package:maple_file/common/utils/util.dart";
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import 'service.dart';

class RepoNotifier extends AsyncNotifier<List<Repo>> {
  @override
  FutureOr<List<Repo>> build() async {
    return await FileService.instance.listRepos();
  }
}

Future<void> loadBookmark(
  String bookmark, {
  SecureBookmarks? secureBookmarks,
}) async {
  if (!Util.isMacOS) {
    return;
  }
  if (bookmark == "") {
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
  final secureBookmarks = SecureBookmarks();

  final repos = await container.refresh(repoProvider.future);
  for (final repo in repos) {
    if (repo.driver != "local") {
      continue;
    }
    final option = jsonDecode(repo.option) as Map<String, dynamic>;
    await loadBookmark(
      option["bookmark"] ?? "",
      secureBookmarks: secureBookmarks,
    );
  }
}

final repoProvider = AsyncNotifierProvider<RepoNotifier, List<Repo>>(() {
  return RepoNotifier();
});

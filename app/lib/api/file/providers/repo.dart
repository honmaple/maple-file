import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:grpc/grpc.dart';
import "package:macos_secure_bookmarks/macos_secure_bookmarks.dart";

import "package:maple_file/app/app.dart";
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/app/i18n.dart';
import "package:maple_file/common/utils/util.dart";
import 'package:maple_file/generated/proto/api/file/repo.pbgrpc.dart';

class RepoService {
  static RepoService get instance => _instance;
  static final RepoService _instance = RepoService._internal();
  factory RepoService() => _instance;
  RepoService._internal();

  RepoServiceClient? _client;
  DateTime _clientTime = DateTime.now();

  RepoServiceClient get client {
    if (_client == null || Grpc.instance.connectTime.isAfter(_clientTime)) {
      _client = RepoServiceClient(
        Grpc.instance.client,
        options: CallOptions(
          metadata: {"Authorization": "Bearer ${Grpc.instance.token}"},
        ),
      );
      _clientTime = Grpc.instance.connectTime;
    }
    return _client!;
  }

  Future<List<Repo>> list({
    Map<String, String>? filter,
    bool showError = true,
  }) {
    return doFuture(() async {
      Repo_ListRequest request = Repo_ListRequest(filter: filter);
      Repo_ListResponse response = await client.listRepos(request);
      return response.results;
    }, showError: showError);
  }

  Future<void> test(Repo payload) {
    return doFuture(() {
      Repo_TestRequest request = Repo_TestRequest(payload: payload);
      return client.testRepo(request).then((_) {
        SmartDialog.showNotify(
          msg: "连接成功".tr(),
          notifyType: NotifyType.warning,
        );
      });
    });
  }

  Future<Repo> create(Repo payload) {
    return doFuture(() async {
      Repo_CreateRequest request = Repo_CreateRequest(payload: payload);
      Repo_CreateResponse response = await client.createRepo(request);
      return response.result;
    });
  }

  Future<Repo> update(Repo payload) {
    return doFuture(() async {
      Repo_UpdateRequest request = Repo_UpdateRequest(payload: payload);
      Repo_UpdateResponse response = await client.updateRepo(request);
      return response.result;
    });
  }

  Future<void> delete(int id) {
    return doFuture(() {
      Repo_DeleteRequest request = Repo_DeleteRequest(id: id);
      return client.deleteRepo(request);
    });
  }
}

class RepoNotifier extends AsyncNotifier<List<Repo>> {
  @override
  FutureOr<List<Repo>> build() async {
    return await RepoService.instance.list();
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

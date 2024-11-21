import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import 'service.dart';

class RepoNotifier extends AsyncNotifier<List<Repo>> {
  final _service = FileService();

  @override
  FutureOr<List<Repo>> build() async {
    return await _service.listRepos();
  }
}

final repoProvider = AsyncNotifierProvider<RepoNotifier, List<Repo>>(() {
  return RepoNotifier();
});

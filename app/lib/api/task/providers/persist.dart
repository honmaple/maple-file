import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/generated/proto/api/task/persist.pb.dart';

import 'service.dart';

class PersistTaskNotifier extends AsyncNotifier<List<PersistTask>> {
  final _service = TaskService();

  @override
  FutureOr<List<PersistTask>> build() async {
    return await _service.listPersistTasks();
  }
}

final persistTaskProvider =
    AsyncNotifierProvider<PersistTaskNotifier, List<PersistTask>>(() {
  return PersistTaskNotifier();
});

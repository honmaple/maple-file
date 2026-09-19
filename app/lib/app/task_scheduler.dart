import 'dart:async';

import 'package:flutter/foundation.dart';

typedef AppTaskCallback<T> = Future<T> Function();

/// Schedules tasks that must keep running while the application process lives.
///
/// Tasks with the same ID share one execution. This service does not provide
/// operating-system background execution or persistence across app restarts.
class AppTaskScheduler extends ChangeNotifier {
  AppTaskScheduler();

  static final AppTaskScheduler instance = AppTaskScheduler();

  final Map<String, Future<dynamic>> _tasks = {};

  Set<String> get runningTaskIds => Set.unmodifiable(_tasks.keys);

  bool isRunning(String taskId) => _tasks.containsKey(taskId);

  Future<T> schedule<T>({
    required String taskId,
    required AppTaskCallback<T> task,
  }) {
    final existing = _tasks[taskId];
    if (existing != null) {
      return existing.then((value) => value as T);
    }

    final completer = Completer<T>();
    _tasks[taskId] = completer.future;
    notifyListeners();
    unawaited(_execute(taskId, task, completer));
    return completer.future;
  }

  Future<void> _execute<T>(
    String taskId,
    AppTaskCallback<T> task,
    Completer<T> completer,
  ) async {
    try {
      completer.complete(await task());
    } catch (error, stackTrace) {
      completer.completeError(error, stackTrace);
    } finally {
      _tasks.remove(taskId);
      notifyListeners();
    }
  }
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:maple_file/app/task_scheduler.dart';

void main() {
  test('scheduled task keeps running without its original caller', () async {
    final scheduler = AppTaskScheduler();
    final completion = Completer<int>();

    final task = scheduler.schedule(
      taskId: 'backup:1',
      task: () => completion.future,
    );

    expect(scheduler.isRunning('backup:1'), isTrue);
    completion.complete(7);
    expect(await task, 7);
    await pumpEventQueue();
    expect(scheduler.isRunning('backup:1'), isFalse);
  });

  test('tasks with the same ID share one execution', () async {
    final scheduler = AppTaskScheduler();
    final completion = Completer<int>();
    var executions = 0;

    Future<int> operation() {
      executions++;
      return completion.future;
    }

    final first = scheduler.schedule(taskId: 'backup:1', task: operation);
    final second = scheduler.schedule(taskId: 'backup:1', task: operation);
    completion.complete(9);

    expect(await Future.wait([first, second]), [9, 9]);
    expect(executions, 1);
  });
}

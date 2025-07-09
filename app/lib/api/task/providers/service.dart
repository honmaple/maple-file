import 'dart:async';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/task/service.pbgrpc.dart';
import 'package:maple_file/generated/proto/api/task/task.pb.dart';
import 'package:maple_file/generated/proto/api/task/persist.pb.dart';

class TaskService {
  static TaskService get instance => _instance;
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;

  late TaskServiceClient _client;
  late DateTime _clientTime;

  TaskService._internal() {
    _setClient();
  }

  TaskServiceClient get client {
    if (GRPC.instance.connectTime.isAfter(_clientTime)) {
      _setClient();
    }
    return _client;
  }

  void _setClient() {
    _client = TaskServiceClient(
      GRPC.instance.client,
    );
    _clientTime = GRPC.instance.connectTime;
  }

  Future<List<Task>> listTasks({Map<String, String>? filterMap}) async {
    ListTasksRequest request = ListTasksRequest();
    ListTasksResponse response = await client.listTasks(request);
    return response.results;
  }

  Future<void> removeTask(List<String> tasks) async {
    await doFuture(() {
      RemoveTaskRequest request = RemoveTaskRequest(
        tasks: tasks,
      );
      return client.removeTask(request);
    });
  }

  Future<void> cancelTask(List<String> tasks) async {
    await doFuture(() {
      CancelTaskRequest request = CancelTaskRequest(
        tasks: tasks,
      );
      return client.cancelTask(request);
    });
  }

  Future<void> retryTask(List<String> tasks) async {
    await doFuture(() {
      RetryTaskRequest request = RetryTaskRequest(
        tasks: tasks,
      );
      return client.retryTask(request);
    });
  }

  Future<List<PersistTask>> listPersistTasks(
      {Map<String, String>? filterMap}) async {
    return doFuture(() async {
      ListPersistTasksRequest request = ListPersistTasksRequest();
      ListPersistTasksResponse response =
          await client.listPersistTasks(request);
      return response.results;
    });
  }

  Future<PersistTask> createPersistTask(PersistTask payload) {
    return doFuture(() async {
      CreatePersistTaskRequest request =
          CreatePersistTaskRequest(payload: payload);
      CreatePersistTaskResponse response =
          await client.createPersistTask(request);
      return response.result;
    });
  }

  Future<PersistTask> updatePersistTask(PersistTask payload) {
    return doFuture(() async {
      UpdatePersistTaskRequest request =
          UpdatePersistTaskRequest(payload: payload);
      UpdatePersistTaskResponse response =
          await client.updatePersistTask(request);
      return response.result;
    });
  }

  Future<void> deletePersistTask(int id) {
    return doFuture(() {
      DeletePersistTaskRequest request = DeletePersistTaskRequest(id: id);
      return client.deletePersistTask(request);
    });
  }

  Future<void> testPersistTask(PersistTask payload) {
    return doFuture(() {
      TestPersistTaskRequest request = TestPersistTaskRequest(payload: payload);

      return client.testPersistTask(request);
    });
  }

  Future<void> executePersistTask(int id) {
    return doFuture(() {
      ExecutePersistTaskRequest request = ExecutePersistTaskRequest(id: id);

      return client.executePersistTask(request);
    }).then((_) {
      SmartDialog.showNotify(
          msg: "执行成功，请转至任务列表查看".tr(), notifyType: NotifyType.success);
    });
  }
}

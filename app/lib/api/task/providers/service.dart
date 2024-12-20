import 'dart:async';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/task/service.pbgrpc.dart';
import 'package:maple_file/generated/proto/api/task/task.pb.dart';
import 'package:maple_file/generated/proto/api/task/persist.pb.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();

  factory TaskService() => _instance;

  late final TaskServiceClient _client;

  TaskService._internal() {
    _client = TaskServiceClient(
      GRPC().client,
      // interceptors: [AccountInterceptor()],
    );
  }

  TaskServiceClient get client {
    return _client;
  }

  Future<List<Task>> listTasks({Map<String, String>? filterMap}) async {
    ListTasksRequest request = ListTasksRequest();
    ListTasksResponse response = await _client.listTasks(request);
    return response.results;
  }

  Future<void> removeTask(List<String> tasks) async {
    await doFuture(() {
      RemoveTaskRequest request = RemoveTaskRequest(
        tasks: tasks,
      );
      return _client.removeTask(request);
    });
  }

  Future<void> cancelTask(List<String> tasks) async {
    await doFuture(() {
      CancelTaskRequest request = CancelTaskRequest(
        tasks: tasks,
      );
      return _client.cancelTask(request);
    });
  }

  Future<void> retryTask(List<String> tasks) async {
    await doFuture(() {
      RetryTaskRequest request = RetryTaskRequest(
        tasks: tasks,
      );
      return _client.retryTask(request);
    });
  }

  Future<List<PersistTask>> listPersistTasks(
      {Map<String, String>? filterMap}) async {
    final result = await doFuture(() async {
      ListPersistTasksRequest request = ListPersistTasksRequest();
      ListPersistTasksResponse response =
          await _client.listPersistTasks(request);
      return response.results;
    });
    return result.data ?? <PersistTask>[];
  }

  Future<Response<PersistTask>> createPersistTask(PersistTask payload) {
    return doFuture(() async {
      CreatePersistTaskRequest request =
          CreatePersistTaskRequest(payload: payload);
      CreatePersistTaskResponse response =
          await _client.createPersistTask(request);
      return response.result;
    });
  }

  Future<Response<PersistTask>> updatePersistTask(PersistTask payload) {
    return doFuture(() async {
      UpdatePersistTaskRequest request =
          UpdatePersistTaskRequest(payload: payload);
      UpdatePersistTaskResponse response =
          await _client.updatePersistTask(request);
      return response.result;
    });
  }

  Future<void> deletePersistTask(int id) {
    return doFuture(() {
      DeletePersistTaskRequest request = DeletePersistTaskRequest(id: id);
      return _client.deletePersistTask(request);
    });
  }

  Future<void> executePersistTask(int id) {
    return doFuture(() {
      ExecutePersistTaskRequest request = ExecutePersistTaskRequest(id: id);

      return _client.executePersistTask(request);
    });
  }
}

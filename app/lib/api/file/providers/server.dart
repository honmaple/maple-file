import 'dart:async';
import 'dart:convert';

import 'package:grpc/grpc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/file/server.pbgrpc.dart'
    as serverpb;

part 'server.g.dart';

class ServerService {
  static ServerService get instance => _instance;
  static final ServerService _instance = ServerService._internal();
  factory ServerService() => _instance;
  ServerService._internal();

  serverpb.ServerServiceClient? _client;
  DateTime _clientTime = DateTime.now();

  serverpb.ServerServiceClient get client {
    if (_client == null || Grpc.instance.connectTime.isAfter(_clientTime)) {
      _client = serverpb.ServerServiceClient(
        Grpc.instance.client,
        options: CallOptions(
          metadata: {"Authorization": "Bearer ${Grpc.instance.token}"},
        ),
      );
      _clientTime = Grpc.instance.connectTime;
    }
    return _client!;
  }

  Future<serverpb.Server> start(String type, {Map<String, dynamic>? option}) {
    return doFuture(() async {
      var request = serverpb.Server_StartRequest(
        type: type,
        option: jsonEncode(option),
      );
      var response = await client.startServer(request);
      return response.result;
    });
  }

  Future<void> stop(String type) {
    return doFuture(() async {
      var request = serverpb.Server_StopRequest(type: type);
      await client.stopServer(request);
    });
  }

  Future<serverpb.Server> status(String type) {
    return doFuture(() async {
      var request = serverpb.Server_GetRequest(type: type);
      var response = await client.serverStatus(request);
      return response.result;
    });
  }
}

@Riverpod(keepAlive: true)
class ServerNotifier extends _$ServerNotifier {
  @override
  Future<serverpb.Server> build(String type) {
    return ServerService.instance.status(type);
  }
}

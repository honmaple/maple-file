import 'dart:async';
import 'dart:convert';

import 'package:grpc/grpc.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/file/server.pbgrpc.dart'
    as serverpb;

part 'server.g.dart';

class ExternalServerService {
  static ExternalServerService get instance => _instance;
  static final ExternalServerService _instance =
      ExternalServerService._internal();
  factory ExternalServerService() => _instance;
  ExternalServerService._internal();

  serverpb.ExternalServerServiceClient? _client;
  DateTime _clientTime = DateTime.now();

  serverpb.ExternalServerServiceClient get client {
    if (_client == null || Grpc.instance.connectTime.isAfter(_clientTime)) {
      _client = serverpb.ExternalServerServiceClient(
        Grpc.instance.client,
        options: CallOptions(
          metadata: {"Authorization": "Bearer ${Grpc.instance.token}"},
        ),
      );
      _clientTime = Grpc.instance.connectTime;
    }
    return _client!;
  }

  Future<serverpb.ExternalServer> start(String type,
      {Map<String, dynamic>? option}) {
    return doFuture(() async {
      var request = serverpb.ExternalServer_StartRequest(
        type: type,
        option: jsonEncode(option),
      );
      var response = await client.startServer(request);
      return response.result;
    });
  }

  Future<void> stop(String type) {
    return doFuture(() async {
      var request = serverpb.ExternalServer_StopRequest(type: type);
      await client.stopServer(request);
    });
  }

  Future<serverpb.ExternalServer> status(String type) {
    return doFuture(() async {
      var request = serverpb.ExternalServer_GetRequest(type: type);
      var response = await client.serverStatus(request);
      return response.result;
    });
  }
}

@Riverpod(keepAlive: true)
class ServerNotifier extends _$ServerNotifier {
  @override
  Future<serverpb.ExternalServer> build(String type) {
    return ExternalServerService.instance.status(type);
  }
}

import 'dart:convert';

import 'package:grpc/grpc.dart';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/setting/info.pb.dart';
import 'package:maple_file/generated/proto/api/setting/setting.pb.dart';
import 'package:maple_file/generated/proto/api/setting/service.pbgrpc.dart';

class SystemService {
  static SystemService get instance => _instance;
  static final SystemService _instance = SystemService._internal();
  factory SystemService() => _instance;
  SystemService._internal();

  SystemServiceClient? _client;
  DateTime _clientTime = DateTime.now();

  SystemServiceClient get client {
    if (_client == null || Grpc.instance.connectTime.isAfter(_clientTime)) {
      _client = SystemServiceClient(
        Grpc.instance.client,
        options: CallOptions(
          metadata: {"Authorization": "Bearer ${Grpc.instance.token}"},
        ),
      );
      _clientTime = Grpc.instance.connectTime;
    }
    return _client!;
  }

  Future<Info> info() async {
    return doFuture(() async {
      InfoRequest request = InfoRequest();
      InfoResponse response = await client.info(request);
      return response.result;
    });
  }

  Future<String> getSetting(String key) async {
    GetSettingRequest request = GetSettingRequest(key: key);
    GetSettingResponse response = await client.getSetting(request);
    return response.result.value;
  }

  Future<void> updateSetting(String key, Object? value) {
    return doFuture(() async {
      UpdateSettingRequest request = UpdateSettingRequest(
        key: key,
        value: jsonEncode(value),
      );
      await client.updateSetting(request);
    });
  }
}

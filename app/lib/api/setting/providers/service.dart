import 'dart:convert';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/setting/info.pb.dart';
import 'package:maple_file/generated/proto/api/setting/setting.pb.dart';
import 'package:maple_file/generated/proto/api/setting/service.pbgrpc.dart';

class SystemService {
  static SystemService get instance => _instance;
  static final SystemService _instance = SystemService._internal();
  factory SystemService() => _instance;

  late SystemServiceClient _client;
  late DateTime _clientTime;

  SystemService._internal() {
    _setClient();
  }

  SystemServiceClient get client {
    if (GRPC.instance.connectTime.isAfter(_clientTime)) {
      _setClient();
    }
    return _client;
  }

  void _setClient() {
    _client = SystemServiceClient(
      GRPC.instance.client,
    );
    _clientTime = GRPC.instance.connectTime;
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

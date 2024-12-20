import 'dart:convert';

import 'package:maple_file/app/grpc.dart';
import 'package:maple_file/generated/proto/api/setting/info.pb.dart';
import 'package:maple_file/generated/proto/api/setting/setting.pb.dart';
import 'package:maple_file/generated/proto/api/setting/service.pbgrpc.dart';

class SystemService {
  static final SystemService _instance = SystemService._internal();

  factory SystemService() => _instance;

  late final SystemServiceClient _client;

  SystemService._internal() {
    _client = SystemServiceClient(
      GRPC().client,
      // interceptors: [AccountInterceptor()],
    );
  }

  SystemServiceClient get client {
    return _client;
  }

  Future<Info> info() async {
    final result = await doFuture(() async {
      InfoRequest request = InfoRequest();
      InfoResponse response = await _client.info(request);
      return response.result;
    });
    return result.data ??
        Info(
          os: "unknown",
          arch: "unknown",
          runtime: "unknown",
          version: "unknown",
        );
  }

  Future<String> getSetting(String key) async {
    GetSettingRequest request = GetSettingRequest(key: key);
    GetSettingResponse response = await _client.getSetting(request);
    return response.result.value;
  }

  Future<void> updateSetting(String key, Object? value) {
    return doFuture(() async {
      UpdateSettingRequest request = UpdateSettingRequest(
        key: key,
        value: jsonEncode(value),
      );
      await _client.updateSetting(request);
    });
  }
}

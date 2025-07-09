import 'dart:io';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:grpc/grpc.dart';
import 'package:grpc/service_api.dart' as grpcapi;

import 'app.dart';
import 'grpc_web.dart' if (dart.library.io) 'grpc_io.dart';

Future<T> doFuture<T>(
  Future<T> Function() callback, {
  bool showError = true,
}) async {
  String err;
  try {
    return await callback();
  } on GrpcError catch (e) {
    err = e.message ?? e.toString();
  } catch (e) {
    err = e.toString();
  }
  if (showError) {
    SmartDialog.showNotify(msg: err, notifyType: NotifyType.error);
  } else {
    App.logger.warning(err);
  }
  return Future.error(err);
}

class GRPC {
  static GRPC get instance => _instance;
  static final GRPC _instance = GRPC._internal();

  factory GRPC() => _instance;

  late GrpcService _service;

  GRPC._internal() {
    // App.logger.info("init grpc");

    _service = GrpcService();
  }

  String get addr => _service.addr;
  grpcapi.ClientChannel get client => _service.client;

  DateTime connectTime = DateTime.now();

  Future<void> init() async {
    await _service.start();
    connectTime = DateTime.now();
  }

  Future<bool> check() async {
    try {
      final addrs = addr.split(":");
      final socket = await Socket.connect(addrs[0], int.parse(addrs[1]));
      socket.destroy();
      return true;
    } catch (e) {
      App.logger.warning("connect $addr failed: $e");
      return false;
    }
  }

  Future<void> checkAlive() async {
    final result = await check();
    if (result) {
      return;
    }

    App.logger.info("reboot server");

    await _service.restart();
    connectTime = DateTime.now();
  }

  String previewURL(String path) {
    return "http://$addr/api/file/preview/blob?path=$path";
  }

  String downloadURL(String path) {
    return "http://$addr/api/file/download/blob?path=$path";
  }
}

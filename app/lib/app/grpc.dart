import 'dart:io';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:grpc/grpc.dart';
import 'package:grpc/service_api.dart' as grpcapi;

import 'app.dart';
import 'grpc/web.dart' if (dart.library.io) 'grpc/io.dart';

Future<T> doFuture<T>(
  Future<T> Function() callback, {
  bool showError = true,
}) async {
  String err;
  try {
    return await callback();
  } on GrpcError catch (e) {
    err = e.message ?? e.toString();
  } on SocketException catch (e) {
    err = e.message;
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

class Grpc {
  static Grpc get instance => _instance;
  static final Grpc _instance = Grpc._internal();

  factory Grpc() => _instance;

  late GrpcService _service;

  Grpc._internal() {
    App.logger.info("init grpc");

    _service = GrpcService();
  }

  String? get error => _error;
  String get token => _result.token;
  DateTime get connectTime => _result.clientTime;
  grpcapi.ClientChannel get client => _result.client;
  Map<String, String> get metadata => {
        "Authorization": "Bearer ${Grpc.instance.token}",
      };

  String? _error;
  GrpcResult _result = GrpcResult.empty();

  Future<void> init() async {
    try {
      _error = null;
      _result = await _service.start();
    } catch (e) {
      _error = e.toString();
      App.logger.warning("start server fail: $_error");
    }
  }

  Future<bool> check() async {
    try {
      final socket = await Socket.connect(_result.host, _result.port);
      socket.destroy();
      return true;
    } catch (e) {
      App.logger.warning("connect ${_result.addr} failed: $e");
      return false;
    }
  }

  Future<void> checkAlive() async {
    final result = await check();
    if (result) {
      return;
    }

    App.logger.info("reboot server");
    try {
      _error = null;
      _result = await _service.restart();
    } catch (e) {
      _error = e.toString();
      App.logger.warning("reboot server fail: $_error");
    }
  }

  String previewURL(String path) {
    path = Uri.encodeComponent(path);
    return "http://${_result.addr}/api/file/preview/blob?path=$path&token=${_result.token}";
  }

  String downloadURL(String path) {
    path = Uri.encodeComponent(path);
    return "http://${_result.addr}/api/file/download/blob?path=$path&token=${_result.token}";
  }
}

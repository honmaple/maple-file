import 'package:flutter/material.dart';

import 'package:grpc/grpc.dart';
import 'package:grpc/service_api.dart' as grpcapi;

import 'app.dart';
import 'grpc_web.dart' if (dart.library.io) 'grpc_io.dart';

class Response<T> {
  final T? data;
  final String? error;

  const Response({this.data, this.error});

  bool get hasErr => error != null;
  bool get hasData => data != null;
}

Future<Response<T>> doFuture<T>(
  Future<T> Function() callback, {
  bool showError = true,
}) async {
  String err;
  try {
    return Response(data: await callback());
  } on GrpcError catch (e) {
    err = e.message ?? e.toString();
  } catch (e) {
    err = e.toString();
  }
  if (showError) {
    App.showSnackBar(Text(err));
  } else {
    App.logger.warning(err);
  }
  return Response(error: err);
}

class GRPC {
  GRPC._internal() {
    App.logger.info("init grpc");
  }

  static final GRPC _instance = GRPC._internal();

  factory GRPC() => _instance;

  static GRPC get instance => _instance;

  late GrpcService _service;

  Future<void> init() async {
    _service = GrpcService();
    await _service.init();
  }

  String get addr {
    return _service.addr;
  }

  grpcapi.ClientChannel get client {
    return _service.client;
  }

  String previewURL(String path) {
    return "http://$addr/api/file/preview/blob?path=$path";
  }

  String downloadURL(String path) {
    return "http://$addr/api/file/download/blob?path=$path";
  }
}

import 'dart:ffi' as ffi;
import 'dart:async';
import 'dart:convert';
import 'package:grpc/grpc.dart';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

import './stub.dart';

import '../../common/utils/util.dart';
import '../../common/utils/path.dart';
import '../../generated/ffi/libserver.dart';

export 'stub.dart';

abstract class GrpcIOService {
  Future<String> start(Map<String, dynamic> cfg);
  Future<void> stop();
}

class GrpcFFIService implements GrpcIOService {
  late LibserverBind _lib;

  GrpcFFIService() {
    var libname = "libserver";
    if (Util.isWindows) {
      libname += ".dll";
    } else if (Util.isMacOS) {
      libname += ".dylib";
    } else if (Util.isLinux) {
      libname += ".so";
    }

    // ffi.Char
    _lib = LibserverBind(ffi.DynamicLibrary.open(libname));
  }

  // https://docs.flutter.dev/platform-integration/macos/c-interop
  @override
  Future<String> start(Map<String, dynamic> cfg) async {
    // ffi.Char
    final result = _lib.Start(jsonEncode(cfg).toNativeUtf8().cast());
    if (result.r1.address == ffi.nullptr.address) {
      return Future.value(result.r0.cast<Utf8>().toDartString());
    }
    return Future.error(result.r1.cast<Utf8>().toDartString());
  }

  @override
  Future<void> stop() async {
    _lib.Stop();
  }
}

class GrpcChannelService implements GrpcIOService {
  static const platform = MethodChannel("honmaple.com/maple_file");

  @override
  Future<String> start(Map<String, dynamic> cfg) async {
    return await platform.invokeMethod("Start", jsonEncode(cfg));
  }

  @override
  Future<void> stop() async {
    return await platform.invokeMethod("Stop");
  }
}

class GrpcService {
  late GrpcResult _result;
  GrpcResult get result => _result;

  late GrpcIOService _service;

  GrpcService() {
    if (Util.isDesktop) {
      _service = GrpcFFIService();
    } else {
      _service = GrpcChannelService();
    }
  }

  Future<GrpcResult> start() async {
    final Map<String, dynamic> cfg = {
      "path": await PathUtil.getApplicationPath(),
    };

    final result = jsonDecode(await _service.start(cfg));

    final addrs = result["addr"].split(":");
    final host = addrs[0];
    final port = int.parse(addrs[1]);

    _result = GrpcResult(
      host: host,
      port: port,
      token: result["token"] ?? "",
      client: ClientChannel(
        host,
        port: port,
        options: ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      ),
    );
    return _result;
  }

  Future<void> stop() async {
    await _service.stop();
  }

  Future<GrpcResult> restart() async {
    await stop();
    return await start();
  }
}

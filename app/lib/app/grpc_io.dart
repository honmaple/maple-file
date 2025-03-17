import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:grpc/grpc.dart';
import 'package:grpc/service_api.dart' as grpcapi;
import 'package:ffi/ffi.dart';

import 'package:flutter/services.dart';

import '../common/utils/util.dart';
import '../common/utils/path.dart';
import '../generated/ffi/libserver.dart';

abstract class GrpcIOService {
  Future<String> start();
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
  Future<String> start() async {
    final Map<String, dynamic> args = {
      'path': await PathUtil.getApplicationPath(),
    };

    // ffi.Char
    final result = _lib.Start(jsonEncode(args).toNativeUtf8().cast());
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
  Future<String> start() async {
    final path = await PathUtil.getApplicationPath();
    final Map<String, dynamic> args = {
      'path': path,
    };
    return await platform.invokeMethod("Start", jsonEncode(args));
  }

  @override
  Future<void> stop() async {
    return await platform.invokeMethod("Stop");
  }
}

class GrpcService {
  late String _addr;
  late grpcapi.ClientChannel _client;

  String get addr => _addr;
  grpcapi.ClientChannel get client => _client;

  late GrpcIOService _service;

  GrpcService() {
    if (Util.isDesktop) {
      _service = GrpcFFIService();
    } else {
      _service = GrpcChannelService();
    }
  }

  Future<void> start() async {
    _addr = await _service.start();
    _client = _createChannel(_addr);
  }

  Future<void> stop() async {
    await _service.stop();
  }

  Future<void> restart() async {
    await stop();
    await start();
  }

  grpcapi.ClientChannel _createChannel(String addr) {
    const options = ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    );
    if (addr.endsWith(".sock")) {
      return ClientChannel(
        InternetAddress(addr, type: InternetAddressType.unix),
        options: options,
      );
    }

    final addrs = addr.split(":");
    return ClientChannel(
      addrs[0],
      port: int.parse(addrs[1]),
      options: options,
    );
  }
}

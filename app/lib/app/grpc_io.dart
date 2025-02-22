import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:convert';
import 'package:grpc/grpc.dart';
import 'package:grpc/service_api.dart' as grpcapi;
import 'package:ffi/ffi.dart';

import 'package:flutter/services.dart';

import '../common/utils/util.dart';
import '../common/utils/path.dart';
import '../generated/ffi/libserver.dart';

class GrpcService {
  static const platform = MethodChannel("honmaple.com/maple_file");

  late String _addr;
  late grpcapi.ClientChannel _client;

  String get addr {
    return _addr;
  }

  grpcapi.ClientChannel get client {
    return _client;
  }

  Future<void> init() async {
    if (Util.isDesktop) {
      _addr = await _initDesktop();
    } else {
      _addr = await _initMobile();
    }
    _client = _createChannel(addr);
  }

  Future<String> _initMobile() async {
    final path = await PathUtil.getApplicationPath();
    final Map<String, dynamic> args = {
      'path': path,
    };

    return await platform.invokeMethod("Start", jsonEncode(args));
  }

  // https://docs.flutter.dev/platform-integration/macos/c-interop
  Future<String> _initDesktop() async {
    var libname = "libserver";
    if (Util.isWindows) {
      libname += ".dll";
    } else if (Util.isMacOS) {
      libname += ".dylib";
    } else if (Util.isLinux) {
      libname += ".so";
    }

    final Map<String, dynamic> args = {
      'path': await PathUtil.getApplicationPath(),
    };

    // ffi.Char
    final lib = LibserverBind(ffi.DynamicLibrary.open(libname));
    final result = lib.Start(jsonEncode(args).toNativeUtf8().cast());
    if (result.r1.address == ffi.nullptr.address) {
      return Future.value(result.r0.cast<Utf8>().toDartString());
    }
    return Future.error(result.r1.cast<Utf8>().toDartString());
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

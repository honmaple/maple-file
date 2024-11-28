import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:grpc/grpc.dart';
import 'package:ffi/ffi.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import '../generated/ffi/libserver.dart';

Future<T?> doFuture<T>(
  Future<T> Function() callback,
) async {
  Widget bar;
  try {
    return await callback();
  } on GrpcError catch (e) {
    bar = Text(e.message ?? e.toString());
  } catch (e) {
    bar = Text(e.toString());
  }
  Messenger.showSnackBar(bar);
  return null;
}

class GRPC {
  GRPC._internal() {
    print("init grpc");
  }

  static final GRPC _instance = GRPC._internal();

  factory GRPC() => _instance;

  static GRPC get instance => _instance;

  static const platform = MethodChannel("honmaple.com/maple_file");

  Future<void> init() async {
    if (Platform.isMacOS) {
      await _initDesktop();
    } else {
      await _initMobile();
    }
  }

  _initMobile() async {
    final directory = await getApplicationDocumentsDirectory();
    final Map<String, dynamic> args = {
      'path': directory.path,
    };

    await platform.invokeMethod("Start", args).then((addr) {
      _createChannel(addr);
    }).catchError((err) {
      print(err);
    });
  }

  // https://docs.flutter.dev/platform-integration/macos/c-interop
  _initDesktop() async {
    if (Platform.isMacOS) {}

    var libname = "libserver.dylib";

    final lib = LibserverBind(ffi.DynamicLibrary.open(libname));
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    print(path);

    // ffi.Char
    final result = lib.Start(path.toNativeUtf8().cast());
    if (result.r1.address == ffi.nullptr.address) {
      _createChannel(result.r0.cast<Utf8>().toDartString());
    } else {
      print(result.r1.cast<Utf8>().toDartString());
    }
  }

  String get addr {
    if (_client.host is String) {
      return "${_client.host}:${_client.port}";
    }
    return (_client.host as InternetAddress).address;
  }

  late ClientChannel _client;

  ClientChannel get client {
    return _client;
  }

  _createChannel(String addr) {
    const options = ChannelOptions(
      credentials: ChannelCredentials.insecure(),
    );
    if (addr.endsWith(".sock")) {
      _client = ClientChannel(
        InternetAddress(addr, type: InternetAddressType.unix),
        options: options,
      );
    } else {
      final addrs = addr.split(":");

      _client = ClientChannel(
        addrs[0],
        port: int.parse(addrs[1]),
        options: options,
      );
    }
  }
}
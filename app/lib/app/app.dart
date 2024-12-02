import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common/utils/util.dart';

import 'grpc.dart';
import 'store.dart';
import 'router.dart';

class Messenger {
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(Widget content, {SnackBarAction? action}) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(content: content, action: action),
    );
  }

  static void hideCurrentSnackBar(Widget content) {
    scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
  }
}

class App {
  static const initialRoute = "/";

  static final router = CustomRouter();

  App._internal() {
    print("init app");
  }
  factory App() => _instance;
  static final App _instance = App._internal();
  static App get instance => _instance;

  Future<void> init() async {
    await Store().init();
    await GRPC().init();

    await initWindow();
    await initPermission();
  }

  Future<void> initWindow() async {
    if (Util.isDesktop()) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = const WindowOptions(
        size: Size(800, 600),
        center: true,
        backgroundColor: Colors.transparent,
        titleBarStyle: TitleBarStyle.hidden,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
        print(await windowManager.getTitleBarHeight());
      });
    }
  }

  Future<void> initPermission() async {
    if (Util.isAndroid()) {
      // final status = await Permission.manageExternalStorage.status;
      // if (status.isDenied) {
      //   await Permission.manageExternalStorage.onDeniedCallback(() {
      //     Messenger.showSnackBar(const Text("拒绝权限可能会导致本地存储无法获取到文件信息"));
      //   }).request();
      // }
    }
  }
}

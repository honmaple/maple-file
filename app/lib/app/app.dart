import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';
// import 'package:permission_handler/permission_handler.dart';

import '../common/utils/util.dart';

import 'grpc.dart';
import 'store.dart';
import 'router.dart';

class App {
  static const initialRoute = "/";

  static final router = CustomRouter();

  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(Widget content, {SnackBarAction? action}) {
    scaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(content: content, action: action),
    );
  }

  static void hideCurrentSnackBar(Widget content) {
    scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
  }

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
    if (Util.isDesktop) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = WindowOptions(
        size: const Size(800, 600),
        center: true,
        backgroundColor: Colors.transparent,
        titleBarStyle:
            Util.isWindows ? TitleBarStyle.normal : TitleBarStyle.hidden,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
  }

  Future<void> initPermission() async {}
}

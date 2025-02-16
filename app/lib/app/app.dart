import 'package:flutter/material.dart';

import 'package:logging/logging.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:permission_handler/permission_handler.dart';

import '../common/utils/util.dart';

import 'grpc.dart';
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

  App._internal();

  factory App() => _instance;
  static final App _instance = App._internal();
  static App get instance => _instance;

  Future<void> init() async {
    await initLogger();

    await GRPC().init();

    await initWindow();
    await initPermission();
  }

  static late final Logger logger;

  Future<void> initLogger() async {
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');

      if (record.error != null) {
        // ignore: avoid_print
        print(record.error);
      }

      if (record.stackTrace != null) {
        // ignore: avoid_print
        print(record.stackTrace);
      }
    });
    logger = Logger("app");
  }

  Future<void> initWindow() async {
    if (Util.isDesktop) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = WindowOptions(
        size: const Size(800, 600),
        center: true,
        backgroundColor: Util.isWindows ? null : Colors.transparent,
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

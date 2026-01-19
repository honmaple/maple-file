import 'package:flutter/material.dart';

import 'package:logging/logging.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:fvp/fvp.dart' as fvp;

import '../common/utils/util.dart';

import 'grpc.dart';
import 'router.dart';

class App {
  static const initialRoute = "/";

  static final router = CustomRouter();

  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  App._internal();

  static App get instance => _instance;
  static final App _instance = App._internal();
  factory App() => _instance;

  Future<void> init() async {
    await initLogger();
    await Future.wait([
      initGrpc(),
      initMedia(),
      initWindow(),
      initPermission(),
    ]);
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

  Future<void> initGrpc() async {
    await Grpc.instance.init();
  }

  Future<void> initMedia() async {
    fvp.registerWith(options: {
      "global": {"log": "off"}
    });
  }

  Future<void> initPermission() async {}
}

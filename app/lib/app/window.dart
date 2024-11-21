import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../common/utils/util.dart';

class Window {
  static final Window _instance = Window._internal();

  Window._internal() {
    print("init window");
  }

  factory Window() => _instance;

  Future<void> init() async {
    if (Util.isDesktop()) {
      await windowManager.ensureInitialized();

      WindowOptions windowOptions = WindowOptions(
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
}

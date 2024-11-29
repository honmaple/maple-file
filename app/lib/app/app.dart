import 'package:flutter/material.dart';

import 'grpc.dart';
import 'router.dart';
import 'store.dart';
import 'window.dart';

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
    await Window().init();
    await Store().init();
    await GRPC().init();
  }
}

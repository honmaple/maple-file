import 'package:flutter/material.dart';

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
  App._internal() {
    print("init app");
  }

  static final App _instance = App._internal();

  factory App() => _instance;

  static App get instance => _instance;

  Future<void> init() async {}
}

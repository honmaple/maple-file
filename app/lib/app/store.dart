import 'package:hive_flutter/hive_flutter.dart' as hive;

class Store {
  static final Store _instance = Store._internal();

  static const String defaultBox = "default";

  Store._internal() {
    print("init storage");
  }

  factory Store() => _instance;

  late final hive.Box box;

  Future<void> init() async {
    await hive.Hive.initFlutter();
    await hive.Hive.openBox(defaultBox);

    box = hive.Hive.box(defaultBox);
  }

  void register() {}
}

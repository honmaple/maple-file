import 'package:hive_flutter/hive_flutter.dart' as hive;
// import 'package:flutter_riverpod/flutter_riverpod.dart';

class Store {
  static final Store _instance = Store._internal();

  static final String defaultBox = "default";

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

// class StoreNotifier<T> extends Notifier<T> {
//   late String _key;
//   late T _value;

//   final _box = Store().box;

//   StoreNotifier({required String key, required T value}) {
//     this._key = key;
//     this._value = value;
//   }

//   @override
//   T build() => _box.get(_key) ?? _value;

//   @override
//   set state(T newState) {
//     super.state = newState;
//     _box.put(_key, newState);
//   }

//   T update(T Function(T state) cb) {
//     state = cb(state);
//     _box.put(_key, state);
//     return state;
//   }
// }

// NotifierProvider<StoreNotifier<T>, T> newStoreNotifier<T>(String key, T value) {
//   return NotifierProvider<StoreNotifier<T>, T>(() {
//     return StoreNotifier<T>(key: key, value: value);
//   });
// }

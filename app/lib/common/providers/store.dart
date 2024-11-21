import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/store.dart';

class StoreNotifier<T> extends Notifier<T> {
  late String _key;
  late T _value;

  final _box = Store().box;

  StoreNotifier({required String key, required T value}) {
    this._key = key;
    this._value = value;
  }

  @override
  T build() => _box.get(_key) ?? _value;

  @override
  set state(T newState) {
    super.state = newState;
    _box.put(_key, newState);
  }

  T update(T Function(T state) cb) {
    state = cb(state);
    _box.put(_key, state);
    return state;
  }

  Future<void> persist(T value) async {
    _box.put(_key, value);
  }
}

NotifierProvider<StoreNotifier<T>, T> newStoreNotifier<T>(String key, T value) {
  return NotifierProvider<StoreNotifier<T>, T>(() {
    return StoreNotifier<T>(key: key, value: value);
  });
}

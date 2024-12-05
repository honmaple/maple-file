import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'service.dart';

class SettingNotifier1 extends FamilyNotifier<dynamic, String> {
  final _service = SystemService();

  @override
  dynamic build(String arg) async {
    final value = await _service.getSetting(arg);
    return jsonDecode(value);
  }
}

final settingProvider =
    NotifierProvider.family<SettingNotifier1, dynamic, String>(
        SettingNotifier1.new);

class SettingNotifier<T> extends Notifier<T> {
  final String key;
  final T value;
  final T Function(Map<String, dynamic> json) fromJson;

  final _service = SystemService();

  SettingNotifier({
    required this.key,
    required this.value,
    required this.fromJson,
  }) {
    _fetch().then((result) {
      state = result;
    });
  }

  @override
  T build() {
    return value;
  }

  Future<T> _fetch() async {
    final result = await _service.getSetting(key);
    return fromJson(jsonDecode(result));
  }

  T update(T Function(T state) cb) {
    final value = cb(state);

    _service.updateSetting(key, value).then((_) {
      state = value;
    });
    return state;
  }
}

NotifierProvider<SettingNotifier<T>, T> newSettingNotifier<T>(
  String key,
  T value,
  T Function(Map<String, dynamic> json) fromJson,
) {
  return NotifierProvider<SettingNotifier<T>, T>(() {
    return SettingNotifier<T>(key: key, value: value, fromJson: fromJson);
  });
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/app.dart';

import 'service.dart';

class SettingAsyncNotifier extends FamilyAsyncNotifier<String, String> {
  final _service = SystemService();

  @override
  FutureOr<String> build(String arg) {
    return _service.getSetting(arg);
  }
}

class SettingNotifier<T> extends Notifier<T> {
  final String key;
  final T value;
  final T Function(Map<String, dynamic> json) fromJson;

  final _service = SystemService();

  SettingNotifier({
    required this.key,
    required this.value,
    required this.fromJson,
  });

  @override
  T build() {
    final result = ref.watch(settingProvider(key)).valueOrNull;
    if (result == null) {
      return value;
    }
    try {
      return fromJson(jsonDecode(result));
    } catch (e) {
      App.logger.warning("load setting $key err: ${e.toString()}");
      return value;
    }
  }

  T update(T Function(T state) cb) {
    final value = cb(state);

    _service.updateSetting(key, value).then((_) {
      state = value;
    });
    return state;
  }

  Future<void> init() async {
    await ref.read(settingProvider(key).future);
  }
}

final settingProvider =
    AsyncNotifierProvider.family<SettingAsyncNotifier, String, String>(
        SettingAsyncNotifier.new);

NotifierProvider<SettingNotifier<T>, T> newSettingNotifier<T>(
  String key,
  T value,
  T Function(Map<String, dynamic> json) fromJson,
) {
  return NotifierProvider<SettingNotifier<T>, T>(() {
    return SettingNotifier<T>(key: key, value: value, fromJson: fromJson);
  });
}

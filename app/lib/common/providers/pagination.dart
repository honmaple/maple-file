import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationNotifier<T> extends AsyncNotifier<List<T>> {
  bool _more = true;
  late int _page;
  late int _limit;
  late Map<String, String> _filter;
  final Future<List<T>> Function(Map<String, String>?) builder;

  PaginationNotifier({
    required this.builder,
    int page = 1,
    int limit = 30,
    Map<String, String> filter = const {},
  }) {
    this._page = page;
    this._limit = limit;
    this._filter = Map<String, String>.from(filter);
  }

  Future<List<T>> _fetch() async {
    final filter = Map<String, String>.from(_filter);

    filter["page"] = "${_page}";
    filter["limit"] = "${_limit}";

    return builder(filter);
  }

  @override
  FutureOr<List<T>> build() async {
    return await _fetch();
  }

  Future<bool> load() async {
    if (!_more) return _more;

    _page++;

    // state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final old = await future;
      final results = await _fetch();

      _more = results.length == _limit;
      return [...old, ...results];
    });
    return _more;
  }

  Future<void> refresh() async {
    _page = 1;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _fetch();
    });
  }

  Future<void> filter(Map<String, String> filterMap) async {
    _filter.addAll(filterMap);

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _fetch();
    });
  }

  Future<void> reset() async {
    _page = 1;
    _filter = Map<String, String>();

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _fetch();
    });
  }
}

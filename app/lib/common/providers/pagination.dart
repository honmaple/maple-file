import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract mixin class PaginationNotifierMixin<T> {
  AsyncNotifierProviderRef<List<T>> get ref;
  Future<List<T>> get future;
  AsyncValue<List<T>> get state;
  set state(AsyncValue<List<T>> newState);

  int _page = 1;
  bool _hasMore = true;

  FutureOr<List<T>> fetch(int page);

  FutureOr<IndicatorResult> load() async {
    if (_hasMore) {
      state = await AsyncValue.guard(() async {
        final old = await future;
        final results = await fetch(_page + 1);
        if (results.length < (old.length / _page)) {
          _hasMore = false;
        }
        return [...old, ...results];
      });
      _page++;
      if (state.hasError) {
        return IndicatorResult.fail;
      }
      return _hasMore ? IndicatorResult.success : IndicatorResult.noMore;
    }
    return IndicatorResult.noMore;
  }

  FutureOr<void> refresh() async {
    _page = 1;
    _hasMore = true;
    ref.invalidateSelf();
    await future;
  }
}

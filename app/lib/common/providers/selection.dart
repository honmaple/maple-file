import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectionNotifier<T> extends Notifier<Selection<T>> {
  Selection<T>? _selection;

  SelectionNotifier({
    bool Function(T, T)? compare,
    bool multiple = true,
  }) {
    _selection = Selection(
      compare: compare,
      multiple: multiple,
    );
  }

  @override
  Selection<T> build() {
    return _selection ?? Selection<T>();
  }

  void add(T value) {
    state = state.copyWith(
      selected: state.multiple ? [...state.selected, value] : [value],
    );
  }

  void remove(T value) {
    state = state.copyWith(
      selected: state.remove(value),
    );
  }

  void toggle(T item, {bool? checked}) {
    if (checked != null) {
      checked ? add(item) : remove(item);
    } else {
      state.contains(item) ? remove(item) : add(item);
    }
  }

  void selectAll(List<T> values) {
    state = state.copyWith(selected: values);
  }

  void clear() {
    state = state.copyWith(selected: []);
  }

  void reset() {
    state = state.copyWith(enabled: false, selected: []);
  }

  Selection<T> update(Selection<T> Function(Selection<T> state) cb) {
    state = cb(state);
    return state;
  }
}

class Selection<T> {
  bool enabled;
  bool multiple;
  List<T> selected;

  bool Function(T, T)? compare;

  bool Function(T, T) get _compare {
    return compare ?? (o, n) => o == n;
  }

  Selection({
    this.compare,
    this.enabled = false,
    this.multiple = true,
    this.selected = const [],
  });

  Selection<T> copyWith({
    bool? enabled,
    bool? multiple,
    List<T>? selected,
  }) {
    return Selection<T>(
      enabled: enabled ?? this.enabled,
      multiple: multiple ?? this.multiple,
      selected: selected ?? this.selected,
    );
  }

  List<T> remove(T item) {
    return [
      for (final oldItem in selected)
        if (!_compare(oldItem, item)) oldItem
    ];
  }

  bool contains(T item) {
    for (final oldItem in selected) {
      if (_compare(oldItem, item)) {
        return true;
      }
    }
    return false;
  }
}

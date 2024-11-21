class FormNotifier<T> {
  T _value;

  final Function()? notifier;

  FormNotifier(this._value, {this.notifier});

  T get value => _value;

  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifier?.call();
  }

  T update(T Function(T newValue) cb) {
    value = cb(value);
    notifier?.call();
    return value;
  }
}

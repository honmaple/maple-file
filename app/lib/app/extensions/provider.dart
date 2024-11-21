import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension Context on BuildContext {
  WidgetRef get ref {
    return ProviderScope.containerOf(this, listen: false);
  }

  T read<T>(ProviderBase<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }

  T watch<T>(ProviderBase<T> provider) {
    return ProviderScope.containerOf(this, listen: false).watch(provider);
  }
}

// extension ContextRefExt on BuildContext {
//   static final _refCollection = Expando<WatchableRef>();

//   /// Access the [Ref] using this [BuildContext].
//   WatchableRef get ref {
//     return _refCollection[this] ??= WatchableRefImpl(
//       container: getContainer(this),
//       rebuildable: ElementRebuildable(this as Element),
//     );
//   }

//   /// Shorthand for `context.ref.read()`.
//   /// See [Ref.read] for more information.
//   R read<N extends BaseNotifier<T>, T, R>(BaseWatchable<N, T, R> watchable) {
//     return ref.read(watchable);
//   }

//   /// Shorthand for `context.ref.watch()`.
//   /// See [WatchableRef.watch] for more information.
//   R watch<N extends BaseNotifier<T>, T, R>(
//     BaseWatchable<N, T, R> watchable, {
//     ListenerCallback<T>? listener,
//     bool Function(T prev, T next)? rebuildWhen,
//   }) {
//     return ref.watch(
//       watchable,
//       listener: listener,
//       rebuildWhen: rebuildWhen,
//     );
//   }

//   /// Shorthand for `context.ref.notifier()`.
//   /// See [Ref.notifier] for more information.
//   N notifier<N extends BaseNotifier<T>, T>(NotifyableProvider<N, T> provider) {
//     return ref.notifier(provider);
//   }

//   /// Shorthand for `context.ref.redux()`.
//   /// See [Ref.redux] for more information.
//   Dispatcher<N, T> redux<N extends ReduxNotifier<T>, T>(
//     ReduxProvider<N, T> provider,
//   ) {
//     return ref.redux(provider);
//   }

//   /// Shorthand for `context.ref.stream()`.
//   /// See [Ref.stream] for more information.
//   Stream<NotifierEvent<T>> stream<N extends BaseNotifier<T>, T>(
//     ProviderAccessor<BaseProvider<N, T>, N, T> provider,
//   ) {
//     return ref.stream(provider);
//   }

//   /// Shorthand for `context.ref.future()`.
//   /// See [Ref.future] for more information.
//   Future<T> future<N extends GetFutureNotifier<T>, T>(
//     ProviderAccessor<BaseProvider<N, AsyncValue<T>>, N, AsyncValue<T>> provider,
//   ) {
//     return ref.future(provider);
//   }

//   /// Shorthand for `context.ref.rebuild()`.
//   /// See [Ref.rebuild] for more information.
//   R rebuild<N extends RebuildableNotifier<T, R>, T, R>(
//     RebuildableProvider<N, T, R> provider,
//   ) {
//     return ref.rebuild(provider);
//   }

//   /// Shorthand for `context.ref.dispose()`.
//   /// See [Ref.dispose] for more information.
//   void dispose<N extends BaseNotifier<T>, T>(BaseProvider<N, T> provider) {
//     ref.dispose(provider);
//   }

//   /// Shorthand for `context.ref.global`.
//   /// See [GlobalActionExtension.global] for more information.
//   GlobalActionDispatcher get global => ref.global;
// }

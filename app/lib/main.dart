import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'common/watchers/lifecycle.dart';

import 'api/setting/providers/setting_bookmark.dart';
import 'api/setting/providers/setting_appearance.dart';
import 'app/app.dart';
import 'app/grpc.dart';
import 'app/i18n.dart';

import 'api/file/route.dart' as file;
import 'api/home/route.dart' as home;
import 'api/task/route.dart' as task;
import 'api/setting/route.dart' as setting;

Future<void> init() async {
  await App.instance.init();

  await home.init(App.router);
  await file.init(App.router);
  await task.init(App.router);
  await setting.init(App.router);
}

Future<void> initContainer(ProviderContainer container) async {
  loadBookmarks(container);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  await init();
  await initContainer(container);

  runApp(UncontrolledProviderScope(
    container: container,
    child: MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = ref.watch(appearanceProvider);

    final locale = Locale(appearance.locale);

    return LifeCycleWatcher(
      onChangedState: (AppLifecycleState state) async {
        switch (state) {
          // 切换到后台
          case AppLifecycleState.paused:
            break;
          // 切换到前台
          case AppLifecycleState.resumed:
            GRPC.instance.checkAlive();
            break;
          default:
            break;
        }
      },
      child: MaterialApp(
        navigatorKey: App.navigatorKey,
        title: '红枫云盘'.tr(),
        locale: I18n.delegate.isSupported(locale) ? locale : null,
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown
          },
        ),
        scaffoldMessengerKey: App.scaffoldMessengerKey,
        themeMode: appearance.themeMode,
        theme: FlexThemeData.light(scheme: appearance.scheme),
        darkTheme: FlexThemeData.dark(scheme: appearance.scheme),
        localizationsDelegates: I18n.localizationsDelegates,
        supportedLocales: I18n.supportedLocales,
        initialRoute: App.initialRoute,
        onGenerateRoute: App.router.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      title: '红枫云盘'.tr(),
      locale: I18n.delegate.isSupported(locale) ? locale : null,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      scaffoldMessengerKey: App.scaffoldMessengerKey,
      themeMode: appearance.themeMode,
      theme: FlexThemeData.light(scheme: appearance.scheme),
      darkTheme: FlexThemeData.dark(scheme: appearance.scheme),
      localizationsDelegates: I18n.localizationsDelegates,
      supportedLocales: I18n.supportedLocales,
      initialRoute: App.initialRoute,
      onGenerateRoute: App.router.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'app/app.dart';
import 'app/grpc.dart';
import 'app/i18n.dart';

import 'common/utils/util.dart';
import 'common/utils/color.dart';

import 'api/file/route.dart' as file;
import 'api/home/route.dart' as home;
import 'api/syncing/route.dart' as syncing;
import 'api/task/route.dart' as task;
import 'api/setting/route.dart' as setting;
import 'api/file/providers/repo.dart';
import 'api/setting/providers/setting_appearance.dart';

Future<void> init() async {
  await App.instance.init();

  await home.init(App.router);
  await file.init(App.router);
  await syncing.init(App.router);
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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      // 切换到后台或锁屏
      case AppLifecycleState.paused:
        break;
      // 切换到前台
      case AppLifecycleState.resumed:
        Grpc.instance.checkAlive();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appearance = ref.watch(appearanceProvider);

    final locale = Locale(appearance.locale);

    final lightTheme = FlexThemeData.light(
      scheme: appearance.scheme,
      fontFamily: Util.fontFamily,
    );
    final darkTheme = FlexThemeData.dark(
      scheme: appearance.scheme,
      fontFamily: Util.fontFamily,
    );
    return PlatformProvider(
      // initialPlatform: TargetPlatform.android,
      settings: PlatformSettingsData(
        iosUsesMaterialWidgets: true,
        // legacyIosUsesMaterialWidgets: true,
        platformStyle: PlatformStyleData(
          ios: PlatformStyle.Cupertino,
          android: PlatformStyle.Cupertino,
        ),
      ),
      builder: (context) {
        return PlatformTheme(
          themeMode: appearance.themeMode,
          materialLightTheme: lightTheme.copyWith(
            listTileTheme: ListTileThemeData(minTileHeight: 48),
          ),
          materialDarkTheme: darkTheme.copyWith(
            listTileTheme: ListTileThemeData(minTileHeight: 48),
          ),
          builder: (context) => PlatformApp(
              navigatorKey: App.navigatorKey,
              title: '红枫云盘'.tr(),
              locale: I18n.delegate.isSupported(locale) ? locale : null,
              localizationsDelegates: I18n.localizationsDelegates,
              supportedLocales: I18n.supportedLocales,
              initialRoute: App.initialRoute,
              onGenerateRoute: App.router.onGenerateRoute(context),
              debugShowCheckedModeBanner: false,
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.touch,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown
                },
              ),
              builder: (context, child) {
                final materialTheme = Theme.of(context);
                final cupertinoTheme = MaterialBasedCupertinoThemeData(
                  materialTheme: materialTheme,
                );
                final cupertinoTextTheme = cupertinoTheme.textTheme;

                return CupertinoTheme(
                  data: cupertinoTheme.copyWith(
                    scaffoldBackgroundColor:
                        ColorUtil.scaffoldBackgroundColor(context),
                    barBackgroundColor: cupertinoTheme.scaffoldBackgroundColor,
                    textTheme: cupertinoTextTheme.copyWith(
                      textStyle: cupertinoTextTheme.textStyle.copyWith(
                        fontSize: 16,
                        color: materialTheme.colorScheme.onSurface,
                      ),
                      tabLabelTextStyle:
                          cupertinoTextTheme.tabLabelTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ),
                  child: FlutterSmartDialog.init()(context, child),
                );
              }),
        );
      },
    );
  }
}

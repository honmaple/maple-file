import 'package:maple_file/app/router.dart';
import 'package:maple_file/common/widgets/responsive.dart';

import "pages/setting.dart";
import "pages/setting_theme.dart";
import "pages/setting_locale.dart";

Future<void> init(CustomRouter router) async {
  router.registerMany({
    '/setting': (context) {
      return const Setting();
      if (Breakpoint.isMobile(context)) {
        return const Setting();
      }
      return DesktopSetting(
        initialRoute: "/setting/theme",
        onGenerateRoute: router.replaceRoute(replace: {
          "/": null,
          "/setting": null,
        }),
      );
    },
    '/setting/theme': (context) {
      return const SettingTheme();
    },
    '/setting/locale': (context) {
      return const SettingLocale();
    },
  });
}

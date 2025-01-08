import 'package:maple_file/app/router.dart';
import 'package:maple_file/common/widgets/responsive.dart';

import "pages/help.dart";
import "pages/about.dart";
import "pages/index.dart";
import "pages/not_found.dart";

Future<void> init(CustomRouter router) async {
  router.registerMany({
    "/": (context) {
      if (Breakpoint.isSmall(context)) {
        return const Index();
      }
      return DesktopIndex(
        initialRoute: "/file/list",
        onGenerateRoute: router.replaceRoute(replace: {
          "/": null,
        }),
      );
    },
    '/help': (context) {
      return const Help();
    },
    '/about': (context) {
      return const About();
    },
    '/404': (context) {
      return const NotFound();
    },
  });
}

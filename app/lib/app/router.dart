import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../common/utils/util.dart';

typedef RouterMiddleware = WidgetBuilder? Function(RouteSettings settings);

class CustomRouter {
  final String? prefix;

  late Map<String, WidgetBuilder> routes;
  late List<RouterMiddleware> middlewares;

  CustomRouter({
    this.prefix,
    Map<String, WidgetBuilder>? routes,
    List<RouterMiddleware>? middlewares,
  }) {
    this.routes = routes ?? {};
    this.middlewares = middlewares ?? <RouterMiddleware>[];
  }

  void use(RouterMiddleware middlware) {
    middlewares.add(middlware);
  }

  void register({required String name, required WidgetBuilder builder}) {
    routes[name] = builder;
  }

  void registerMany(Map<String, WidgetBuilder> newRoutes) {
    routes.addAll(newRoutes);
  }

  WidgetBuilder? found(RouteSettings settings) {
    final name = settings.name;
    final builder = routes[name];

    if (builder == null) {
      return null;
    }

    for (final middle in middlewares) {
      final result = middle(settings);
      if (result != null) {
        return result;
      }
    }
    return builder;
  }

  WidgetBuilder notFound() {
    return routes["/404"] as WidgetBuilder;
  }

  RouteFactory onGenerateRouteReplace({
    required BuildContext context,
    Map<String, WidgetBuilder?> replace = const {},
  }) {
    final newRoutes = {
      for (final key in routes.keys)
        if (!replace.containsKey(key) || replace[key] != null)
          key: routes[key] as WidgetBuilder
    };

    replace.forEach((k, v) {
      if (v != null) newRoutes[k] = v;
    });

    final newRouter = CustomRouter(
      routes: newRoutes,
      middlewares: middlewares,
    );
    return newRouter.onGenerateRoute(context);
  }

  RouteFactory onGenerateRoute(BuildContext context) {
    return (RouteSettings settings) {
      final builder = found(settings) ?? notFound();
      // 无动画
      // return PageRouteBuilder(
      //   pageBuilder: (
      //     BuildContext context,
      //     Animation<double> animation,
      //     Animation<double> secondaryAnimation,
      //   ) {
      //     return builder(context);
      //   },
      //   settings: settings,
      // );

      // 从右向左
      // return PageRouteBuilder(
      //   settings: settings,
      //   pageBuilder: (context, animation, secondaryAnimation) {
      //     return builder(context);
      //   },
      //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //     const begin = Offset(1.0, 0.0);
      //     const end = Offset.zero;
      //     const curve = Curves.ease;

      //     var tween = Tween(
      //       begin: begin,
      //       end: end,
      //     ).chain(CurveTween(curve: curve));
      //     return SlideTransition(position: animation.drive(tween), child: child);
      //   },
      //   transitionDuration: Duration(milliseconds: 300),
      // );
      if (Util.isDesktop) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return builder(context);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: Duration(milliseconds: 200),
        );
      }
      if (isMaterial(context)) {
        return MaterialPageRoute(
          builder: builder,
          settings: settings,
        );
      }
      return CupertinoPageRoute(
        builder: builder,
        settings: settings,
      );
    };
  }
}

import 'package:flutter/material.dart';

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

  RouteFactory replaceRoute({Map<String, WidgetBuilder?> replace = const {}}) {
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
    return newRouter.generateRoute;
  }

  Route<dynamic>? generateRoute(RouteSettings settings) {
    final builder = found(settings) ?? notFound();
    // return PageRouteBuilder(
    //   pageBuilder: (
    //     BuildContext context,
    //     Animation<double> animation,
    //     Animation<double> secondaryAnimation,
    //   ) =>
    //       builder(context),
    //   settings: settings,
    // );
    return MaterialPageRoute(
      builder: builder,
      settings: settings,
    );
  }
}

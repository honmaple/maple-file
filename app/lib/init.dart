import 'app/grpc.dart';
import 'app/router.dart';
import 'app/store.dart';
import 'app/window.dart';

import 'api/file/route.dart' as file;
import 'api/home/route.dart' as home;
import 'api/task/route.dart' as task;
import 'api/setting/route.dart' as setting;

class RoutePage {
  static const initialRoute = "/";

  static final router = CustomRouter();
}

Future<void> init() async {
  await Window().init();
  await Store().init();
  await GRPC().init();

  await home.init(RoutePage.router);
  await file.init(RoutePage.router);
  await task.init(RoutePage.router);
  await setting.init(RoutePage.router);
}

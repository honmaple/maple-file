import 'package:flutter/material.dart';

import 'package:maple_file/app/router.dart';

import "pages/task_list.dart";

Future<void> init(CustomRouter router) async {
  router.registerMany({
    '/task/list': (context) {
      return TaskList.fromRoute(ModalRoute.of(context));
    },
  });
}

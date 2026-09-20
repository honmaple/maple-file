import 'package:flutter/material.dart';

import 'package:maple_file/app/router.dart';

import 'pages/syncing.dart';
import 'pages/syncing_detail.dart';
import 'pages/syncing_edit.dart';

Future<void> init(CustomRouter router) async {
  router.registerMany({
    '/syncing': (context) => const SyncingScreen(),
    '/syncing/detail': (context) =>
        SyncingDetailScreen.fromRoute(ModalRoute.of(context)),
    '/syncing/edit': (context) =>
        SyncingEditScreen.fromRoute(ModalRoute.of(context)),
  });
}

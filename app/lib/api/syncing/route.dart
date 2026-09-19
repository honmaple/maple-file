import 'package:flutter/material.dart';

import 'package:maple_file/app/router.dart';

import 'pages/album_backup_edit.dart';
import 'pages/syncing.dart';

Future<void> init(CustomRouter router) async {
  router.registerMany({
    '/setting/syncing': (context) => const SyncingScreen(),
    '/setting/syncing/album-backup/edit': (context) =>
        AlbumBackupEditScreen.fromRoute(ModalRoute.of(context)),
  });
}

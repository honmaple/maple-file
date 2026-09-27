import 'package:flutter/material.dart';

import 'package:maple_file/app/router.dart';

import "pages/file_list.dart";
import "pages/file_preview.dart";

import "pages/repo_list.dart";
import "pages/repo_edit.dart";

import "pages/setting_theme.dart";
import "pages/setting_transfer.dart";
import "pages/setting_server.dart";

Future<void> init(CustomRouter router) async {
  router.registerMany({
    '/file/list': (context) {
      return FileListScreen.fromRoute(ModalRoute.of(context));
    },
    '/file/preview': (context) {
      return FilePreviewScreen.fromRoute(ModalRoute.of(context));
    },
    '/file/setting/repo': (context) {
      return const RepoListScreen();
    },
    '/file/setting/repo/edit': (context) {
      return RepoEditScreen.fromRoute(ModalRoute.of(context));
    },
    '/file/setting/theme': (context) {
      return const FileSettingThemeScreen();
    },
    '/file/setting/transfer': (context) {
      return const FileSettingTransferScreen();
    },
    '/file/setting/server': (context) {
      return const FileSettingServerScreen();
    },
  });
}

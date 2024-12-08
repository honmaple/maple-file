import 'package:flutter/material.dart';

import 'package:maple_file/app/router.dart';

import "pages/file_list.dart";
import "pages/file_select.dart";
import "pages/file_preview.dart";

import "pages/repo_list.dart";
import "pages/repo_edit.dart";

import "pages/setting_theme.dart";
import "pages/setting_upload.dart";
import "pages/setting_download.dart";

Future<void> init(CustomRouter router) async {
  router.registerMany({
    '/file/list': (context) {
      return FileList.fromRoute(ModalRoute.of(context));
    },
    '/file/select': (context) {
      return FileSelect.fromRoute(ModalRoute.of(context));
    },
    '/file/preview': (context) {
      return FilePreview.fromRoute(ModalRoute.of(context));
    },
    '/file/setting/repo': (context) {
      return const RepoList();
    },
    '/file/setting/repo/edit': (context) {
      return RepoEdit.fromRoute(ModalRoute.of(context));
    },
    '/file/setting/theme': (context) {
      return const FileSettingTheme();
    },
    '/file/setting/upload': (context) {
      return const FileSettingUpload();
    },
    '/file/setting/download': (context) {
      return const FileSettingDownload();
    },
    '/file/setting/hidefiles': (context) {
      return const FileSettingHideFiles();
    },
  });
}

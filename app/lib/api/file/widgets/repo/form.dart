import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import "smb.dart";
import "ftp.dart";
import "sftp.dart";
import "local.dart";
import "upyun.dart";
import "webdav.dart";

enum DriverType {
  ftp,
  smb,
  sftp,
  local,
  upyun,
  webdav,
}

extension DriverTypeTypeExtension on DriverType {
  String label() {
    final Map<DriverType, String> labels = {
      DriverType.smb: "SMB",
      DriverType.ftp: "FTP",
      DriverType.sftp: "SFTP",
      DriverType.local: "本地文件",
      DriverType.upyun: "又拍云",
      DriverType.webdav: "Webdav",
    };
    return labels[this] ?? "unknown";
  }
}

class DriverForm extends ConsumerWidget {
  final Repo form;

  const DriverForm({super.key, required this.form});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (form.driver) {
      case "smb":
        return SMB(form: form);
      case "ftp":
        return FTP(form: form);
      case "sftp":
        return SFTP(form: form);
      case "local":
        return Local(form: form);
      case "upyun":
        return Upyun(form: form);
      case "webdav":
        return Webdav(form: form);
      default:
        return const SizedBox.shrink();
    }
  }
}

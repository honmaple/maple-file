import 'package:flutter/material.dart';

import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import "alist.dart";
import "ftp.dart";
import "local.dart";
import "mirror.dart";
import "s3.dart";
import "sftp.dart";
import "smb.dart";
import "upyun.dart";
import "webdav.dart";

enum DriverType {
  s3,
  ftp,
  smb,
  sftp,
  alist,
  local,
  upyun,
  webdav,
  mirror,
}

extension DriverTypeTypeExtension on DriverType {
  String label() {
    final Map<DriverType, String> labels = {
      DriverType.s3: "S3",
      DriverType.smb: "SMB",
      DriverType.ftp: "FTP",
      DriverType.sftp: "SFTP",
      DriverType.alist: "Alist",
      DriverType.local: "本地",
      DriverType.upyun: "又拍云",
      DriverType.webdav: "Webdav",
      DriverType.mirror: "Mirror",
    };
    return labels[this] ?? "unknown";
  }
}

class DriverForm extends StatelessWidget {
  final Repo form;

  const DriverForm({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    switch (form.driver) {
      case "s3":
        return S3(form: form);
      case "smb":
        return SMB(form: form);
      case "ftp":
        return FTP(form: form);
      case "sftp":
        return SFTP(form: form);
      case "alist":
        return Alist(form: form);
      case "local":
        return Local(form: form);
      case "upyun":
        return Upyun(form: form);
      case "webdav":
        return Webdav(form: form);
      case "mirror":
        return Mirror(form: form);
      default:
        return const SizedBox.shrink();
    }
  }
}

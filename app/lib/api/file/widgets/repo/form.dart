import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/responsive.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import "base.dart";
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
      DriverType.local: "本地".tr(),
      DriverType.upyun: "又拍云".tr(),
      DriverType.webdav: "Webdav",
      DriverType.mirror: "Mirror",
    };
    return labels[this] ?? "unknown";
  }
}

class DriverForm extends StatefulWidget {
  const DriverForm({super.key, required this.form});

  final Repo form;

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildForm(),
        if (!Breakpoint.isSmall(context)) const SizedBox(height: 4),
        if (_showMore) BaseForm(form: widget.form),
        if (_showMore) SizedBox(height: Breakpoint.isSmall(context) ? 4 : 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text(_showMore ? "隐藏更多设置".tr() : "更多设置".tr()),
            onPressed: () {
              setState(() {
                _showMore = !_showMore;
              });
            },
          ),
        ),
      ],
    );
  }

  _buildForm() {
    switch (widget.form.driver) {
      case "s3":
        return S3(form: widget.form);
      case "smb":
        return SMB(form: widget.form);
      case "ftp":
        return FTP(form: widget.form);
      case "sftp":
        return SFTP(form: widget.form);
      case "alist":
        return Alist(form: widget.form);
      case "local":
        return Local(form: widget.form);
      case "upyun":
        return Upyun(form: widget.form);
      case "webdav":
        return Webdav(form: widget.form);
      case "mirror":
        return Mirror(form: widget.form);
      default:
        return const SizedBox.shrink();
    }
  }
}

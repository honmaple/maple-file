import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import "s3.dart";
import "smb.dart";
import "ftp.dart";
import "sftp.dart";
import "alist.dart";
import "local.dart";
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
    };
    return labels[this] ?? "unknown";
  }
}

enum DriverFormFieldType {
  string,
  number,
  password,
  directory,
}

class DriverFormField extends StatelessWidget {
  const DriverFormField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.type = DriverFormFieldType.string,
    this.isRequired = false,
  });

  final bool isRequired;
  final String label;
  final String? value;
  final DriverFormFieldType type;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: _emptyText(context, value),
      onTap: () async {
        String? result;
        switch (type) {
          case DriverFormFieldType.string:
            result = await showEditingDialog(
              context,
              label,
              value: value ?? "",
            );
            break;
          case DriverFormFieldType.number:
            result = await showNumberEditingDialog(
              context,
              label,
              value: value ?? "",
            );
            break;
          case DriverFormFieldType.password:
            result = await showPasswordEditingDialog(
              context,
              label,
              value: value ?? "",
            );
            break;
          case DriverFormFieldType.directory:
            result = await FilePicker.platform.getDirectoryPath();
            break;
        }
        if (result != null) {
          onTap(result);
        }
      },
    );
  }

  Widget _emptyText(
    BuildContext context,
    String? value,
  ) {
    bool isEmpty = value == null || value == "";
    if (type == DriverFormFieldType.password) {
      if (isEmpty) {
        return Text("未设置".tr(context));
      }
      return const Icon(Icons.more_horiz);
    }
    return Wrap(
      children: [
        Text(isEmpty ? "未设置".tr(context) : value),
        if (isRequired && isEmpty)
          const Text(' *', style: TextStyle(color: Colors.red)),
      ],
    );
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
      default:
        return const SizedBox.shrink();
    }
  }
}

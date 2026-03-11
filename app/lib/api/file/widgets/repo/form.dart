import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/responsive.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

import "advance.dart";
import "alist.dart";
import "foxel.dart";
import "ftp.dart";
import "local.dart";
import "mirror.dart";
import "s3.dart";
import "sftp.dart";
import "smb.dart";
import "quark.dart";
import "upyun.dart";
import "webdav.dart";
import "pan115.dart";
import "github.dart";
import "github_release.dart";

enum DriverType {
  s3,
  ftp,
  smb,
  sftp,
  alist,
  foxel,
  local,
  pan115,
  quark,
  upyun,
  webdav,
  mirror,
  github,
  githubRelease,
}

extension DriverTypeTypeExtension on DriverType {
  String label() {
    final Map<DriverType, String> labels = {
      DriverType.s3: "S3",
      DriverType.smb: "SMB",
      DriverType.ftp: "FTP",
      DriverType.sftp: "SFTP",
      DriverType.alist: "Alist",
      DriverType.foxel: "Foxel",
      DriverType.local: "本地".tr(),
      DriverType.pan115: "115网盘".tr(),
      DriverType.quark: "夸克网盘".tr(),
      DriverType.upyun: "又拍云".tr(),
      DriverType.webdav: "Webdav",
      DriverType.mirror: "Mirror",
      DriverType.github: "Github",
      DriverType.githubRelease: "Github Release",
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
  final _advanceFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildForm(),
        if (!Breakpoint.isSmall(context)) const SizedBox(height: 4),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              foregroundColor: colorScheme.primary,
              backgroundColor: ColorUtil.backgroundColor(context),
            ),
            onPressed: () async {
              final form = widget.form.clone();
              final result = await Navigator.of(context).push(
                platformPageRoute(
                  context: context,
                  builder: (context) => PlatformScaffold(
                    iosContentPadding: true,
                    backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
                    appBar: PlatformAppBar(
                      title: Text('更多设置'.tr()),
                      trailingActions: [
                        TextButton(
                          child: Text("确认".tr()),
                          onPressed: () {
                            if (_advanceFormKey.currentState!.validate()) {
                              Navigator.of(context).pop(true);
                            }
                          },
                        ),
                      ],
                    ),
                    body: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Form(
                          key: _advanceFormKey,
                          child: AdvanceForm(form: form),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              if (result != null && result) {
                final option = {
                  ...jsonDecode(widget.form.option) as Map<String, dynamic>,
                  ...jsonDecode(form.option) as Map<String, dynamic>,
                };
                widget.form.option = jsonEncode(option);
              }
            },
            child: Text("更多设置".tr()),
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
      case "foxel":
        return Foxel(form: widget.form);
      case "local":
        return Local(form: widget.form);
      case "quark":
        return Quark(form: widget.form);
      case "pan115":
        return Pan115(form: widget.form);
      case "upyun":
        return Upyun(form: widget.form);
      case "webdav":
        return Webdav(form: widget.form);
      case "mirror":
        return Mirror(form: widget.form);
      case "github":
        return Github(form: widget.form);
      case "githubRelease":
        return GithubRelease(form: widget.form);
      default:
        return const SizedBox.shrink();
    }
  }
}

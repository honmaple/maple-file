import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/api/syncing/widgets/album/form.dart';
import 'package:maple_file/api/syncing/widgets/local_directory/form.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class SyncingEditScreen extends ConsumerStatefulWidget {
  const SyncingEditScreen({
    super.key,
    this.profile,
  });

  final SyncProfile? profile;

  factory SyncingEditScreen.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;

    return SyncingEditScreen(
      profile: args == null ? null : args as SyncProfile,
    );
  }

  @override
  ConsumerState<SyncingEditScreen> createState() => _SyncingEditScreenState();
}

class _SyncingEditScreenState extends ConsumerState<SyncingEditScreen> {
  late SyncProfile _form;

  bool get _isEditing => _form.id > 0;

  @override
  void initState() {
    super.initState();

    _form = widget.profile?.clone() ??
        SyncProfile(sourceType: SyncSourceType.album.value);
  }

  @override
  Widget build(BuildContext context) {
    final sourceType = SyncSourceType.fromValue(_form.sourceType);

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(_isEditing
            ? '修改{title}'.tr(args: {
                "title": sourceType.label,
              })
            : '添加{title}'.tr(args: {
                "title": sourceType.label,
              })),
        trailingActions: [
          if (_isEditing)
            TextButton(
              onPressed: _handleDelete,
              child: Text('删除'.tr()),
            ),
        ],
      ),
      body: switch (sourceType) {
        SyncSourceType.album => AlbumBackupForm(profile: _form),
        SyncSourceType.localDirectory => LocalDirectorySyncForm(profile: _form),
        SyncSourceType.unknown => Center(child: Text('同步配置参数无效'.tr())),
      },
    );
  }

  Future<void> _handleDelete() async {
    final sourceType = SyncSourceType.fromValue(_form.sourceType);
    if (sourceType == SyncSourceType.unknown) return;
    final result = await showCustomConfirmDialog(
      context: context,
      title: Text(
        '确认删除{title}?'.tr(args: {'title': sourceType.label}),
      ),
    );
    if (result != true) return;
    try {
      await SyncingService.instance.deleteProfile(_form.id);
      ref.invalidate(syncProfilesProvider);
      if (mounted) Navigator.pop(context, false);
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }
}

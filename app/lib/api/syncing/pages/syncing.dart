import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

enum _ProfileType { albumBackup }

class SyncingScreen extends ConsumerWidget {
  const SyncingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(title: Text('同步与备份'.tr())),
      body: CustomRefresh(
        onRefresh: () => ref.invalidate(syncProfilesProvider),
        childBuilder: (context, physics) => CustomScrollView(
          physics: physics,
          slivers: [
            CustomSliverAsyncValue(
              value: ref.watch(syncProfilesProvider),
              builder: (profiles) => SliverToBoxAdapter(
                child: CustomListSection(
                  children: [
                    for (final profile in profiles)
                      PlatformListTile(
                        leading: Icon(
                          profile.mode == SyncProfile_Mode.MODE_BACKUP
                              ? Icons.backup_outlined
                              : Icons.sync,
                        ),
                        title: Text(profile.name),
                        subtitle: Text(
                          profile.enabled ? '已启用'.tr() : '已停用'.tr(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: PlatformSwitch(
                          value: profile.enabled,
                          activeTrackColor: Theme.of(context).primaryColor,
                          onChanged: (enabled) async {
                            await SyncingService.instance.updateProfile(
                              SyncProfile()
                                ..mergeFromMessage(profile)
                                ..enabled = enabled,
                            );
                            ref.invalidate(syncProfilesProvider);
                          },
                        ),
                        onTap: () => _openProfile(context, ref, profile),
                      ),
                    PlatformListTile(
                      leading: const Icon(Icons.add),
                      title: Text('添加同步或备份'.tr()),
                      onTap: () => _createProfile(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openProfile(
    BuildContext context,
    WidgetRef ref,
    SyncProfile profile,
  ) async {
    try {
      final type = _profileType(profile);
      if (type == null) {
        SmartDialog.showNotify(
          msg: '暂不支持编辑此类型配置'.tr(),
          notifyType: NotifyType.warning,
        );
        return;
      }
      await _openEditor(context, type, profile);
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }

  Future<void> _createProfile(BuildContext context) async {
    final type = await showCustomListOptions<_ProfileType>(
      context: context,
      options: [
        CustomOption(
          icon: const Icon(Icons.photo_library_outlined),
          label: '相册备份'.tr(),
          value: _ProfileType.albumBackup,
        ),
      ],
    );
    if (type != null && context.mounted) {
      await _openEditor(context, type);
    }
  }

  _ProfileType? _profileType(SyncProfile profile) {
    if (profile.sourceType == 'album' &&
        profile.mode == SyncProfile_Mode.MODE_BACKUP &&
        profile.targetType == 'repo_directory') {
      return _ProfileType.albumBackup;
    }
    return null;
  }

  Future<void> _openEditor(
    BuildContext context,
    _ProfileType type, [
    SyncProfile? profile,
  ]) {
    return Navigator.of(context).pushNamed(
      switch (type) {
        _ProfileType.albumBackup => '/setting/syncing/album-backup/edit',
      },
      arguments: profile,
    );
  }
}

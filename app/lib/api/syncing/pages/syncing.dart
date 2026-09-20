import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class SyncingScreen extends ConsumerWidget {
  const SyncingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformScaffold(
      iosContentPadding: true,
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
                        onTap: () => _handleOpenProfile(context, ref, profile),
                      ),
                    PlatformListTile(
                      leading: const Icon(Icons.add),
                      title: Text('添加同步或备份'.tr()),
                      onTap: () => _handleCreateProfile(context),
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

  Future<void> _handleOpenProfile(
    BuildContext context,
    WidgetRef ref,
    SyncProfile profile,
  ) async {
    try {
      final sourceType = _supportedSourceType(profile);
      if (sourceType == null) {
        SmartDialog.showNotify(
          msg: '暂不支持编辑此类型配置'.tr(),
          notifyType: NotifyType.warning,
        );
        return;
      }
      await _handleOpenDetail(context, sourceType, profile);
      ref.invalidate(syncProfilesProvider);
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }

  Future<void> _handleCreateProfile(BuildContext context) async {
    final sourceType = await showCustomListOptions<SyncSourceType>(
      context: context,
      options: [
        CustomOption(
          icon: const Icon(Icons.photo_library_outlined),
          label: '相册备份'.tr(),
          value: SyncSourceType.album,
        ),
      ],
    );
    if (sourceType != null && context.mounted) {
      await _handleOpenEditor(context, sourceType);
    }
  }

  SyncSourceType? _supportedSourceType(SyncProfile profile) {
    final sourceType = SyncSourceType.fromValue(profile.sourceType);
    if (sourceType == SyncSourceType.album &&
        profile.mode == SyncProfile_Mode.MODE_BACKUP &&
        SyncTargetType.fromValue(profile.targetType) ==
            SyncTargetType.repoDirectory) {
      return sourceType;
    }
    return null;
  }

  Future<void> _handleOpenEditor(
    BuildContext context,
    SyncSourceType sourceType, [
    SyncProfile? profile,
  ]) {
    return Navigator.of(context).pushNamed(
      switch (sourceType) {
        SyncSourceType.album => '/setting/syncing/album-backup/edit',
      },
      arguments: profile,
    );
  }

  Future<void> _handleOpenDetail(
    BuildContext context,
    SyncSourceType sourceType,
    SyncProfile profile,
  ) {
    return Navigator.of(context).pushNamed(
      switch (sourceType) {
        SyncSourceType.album => '/setting/syncing/album-backup/detail',
      },
      arguments: profile,
    );
  }
}

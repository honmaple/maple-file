import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

import 'package:maple_file/api/syncing/providers/album.dart';
import 'package:maple_file/api/syncing/providers/local_directory.dart';
import 'package:maple_file/api/syncing/providers/profile.dart';
import 'package:maple_file/api/syncing/providers/service.dart';

class SyncingScreen extends ConsumerWidget {
  const SyncingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlatformScaffold(
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
                          SyncSourceType.fromValue(profile.sourceType) ==
                                  SyncSourceType.localDirectory
                              ? Icons.folder_copy_outlined
                              : Icons.photo_library_outlined,
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
      await Navigator.of(context).pushNamed(
        '/syncing/detail',
        arguments: profile,
      );
      ref.invalidate(syncProfilesProvider);
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }

  Future<void> _handleCreateProfile(BuildContext context) async {
    if (!SyncSourceType.hasSupportedType) {
      SmartDialog.showNotify(
        msg: '暂无支持的同步类型'.tr(),
        notifyType: NotifyType.warning,
      );
      return;
    }
    final sourceType = await showCustomListOptions<SyncSourceType>(
      context: context,
      options: [
        if (SyncSourceType.album.isSupported)
          CustomOption(
            icon: const Icon(Icons.photo_library_outlined),
            label: SyncSourceType.album.label,
            value: SyncSourceType.album,
          ),
        if (SyncSourceType.localDirectory.isSupported)
          CustomOption(
            icon: const Icon(Icons.folder_copy_outlined),
            label: SyncSourceType.localDirectory.label,
            value: SyncSourceType.localDirectory,
          ),
      ],
    );
    if (sourceType != null && context.mounted) {
      final profile = switch (sourceType) {
        SyncSourceType.album => AlbumBackupProfile.create(
            name: sourceType.label,
          ).toSyncProfile(),
        SyncSourceType.localDirectory => LocalDirectorySyncProfile.create(
            name: sourceType.label,
          ).toSyncProfile(),
        SyncSourceType.unknown => null,
      };
      if (profile != null && context.mounted) {
        Navigator.of(context).pushNamed(
          '/syncing/edit',
          arguments: profile,
        );
      }
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
    if (sourceType == SyncSourceType.localDirectory &&
        profile.mode == SyncProfile_Mode.MODE_ONE_WAY &&
        SyncTargetType.fromValue(profile.targetType) ==
            SyncTargetType.repoDirectory) {
      return sourceType;
    }
    return null;
  }
}

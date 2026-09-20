import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

import 'package:maple_file/api/syncing/pages/history.dart';
import 'package:maple_file/api/syncing/providers/album_controller.dart';
import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/widgets/sync_history_records.dart';

class AlbumBackupDetailScreen extends ConsumerStatefulWidget {
  const AlbumBackupDetailScreen({super.key, required this.profile});

  final SyncProfile profile;

  factory AlbumBackupDetailScreen.fromRoute(ModalRoute? route) {
    return AlbumBackupDetailScreen(
      profile: route!.settings.arguments as SyncProfile,
    );
  }

  @override
  ConsumerState<AlbumBackupDetailScreen> createState() =>
      _AlbumBackupDetailScreenState();
}

class _AlbumBackupDetailScreenState
    extends ConsumerState<AlbumBackupDetailScreen> {
  late final _provider = albumBackupProvider(widget.profile);

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(_provider);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(detail.profile.name),
        trailingActions: [
          TextButton(onPressed: _handleEdit, child: Text('编辑'.tr())),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                CustomListSection(
                  children: [
                    PlatformListTile(
                      title: Text('相册备份'.tr()),
                      trailing: PlatformSwitch(
                        value: detail.profile.enabled,
                        activeTrackColor: Theme.of(context).primaryColor,
                        onChanged: _handleSetEnabled,
                      ),
                    ),
                  ],
                ),
                _buildConfiguration(detail),
                _buildHistoryHeader(detail.profile.id),
                SyncHistoryRecords(
                  profileId: detail.profile.id,
                  onHistoryTap: _handleOpenHistoryDetail,
                ),
              ],
            ),
          ),
          _buildBackupAction(detail),
        ],
      ),
    );
  }

  Widget _buildBackupAction(AlbumBackupState detail) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed:
              detail.profile.enabled && !detail.running ? _handleRun : null,
          icon: const Icon(Icons.sync_rounded, size: 18),
          label: Text(detail.running ? '备份中'.tr() : '立即备份'.tr()),
        ),
      ),
    );
  }

  Widget _buildHistoryHeader(int profileId) {
    final theme = Theme.of(context);
    final histories = ref.watch(syncHistoriesProvider(profileId));
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          Expanded(child: Text('备份记录'.tr())),
          if (histories.valueOrNull?.isNotEmpty == true)
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _handleOpenHistory,
              child: Text(
                '查看全部'.tr(),
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConfiguration(AlbumBackupState detail) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('备份配置'.tr()),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildConfigurationEndpoint(
                  icon: Icons.photo_library_outlined,
                  label: '备份源'.tr(),
                  value: detail.albumSummary.isEmpty
                      ? '未选择'.tr()
                      : detail.albumSummary,
                  color: colorScheme.primary,
                ),
                _buildConfigurationConnector(),
                _buildConfigurationEndpoint(
                  icon: Icons.folder_outlined,
                  label: '备份到'.tr(),
                  value: detail.profile.targetConfig.path.isEmpty
                      ? '未选择'.tr()
                      : detail.profile.targetConfig.path,
                  color: colorScheme.tertiary,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: .55,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_tree_outlined,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          '目的地整理'.tr(),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        detail.profile.targetConfig.layout.label.tr(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationEndpoint({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfigurationConnector() {
    final color = Theme.of(context).colorScheme.outlineVariant;
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          SizedBox(
            width: 38,
            child: Column(
              children: [
                Expanded(child: VerticalDivider(width: 1, color: color)),
                Icon(Icons.arrow_downward_rounded, size: 14, color: color),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Divider(height: 1, color: color)),
        ],
      ),
    );
  }

  Future<void> _handleSetEnabled(bool enabled) async {
    try {
      await ref.read(_provider.notifier).setEnabled(enabled);
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }

  Future<void> _handleEdit() async {
    final profile = ref.read(_provider).profile;
    final result = await Navigator.of(context).pushNamed(
      '/setting/syncing/album-backup/edit',
      arguments: profile.toSyncProfile(),
    );
    if (!mounted) return;
    if (result == false) {
      Navigator.pop(context);
    } else if (result is SyncProfile) {
      ref.read(_provider.notifier).replaceProfile(result);
    }
  }

  Future<void> _handleRun() async {
    try {
      final history = await ref.read(_provider.notifier).run();
      if (!mounted) return;
      if (SyncHistoryRecords.hasFailed(history)) {
        _handleOpenHistoryDetail(history);
      } else {
        SmartDialog.showNotify(
          msg: '备份完成：上传{uploaded}，跳过{skipped}，失败{failed}'.tr(args: {
            'uploaded': history.synced,
            'skipped': history.skipped,
            'failed': history.failed,
          }),
          notifyType: NotifyType.success,
        );
      }
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
    }
  }

  void _handleOpenHistory() {
    final profileId = ref.read(_provider).profile.id;
    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (context) => SyncHistoryScreen(profileId: profileId),
      ),
    );
  }

  void _handleOpenHistoryDetail(SyncHistory history) {
    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (context) => SyncHistoryDetailScreen(history: history),
      ),
    );
  }
}

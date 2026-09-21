import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:maple_file/api/syncing/pages/history.dart';
import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/providers/local_directory/controller.dart';
import 'package:maple_file/api/syncing/providers/service.dart';
import 'package:maple_file/api/syncing/widgets/sync_history_records.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class LocalDirectorySyncDetail extends ConsumerStatefulWidget {
  const LocalDirectorySyncDetail({
    super.key,
    required this.profile,
    required this.onProfileChanged,
  });

  final SyncProfile profile;
  final ValueChanged<SyncProfile> onProfileChanged;

  @override
  ConsumerState<LocalDirectorySyncDetail> createState() =>
      _LocalDirectorySyncDetailState();
}

class _LocalDirectorySyncDetailState
    extends ConsumerState<LocalDirectorySyncDetail> {
  late final _provider = localDirectorySyncProvider(widget.profile);

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(_provider);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              CustomListSection(
                children: [
                  PlatformListTile(
                    title: Text('自动同步'.tr()),
                    trailing: PlatformSwitch(
                      value: detail.profile.enabled,
                      activeTrackColor: Theme.of(context).primaryColor,
                      onChanged: _handleSetEnabled,
                    ),
                  ),
                ],
              ),
              _buildConfiguration(detail),
              if (!SyncSourceType.localDirectory.isSupported)
                _buildUnsupportedNotice(),
              _buildHistoryHeader(detail.profile.id),
              SyncHistoryRecords(
                profileId: detail.profile.id,
                onHistoryTap: _handleOpenHistoryDetail,
              ),
            ],
          ),
        ),
        _buildSyncAction(detail),
      ],
    );
  }

  Widget _buildConfiguration(LocalDirectorySyncState detail) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('同步配置'.tr()),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildEndpoint(
                  icon: Icons.folder_copy_outlined,
                  label: '本地来源'.tr(),
                  value: detail.profile.sourceConfig.path,
                  color: colors.primary,
                ),
                _buildConnector(),
                _buildEndpoint(
                  icon: Icons.cloud_outlined,
                  label: '同步到'.tr(),
                  value: detail.profile.targetConfig.path,
                  color: colors.tertiary,
                ),
                const SizedBox(height: 16),
                _buildPolicyRow(Icons.sync_alt_rounded, '单向同步'.tr()),
                const SizedBox(height: 8),
                _buildPolicyRow(
                  Icons.shield_outlined,
                  '保留云端删除文件，冲突时跳过'.tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndpoint({
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
                value.isEmpty ? '未选择'.tr() : value,
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

  Widget _buildConnector() {
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

  Widget _buildPolicyRow(IconData icon, String text) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colors.onSurfaceVariant),
          const SizedBox(width: 9),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildUnsupportedNotice() {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: colors.onErrorContainer),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '当前平台不支持执行本地目录同步'.tr(),
                style: TextStyle(color: colors.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryHeader(int profileId) {
    final histories = ref.watch(syncHistoriesProvider(profileId));
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          Expanded(child: Text('同步记录'.tr())),
          if (histories.valueOrNull?.isNotEmpty == true)
            TextButton(
              onPressed: _handleOpenHistory,
              child: Text('查看全部'.tr()),
            ),
        ],
      ),
    );
  }

  Widget _buildSyncAction(LocalDirectorySyncState detail) {
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
              SyncSourceType.localDirectory.isSupported && !detail.running
                  ? _handleRun
                  : null,
          icon: const Icon(Icons.sync_rounded, size: 18),
          label: Text(detail.running ? '同步中'.tr() : '立即同步'.tr()),
        ),
      ),
    );
  }

  Future<void> _handleSetEnabled(bool enabled) async {
    try {
      await ref.read(_provider.notifier).setEnabled(enabled);
      widget.onProfileChanged(
        ref.read(_provider).profile.toSyncProfile(),
      );
    } catch (error) {
      SmartDialog.showNotify(msg: '$error', notifyType: NotifyType.error);
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
          msg: '同步完成：同步{synced}，跳过{skipped}，失败{failed}'.tr(args: {
            'synced': history.synced,
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

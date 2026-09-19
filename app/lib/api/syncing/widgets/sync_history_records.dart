import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/common/widgets/timeline.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class SyncHistoryRecords extends ConsumerWidget {
  const SyncHistoryRecords({
    super.key,
    required this.profileId,
    this.limit = 3,
    this.onHistoryTap,
  }) : sliver = false;

  const SyncHistoryRecords.sliver({
    super.key,
    required this.profileId,
    this.limit,
    this.onHistoryTap,
  }) : sliver = true;

  final int profileId;
  final int? limit;
  final bool sliver;
  final ValueChanged<SyncHistory>? onHistoryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = syncHistoriesProvider(profileId);
    final histories = ref.watch(provider);
    final child = Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          histories.when(
            loading: () => _buildMessageCard(
              context,
              title: '读取同步记录'.tr(),
            ),
            error: (error, _) => _buildMessageCard(
              context,
              title: '同步记录加载失败'.tr(),
              subtitle: '$error',
              onTap: () => ref.invalidate(provider),
            ),
            data: (items) => items.isEmpty
                ? _buildMessageCard(context, title: '暂无同步记录'.tr())
                : Timeline<SyncHistory>(
                    items: limit == null
                        ? items
                        : items.take(limit!).toList(growable: false),
                    labelBuilder: (context, history, _) => Text(
                      TimeUtil.datetimeToString(
                        history.hasFinishedAt()
                            ? history.finishedAt.toDateTime()
                            : history.startedAt.toDateTime(),
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    nodeStyleBuilder: (context, history, index) =>
                        TimelineNodeStyle(
                      dotColor: historyColor(context, history),
                      lineColor: Theme.of(context).dividerColor,
                      showHalo: index == 0,
                    ),
                    itemBuilder: (context, history, _) =>
                        _buildHistoryCard(context, history),
                  ),
          ),
        ],
      ),
    );
    return sliver ? SliverToBoxAdapter(child: child) : child;
  }

  Widget _buildMessageCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, SyncHistory history) {
    final theme = Theme.of(context);
    final statusColor = historyColor(context, history);
    final statusIcon = history.status == SyncHistory_Status.STATUS_RUNNING
        ? Icons.sync
        : hasFailed(history)
            ? Icons.error_outline
            : Icons.check_rounded;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onHistoryTap == null ? null : () => onHistoryTap!(history),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 10, 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      statusIcon,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      historyTitle(history),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const PlatformListTileChevron(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetric(
                      context,
                      icon: Icons.cloud_upload_outlined,
                      label: '同步'.tr(),
                      value: history.synced,
                    ),
                  ),
                  _buildMetricDivider(context),
                  Expanded(
                    child: _buildMetric(
                      context,
                      icon: Icons.fast_forward_outlined,
                      label: '跳过'.tr(),
                      value: history.skipped,
                    ),
                  ),
                  _buildMetricDivider(context),
                  Expanded(
                    child: _buildMetric(
                      context,
                      icon: Icons.warning_amber_rounded,
                      label: '失败'.tr(),
                      value: history.failed,
                      color:
                          history.failed > 0 ? theme.colorScheme.error : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int value,
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = color ?? colorScheme.onSurfaceVariant;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: foreground),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            '$label $value',
            maxLines: 1,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider(BuildContext context) {
    return Container(
      width: .5,
      height: 16,
      color: Theme.of(context).dividerColor,
    );
  }

  static bool hasFailed(SyncHistory history) {
    return history.status == SyncHistory_Status.STATUS_FAILED ||
        history.status == SyncHistory_Status.STATUS_PARTIAL ||
        history.failed > 0 ||
        history.conflicted > 0 ||
        history.errorSummary.isNotEmpty;
  }

  static String historyTitle(SyncHistory history, {bool latest = false}) {
    return switch (history.status) {
      SyncHistory_Status.STATUS_RUNNING => '同步中'.tr(),
      SyncHistory_Status.STATUS_INTERRUPTED => '同步已中断'.tr(),
      SyncHistory_Status.STATUS_CANCELED => '同步已取消'.tr(),
      SyncHistory_Status.STATUS_FAILED => '同步失败'.tr(),
      SyncHistory_Status.STATUS_PARTIAL => '部分同步完成'.tr(),
      SyncHistory_Status.STATUS_SUCCEEDED =>
        (latest ? '已同步至最新'.tr() : '同步完成'.tr()),
      _ => hasFailed(history) ? '同步失败'.tr() : '同步完成'.tr(),
    };
  }

  static Color historyColor(BuildContext context, SyncHistory history) {
    if (history.status == SyncHistory_Status.STATUS_RUNNING) {
      return Theme.of(context).colorScheme.primary;
    }
    if (hasFailed(history)) return Theme.of(context).colorScheme.error;
    if (history.status == SyncHistory_Status.STATUS_CANCELED ||
        history.status == SyncHistory_Status.STATUS_INTERRUPTED) {
      return Theme.of(context).colorScheme.onSurfaceVariant;
    }
    return Colors.green;
  }
}

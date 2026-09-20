import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/widgets/sync_history_records.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class SyncHistoryScreen extends ConsumerWidget {
  const SyncHistoryScreen({super.key, required this.profileId});

  final int profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = syncHistoriesProvider(profileId);
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text('同步记录'.tr())),
      body: CustomPaging(
        onRefresh: () => ref.read(provider.notifier).refresh(),
        onLoad: () => ref.read(provider.notifier).load(),
        slivers: [
          SyncHistoryRecords.sliver(
            profileId: profileId,
            onHistoryTap: (history) => Navigator.of(context).push(
              platformPageRoute(
                context: context,
                builder: (context) => SyncHistoryDetailScreen(history: history),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SyncHistoryDetailScreen extends StatelessWidget {
  const SyncHistoryDetailScreen({super.key, required this.history});

  final SyncHistory history;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text('同步详情'.tr())),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummary(context),
                  const SizedBox(height: 12),
                  _buildMetrics(context),
                  const SizedBox(height: 12),
                  _buildRunFacts(context),
                  if (history.errorSummary.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildErrorSummary(context),
                  ],
                  if (history.issues.isNotEmpty) ...[
                    const SizedBox(height: 26),
                    _buildIssuesHeader(context),
                    const SizedBox(height: 10),
                    for (final issue in history.issues) ...[
                      _buildIssueCard(context, issue),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = SyncHistoryRecords.historyColor(context, history);
    final finishedAt =
        history.hasFinishedAt() ? history.finishedAt.toDateTime() : null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _statusIcon(),
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SyncHistoryRecords.historyTitle(history),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _triggerLabel(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: .7,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatDuration(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          _buildRunTrace(
            context,
            statusColor: statusColor,
            finishedAt: finishedAt,
          ),
        ],
      ),
    );
  }

  Widget _buildRunTrace(
    BuildContext context, {
    required Color statusColor,
    required DateTime? finishedAt,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final startText = TimeUtil.datetimeToString(history.startedAt.toDateTime());
    final endText =
        finishedAt == null ? '进行中'.tr() : TimeUtil.datetimeToString(finishedAt);

    return Column(
      children: [
        Row(
          children: [
            _buildTraceDot(colorScheme.primary),
            Expanded(
              child: Container(
                height: 2,
                color: statusColor.withValues(alpha: .22),
              ),
            ),
            _buildTraceDot(statusColor),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildTraceTime(
                context,
                label: '开始'.tr(),
                value: startText,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTraceTime(
                context,
                label: '结束'.tr(),
                value: endText,
                alignEnd: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTraceDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .22),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTraceTime(
    BuildContext context, {
    required String label,
    required String value,
    bool alignEnd = false,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _buildMetric(
            context,
            icon: Icons.cloud_done_outlined,
            label: '同步'.tr(),
            value: history.synced,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetric(
            context,
            icon: Icons.fast_forward_rounded,
            label: '跳过'.tr(),
            value: history.skipped,
            color: Colors.blueGrey.shade600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetric(
            context,
            icon: Icons.error_outline_rounded,
            label: '失败'.tr(),
            value: history.failed,
            color: colorScheme.error,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMetric(
            context,
            icon: Icons.call_split_rounded,
            label: '冲突'.tr(),
            value: history.conflicted,
            color: Colors.orange.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildMetric(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRunFacts(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.manage_search_rounded,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '已扫描 {count} 项'.tr(args: {'count': history.scanned}),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '配置 v{version}'.tr(args: {'version': history.configVersion}),
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSummary(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.report_gmailerrorred_rounded,
              size: 21, color: colorScheme.error),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '运行错误'.tr(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                SelectableText(
                  history.errorSummary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssuesHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            '问题详情'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${history.issues.length}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIssueCard(BuildContext context, SyncHistoryIssue issue) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final issueColor = _issueColor(context, issue);
    final title = issue.sourceLabel.isNotEmpty
        ? issue.sourceLabel
        : issue.sourceKey.isNotEmpty
            ? issue.sourceKey
            : issue.sourcePath.isNotEmpty
                ? issue.sourcePath
                : '未知项目'.tr();

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: issueColor.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  issue.kind == SyncHistoryIssue_Kind.KIND_CONFLICT
                      ? Icons.call_split_rounded
                      : Icons.priority_high_rounded,
                  size: 17,
                  color: issueColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: issueColor.withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  _operationLabel(issue.errorOperation),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: issueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (issue.errorMessage.isNotEmpty) ...[
            const SizedBox(height: 12),
            SelectableText(
              issue.errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
            ),
          ],
          if (issue.sourcePath.isNotEmpty || issue.targetPath.isNotEmpty) ...[
            const SizedBox(height: 13),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: .5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  if (issue.sourcePath.isNotEmpty)
                    _buildIssuePath(
                      context,
                      label: '来源'.tr(),
                      value: issue.sourcePath,
                    ),
                  if (issue.sourcePath.isNotEmpty &&
                      issue.targetPath.isNotEmpty)
                    const SizedBox(height: 7),
                  if (issue.targetPath.isNotEmpty)
                    _buildIssuePath(
                      context,
                      label: '目标'.tr(),
                      value: issue.targetPath,
                    ),
                ],
              ),
            ),
          ],
          if (issue.errorCode.isNotEmpty) ...[
            const SizedBox(height: 9),
            Text(
              issue.errorCode,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIssuePath(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: SelectableText(
            value,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
          ),
        ),
      ],
    );
  }

  IconData _statusIcon() {
    return switch (history.status) {
      SyncHistory_Status.STATUS_RUNNING => Icons.sync_rounded,
      SyncHistory_Status.STATUS_INTERRUPTED => Icons.pause_circle_outline,
      SyncHistory_Status.STATUS_CANCELED => Icons.cancel_outlined,
      SyncHistory_Status.STATUS_FAILED => Icons.error_outline_rounded,
      SyncHistory_Status.STATUS_PARTIAL => Icons.warning_amber_rounded,
      _ => Icons.check_rounded,
    };
  }

  String _triggerLabel() {
    return switch (history.trigger) {
      SyncHistory_Trigger.TRIGGER_SCHEDULED => '定时同步'.tr(),
      SyncHistory_Trigger.TRIGGER_RETRY => '重试同步'.tr(),
      _ => '手动同步'.tr(),
    };
  }

  String _formatDuration() {
    if (!history.hasFinishedAt()) return '进行中'.tr();
    final duration = history.finishedAt
        .toDateTime()
        .difference(history.startedAt.toDateTime());
    if (duration.inHours > 0) {
      return '{hours}小时 {minutes}分'.tr(args: {
        'hours': duration.inHours,
        'minutes': duration.inMinutes.remainder(60),
      });
    }
    if (duration.inMinutes > 0) {
      return '{minutes}分 {seconds}秒'.tr(args: {
        'minutes': duration.inMinutes,
        'seconds': duration.inSeconds.remainder(60),
      });
    }
    return '{seconds}秒'.tr(args: {
      'seconds': duration.inSeconds < 0 ? 0 : duration.inSeconds,
    });
  }

  Color _issueColor(BuildContext context, SyncHistoryIssue issue) {
    return issue.kind == SyncHistoryIssue_Kind.KIND_CONFLICT
        ? Colors.orange.shade700
        : Theme.of(context).colorScheme.error;
  }

  String _operationLabel(SyncHistoryIssue_Operation operation) {
    return switch (operation) {
      SyncHistoryIssue_Operation.OPERATION_SCAN => '扫描'.tr(),
      SyncHistoryIssue_Operation.OPERATION_UPLOAD => '上传'.tr(),
      SyncHistoryIssue_Operation.OPERATION_DOWNLOAD => '下载'.tr(),
      SyncHistoryIssue_Operation.OPERATION_DELETE => '删除'.tr(),
      SyncHistoryIssue_Operation.OPERATION_VERIFY => '校验'.tr(),
      _ => '处理'.tr(),
    };
  }
}

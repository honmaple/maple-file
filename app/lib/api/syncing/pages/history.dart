import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/api/syncing/providers/history.dart';
import 'package:maple_file/api/syncing/widgets/sync_history_records.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/platform/list.dart';
import 'package:maple_file/generated/proto/api/syncing/syncing.pb.dart';

class SyncHistoryScreen extends ConsumerWidget {
  const SyncHistoryScreen({super.key, required this.profileId});

  final int profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = syncHistoriesProvider(profileId);
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
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
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(title: Text('同步详情'.tr())),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomListSection(
              children: [
                ListTile(
                  leading: Icon(
                    SyncHistoryRecords.hasFailed(history)
                        ? Icons.error_outline
                        : Icons.check_circle_outline,
                    color: SyncHistoryRecords.hasFailed(history)
                        ? Theme.of(context).colorScheme.error
                        : Colors.green,
                  ),
                  title: Text(SyncHistoryRecords.historyTitle(history)),
                  subtitle: Text(
                    TimeUtil.datetimeToString(
                      history.hasFinishedAt()
                          ? history.finishedAt.toDateTime()
                          : history.startedAt.toDateTime(),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('同步结果'.tr()),
                  subtitle: Text(
                    '同步{synced}，跳过{skipped}，失败{failed}，冲突{conflicted}'
                        .tr(args: {
                      'synced': history.synced,
                      'skipped': history.skipped,
                      'failed': history.failed,
                      'conflicted': history.conflicted,
                    }),
                  ),
                ),
              ],
            ),
          ),
          if (history.errorSummary.isNotEmpty)
            SliverToBoxAdapter(
              child: CustomListSection(
                header: Text('失败原因'.tr()),
                hasLeading: false,
                children: [
                  ListTile(
                    title: Text('运行错误'.tr()),
                    subtitle: SelectableText(history.errorSummary),
                  ),
                ],
              ),
            ),
          if (history.issues.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                child: Text('问题详情'.tr()),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.builder(
              itemCount: history.issues.length,
              itemBuilder: (context, index) {
                final issue = history.issues[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      issue.sourceLabel.isNotEmpty
                          ? issue.sourceLabel
                          : issue.sourceKey.isNotEmpty
                              ? issue.sourceKey
                              : issue.sourcePath,
                    ),
                    subtitle: SelectableText(issue.errorMessage),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/api/syncing/providers/album_backup_run.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/utils/time.dart';
import 'package:maple_file/common/widgets/platform/list.dart';

class AlbumBackupHistoryScreen extends ConsumerStatefulWidget {
  const AlbumBackupHistoryScreen({super.key, required this.profileId});

  final int profileId;

  @override
  ConsumerState<AlbumBackupHistoryScreen> createState() =>
      _AlbumBackupHistoryScreenState();
}

class _AlbumBackupHistoryScreenState
    extends ConsumerState<AlbumBackupHistoryScreen> {
  final List<AlbumBackupRun> _older = [];
  bool _loadingMore = false;
  bool _hasMore = true;
  String? _loadError;

  Future<void> _loadMore(List<AlbumBackupRun> runs) async {
    if (_loadingMore || runs.isEmpty) return;
    setState(() => _loadingMore = true);
    try {
      final next = await AlbumBackupRunStore.load(widget.profileId,
          beforeId: runs.last.historyId);
      if (!mounted) return;
      setState(() {
        _loadError = null;
        final known = runs.map((run) => run.historyId).toSet();
        _older.addAll(next.where((run) => known.add(run.historyId)));
        _hasMore = next.length == 20;
      });
    } catch (error) {
      if (mounted) setState(() => _loadError = '$error');
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(title: Text('备份记录'.tr())),
      body: ref.watch(albumBackupRunsProvider(widget.profileId)).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('$error')),
            data: (firstPage) => firstPage.isEmpty
                ? Center(child: Text('暂无备份记录'.tr()))
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      CustomListSection(
                        children: [
                          for (final run in [...firstPage, ..._older])
                            PlatformListTile(
                              leading: Icon(
                                run.hasFailed
                                    ? Icons.error_outline
                                    : Icons.check_circle_outline,
                                color: run.hasFailed
                                    ? Theme.of(context).colorScheme.error
                                    : Colors.green,
                              ),
                              title: Text(
                                run.isRunning
                                    ? '备份中'.tr()
                                    : run.isInterrupted
                                        ? '备份已中断'.tr()
                                        : run.hasFailed
                                            ? '备份失败'.tr()
                                            : '备份完成'.tr(),
                              ),
                              subtitle: Text(
                                TimeUtil.datetimeToString(run.finishedAt),
                              ),
                              trailing: const PlatformListTileChevron(),
                              onTap: () => Navigator.of(context).push(
                                platformPageRoute(
                                  context: context,
                                  builder: (context) =>
                                      AlbumBackupRunDetailScreen(run: run),
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (_hasMore && firstPage.length == 20)
                        Center(
                          child: TextButton(
                            onPressed: _loadingMore
                                ? null
                                : () => _loadMore([...firstPage, ..._older]),
                            child:
                                Text(_loadingMore ? '加载中'.tr() : '加载更多'.tr()),
                          ),
                        ),
                      if (_loadError != null)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(_loadError!, textAlign: TextAlign.center),
                        ),
                    ],
                  ),
          ),
    );
  }
}

class AlbumBackupRunDetailScreen extends StatelessWidget {
  const AlbumBackupRunDetailScreen({super.key, required this.run});

  final AlbumBackupRun run;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(title: Text('备份详情'.tr())),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CustomListSection(
              children: [
                ListTile(
                  leading: Icon(
                    run.hasFailed
                        ? Icons.error_outline
                        : Icons.check_circle_outline,
                    color: run.hasFailed
                        ? Theme.of(context).colorScheme.error
                        : Colors.green,
                  ),
                  title: Text(run.isRunning
                      ? '备份中'.tr()
                      : run.isInterrupted
                          ? '备份已中断'.tr()
                          : run.hasFailed
                              ? '备份失败'.tr()
                              : '备份完成'.tr()),
                  subtitle: Text(TimeUtil.datetimeToString(run.finishedAt)),
                ),
                ListTile(
                  title: Text('备份结果'.tr()),
                  subtitle: Text(
                    '上传{uploaded}，跳过{skipped}，失败{failed}'.tr(args: {
                      'uploaded': run.uploaded,
                      'skipped': run.skipped,
                      'failed': run.failed,
                    }),
                  ),
                ),
              ],
            ),
          ),
          if (run.error != null)
            SliverToBoxAdapter(
              child: CustomListSection(
                header: Text('失败原因'.tr()),
                hasLeading: false,
                children: [
                  ListTile(
                    title: Text('运行错误'.tr()),
                    subtitle: SelectableText(run.error!),
                  ),
                ],
              ),
            ),
          if (run.failures.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                child: Text('失败文件'.tr()),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList.builder(
              itemCount: run.failures.length,
              itemBuilder: (context, index) {
                final failure = run.failures[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      failure.item.isEmpty
                          ? failure.album
                          : '${failure.album} / ${failure.item}',
                    ),
                    subtitle: SelectableText(failure.reason),
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/generated/proto/api/task/task.pb.dart';

import '../providers/service.dart';
import '../providers/task.dart';

class TaskList extends ConsumerStatefulWidget {
  const TaskList({super.key});

  factory TaskList.fromRoute(ModalRoute? route) {
    final args = route?.settings.arguments;
    if (args == null) {
      return const TaskList();
    }
    return const TaskList();
  }

  @override
  ConsumerState<TaskList> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList>
    with TickerProviderStateMixin {
  late Timer _timer;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      ref.invalidate(taskProvider(TaskListStatus.running));
      ref.invalidate(taskProvider(TaskListStatus.finished));
      ref.invalidate(taskProvider(TaskListStatus.failed));
    });
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _timer.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("任务列表".tr(context)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TabBar(
              controller: _tabController,
              // unselectedLabelColor: Colors.black,
              // labelColor: Colors.deepPurple,
              // // labelPadding: EdgeInsets.symmetric(horizontal: 16.0),
              // labelStyle: TextStyle(
              //   fontWeight: FontWeight.w600,
              // ),
              // indicatorColor: Colors.black,
              tabs: <Tab>[
                Tab(text: '正在进行'.tr(context)),
                Tab(text: '已完成'.tr(context)),
                Tab(text: '已失败'.tr(context)),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(context, TaskListStatus.running),
                _buildList(context, TaskListStatus.finished),
                _buildList(context, TaskListStatus.failed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildList(BuildContext context, TaskListStatus status) {
    return CustomRefresh(
      onRefresh: () => ref.invalidate(taskProvider(status)),
      childBuilder: (context, physics) {
        return CustomAsyncValue(
          value: ref.watch(taskProvider(status)),
          builder: (items) {
            if (items.isEmpty) {
              return Center(
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(
                      Icons.task_outlined,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text("暂无任务".tr(context)),
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: physics,
              itemCount: items.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return _buildListHeader(context, items, status);
                }
                return _buildListItem(context, items[index - 1]);
              },
            );
          },
        );
      },
    );
  }

  _buildListHeader(
    BuildContext context,
    List<Task> items,
    TaskListStatus status,
  ) {
    return ListTile(
      leading: status == TaskListStatus.running
          ? Text("剩余任务(${items.length})")
          : status == TaskListStatus.finished
              ? Text("已完成(${items.length})")
              : Text("已失败(${items.length})"),
      trailing: Wrap(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.clear, size: 16),
            label: Text("清除任务".tr(context)),
            onPressed: () async {
              await TaskService()
                  .removeTask(items.map((item) => item.id).toList());
            },
          ),
          if (status == TaskListStatus.running)
            TextButton.icon(
              icon: const Icon(Icons.play_circle, size: 16),
              label: Text("全部暂停".tr(context)),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  _buildListItem(BuildContext context, Task item) {
    return ListTile(
      leading: Icon(
        Icons.folder,
        size: 36,
        color: ColorUtil.backgroundColorWithString(item.name),
      ),
      title: Text(
        item.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: _buildProgress(context, item),
      trailing: _buildAction(context, item),
      onTap: () async {
        final result = await showListDialog(context, items: [
          ListDialogItem(
            child: ListTile(
              title: Text(item.name),
              subtitle: Text(item.progressState),
            ),
          ),
          if (isFinished(item))
            ListDialogItem(
              icon: Icons.refresh,
              label: "重试任务",
              value: "retry",
            ),
          if (isRunning(item))
            ListDialogItem(
              icon: Icons.cancel,
              label: "取消任务",
              value: "cancel",
            ),
          if (isFinished(item))
            ListDialogItem(
              icon: Icons.delete,
              label: "删除任务",
              value: "remove",
            ),
        ]);
        switch (result) {
          case "retry":
            TaskService().retryTask([item.id]);
          case "cancel":
            TaskService().cancelTask([item.id]);
          case "remove":
            TaskService().removeTask([item.id]);
        }
      },
    );
  }

  _buildAction(BuildContext context, Task item) {
    if (isFailed(item)) {
      return IconButton(
        icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
        onPressed: () {},
      );
    }
    if (isFinished(item)) {
      return null;
    }
    return IconButton(
      icon: Icon(Icons.play_circle_outline,
          color: Theme.of(context).colorScheme.primary),
      onPressed: () {},
    );
  }

  _buildProgress(BuildContext context, Task item) {
    return Column(
      children: [
        const SizedBox(height: 4),
        LinearProgressIndicator(
          color: Colors.teal,
          // backgroundColor: Colors.deepPurple,
          value: item.progress,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  item.progressState,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
            Text(
              stateLabel[item.state] ?? "未知状态",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/platform/list.dart';

import '../providers/file.dart';
import '../providers/repo.dart';
import '../providers/service.dart';

class RepoList extends ConsumerStatefulWidget {
  const RepoList({super.key});

  @override
  ConsumerState<RepoList> createState() => _RepoListState();
}

class _RepoListState extends ConsumerState<RepoList> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text('存储库'.tr()),
      ),
      body: CustomRefresh(
        onRefresh: () {
          ref.invalidate(repoProvider);
        },
        childBuilder: (context, physics) {
          final colorScheme = Theme.of(context).colorScheme;
          return CustomScrollView(
            physics: physics,
            slivers: [
              CustomSliverAsyncValue(
                value: ref.watch(repoProvider),
                builder: (items) {
                  return SliverToBoxAdapter(
                    child: CustomListSection(
                      children: [
                        for (final item in items)
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/file/setting/repo/edit',
                                arguments: item,
                              );
                            },
                            child: PlatformListTile(
                              title: Text(item.name),
                              subtitle: Text(
                                "存储类型：{driver}".tr(
                                  args: {"driver": item.driver},
                                ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              leading: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Center(
                                  child: Text(
                                    item.name.substring(0, 1).capitalize,
                                    style: TextStyle(
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              trailing: PlatformSwitch(
                                value: item.status,
                                activeTrackColor:
                                    Theme.of(context).primaryColor,
                                onChanged: (result) async {
                                  await FileService.instance
                                      .updateRepo(item.copyWith((r) {
                                    r.status = result;
                                  })).then((_) {
                                    ref.invalidate(repoProvider);
                                    ref.invalidate(fileProvider(item.path));
                                  });
                                },
                              ),
                            ),
                          ),
                        PlatformListTile(
                          leading: Icon(Icons.add),
                          title: Text("添加新存储".tr()),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/file/setting/repo/edit',
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

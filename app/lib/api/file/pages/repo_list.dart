import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/custom.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('存储库'.tr(context)),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text("存储库".tr(context)),
                    dense: true,
                  ),
                  CustomAsyncValue(
                    value: ref.watch(repoProvider),
                    builder: (items) => Column(
                      children: [
                        for (final item in items)
                          ListTile(
                            title: Text(item.name),
                            subtitle: Text(
                              "存储类型：{driver}".tr(
                                context,
                                args: {"driver": item.driver},
                              ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: Switch(
                              value: item.status,
                              onChanged: (result) async {
                                await FileService()
                                    .updateRepo(item.copyWith((r) {
                                  r.status = result;
                                })).then((_) {
                                  ref.invalidate(repoProvider);
                                  ref.invalidate(fileProvider(item.path));
                                });
                              },
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/file/setting/repo/edit',
                                arguments: item,
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  ListTile(
                    trailing: const Icon(Icons.add),
                    title: Text("添加新存储".tr(context)),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/file/setting/repo/edit',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

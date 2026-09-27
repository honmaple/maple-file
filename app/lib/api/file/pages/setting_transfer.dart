import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';

import '../providers/file_setting.dart';

class FileSettingTransferScreen extends ConsumerWidget {
  const FileSettingTransferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(fileSettingProvider);
    final textTheme = Theme.of(context).textTheme;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('文件传输'.tr()),
      ),
      body: CustomRefresh(
        onRefresh: () {
          ref.invalidate(fileSettingProvider);
        },
        childBuilder: (context, physics) {
          return CustomScrollView(
            physics: physics,
            slivers: [
              SliverList.list(
                children: [
                  CustomListSection(
                    header: Container(
                      alignment: Alignment.centerLeft,
                      child: Text("文件上传".tr(), style: textTheme.bodySmall),
                    ),
                    hasLeading: false,
                    dividerMargin: 20,
                    children: [
                      CustomListTileOptions(
                        label: '上传策略'.tr(),
                        value: setting.uploadPolicy,
                        options: FileUploadPolicy.values.map((policy) {
                          return CustomOption(
                            label: policy.label,
                            value: policy,
                          );
                        }).toList(),
                        onTap: (result) {
                          ref
                              .read(fileSettingProvider.notifier)
                              .update((state) {
                            return state.copyWith(uploadPolicy: result);
                          });
                        },
                      ),
                    ],
                  ),
                  CustomListSection(
                    header: Container(
                      alignment: Alignment.centerLeft,
                      child: Text("文件下载".tr(), style: textTheme.bodySmall),
                    ),
                    hasLeading: false,
                    dividerMargin: 20,
                    children: [
                      PlatformListTile(
                        title: Text('默认保存路径'.tr()),
                        subtitle: setting.downloadPath == null
                            ? FutureBuilder(
                                future: PathUtil.getDownloadsPath(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (snapshot.hasData) {
                                    return Text(
                                      '${snapshot.data}',
                                      style: textTheme.bodySmall
                                          ?.copyWith(color: Colors.grey),
                                    );
                                  }
                                  return Text('加载中...'.tr());
                                },
                              )
                            : Text(
                                setting.downloadPath!,
                                style: textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                        trailing: PlatformListTileChevron(),
                        onTap: () async {
                          final result =
                              await FilePicker.platform.getDirectoryPath();
                          if (result == null) return;
                          ref
                              .read(fileSettingProvider.notifier)
                              .update((state) {
                            return state.copyWith(downloadPath: result);
                          });
                        },
                      ),
                      CustomListTilePrompt(
                        type: CustomListTilePromptType.number,
                        label: '同时下载任务数'.tr(),
                        value: '${setting.downloadQueueSize}',
                        onTap: (result) {
                          ref
                              .read(fileSettingProvider.notifier)
                              .update((state) {
                            return state.copyWith(
                              downloadQueueSize: int.parse(result),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

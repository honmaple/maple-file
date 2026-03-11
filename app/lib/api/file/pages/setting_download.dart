import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:file_picker/file_picker.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';

import '../providers/file_setting.dart';

class FileSettingDownload extends ConsumerStatefulWidget {
  const FileSettingDownload({super.key});

  @override
  ConsumerState<FileSettingDownload> createState() =>
      _FileSettingDownloadState();
}

class _FileSettingDownloadState extends ConsumerState<FileSettingDownload> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text('文件下载'.tr()),
      ),
      body: CustomRefresh(
        onRefresh: () {
          ref.invalidate(fileSettingProvider);
        },
        childBuilder: (context, physics) {
          return CustomScrollView(
            physics: physics,
            slivers: [
              buildBody(context, ref),
            ],
          );
        },
      ),
    );
  }

  buildBody(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final setting = ref.watch(fileSettingProvider);
    return SliverList.list(
      children: <Widget>[
        CustomListSection(
          hasLeading: false,
          dividerMargin: 20,
          children: [
            ListTile(
              title: Text('默认保存路径'.tr()),
              subtitle: setting.downloadPath == null
                  ? FutureBuilder(
                      future: PathUtil.getDownloadsPath(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }
                        if (snapshot.hasData) {
                          return Text(
                            "${snapshot.data}",
                            style: textTheme.bodySmall
                                ?.copyWith(color: Colors.grey),
                          );
                        }
                        return Text("加载中...".tr());
                      },
                    )
                  : Text(
                      setting.downloadPath!,
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
              trailing: isMaterial(context)
                  ? Icon(Icons.chevron_right)
                  : PlatformListTileChevron(),
              onTap: () async {
                String? result = await FilePicker.platform.getDirectoryPath();
                if (result != null) {
                  ref.read(fileSettingProvider.notifier).update((state) {
                    return state.copyWith(downloadPath: result);
                  });
                }
              },
            ),
            CustomListTilePrompt(
              type: CustomListTilePromptType.number,
              label: '同时下载任务数'.tr(),
              value: "${setting.downloadQueueSize}",
              onTap: (result) {
                ref.read(fileSettingProvider.notifier).update((state) {
                  return state.copyWith(uploadSliceSize: int.parse(result));
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

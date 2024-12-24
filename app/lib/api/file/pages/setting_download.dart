import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/path.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/custom.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('文件下载'.tr()),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: CustomRefresh(
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
      ),
    );
  }

  buildBody(BuildContext context, WidgetRef ref) {
    final setting = ref.watch(fileSettingProvider);
    return SliverList.list(
      children: <Widget>[
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text("文件下载".tr()),
                dense: true,
              ),
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
                            return Text("${snapshot.data}");
                          }
                          return Text("加载中...".tr());
                        },
                      )
                    : Text(setting.downloadPath!),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  String? result = await FilePicker.platform.getDirectoryPath();
                  if (result != null) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(downloadPath: result);
                    });
                  }
                },
              ),
              ListTile(
                title: Text('同时下载任务数'.tr()),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("${setting.downloadQueueSize}"),
                  ],
                ),
                onTap: () async {
                  final result = await showNumberEditingDialog(
                    context,
                    "同时下载任务数".tr(),
                    value: setting.downloadQueueSize.toString(),
                  );
                  if (result != null) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(uploadSliceSize: int.parse(result));
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

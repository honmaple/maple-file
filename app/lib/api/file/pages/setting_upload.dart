import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/custom.dart';

import '../providers/file_setting.dart';

class FileSettingUpload extends ConsumerStatefulWidget {
  const FileSettingUpload({super.key});

  @override
  ConsumerState<FileSettingUpload> createState() => _FileSettingUploadState();
}

class _FileSettingUploadState extends ConsumerState<FileSettingUpload> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文件上传'.tr(context)),
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
                title: Text("文件上传".tr(context)),
                dense: true,
              ),
              ListTile(
                title: const Text('自动重命名'),
                trailing: Switch(
                  value: setting.uploadRename,
                  onChanged: (bool value) async {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(uploadRename: value);
                    });
                  },
                ),
              ),
              if (setting.uploadRename)
                ListTile(
                  title: const Text('重命名格式'),
                  trailing: Text(setting.uploadFormat == ""
                      ? "{filename}{extension}"
                      : setting.uploadFormat),
                  onTap: () async {
                    _controller.text = setting.uploadFormat;

                    final result = await showEditingDialog(
                      context,
                      "重命名格式",
                      controller: _controller,
                      helper: buildHelper(),
                    );
                    if (result != null) {
                      ref.read(fileSettingProvider.notifier).update((state) {
                        return state.copyWith(uploadFormat: result);
                      });
                    }
                  },
                ),
              ListTile(
                title: const Text('分片大小'),
                subtitle: const Text(
                  '文件上传分片大小',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("${setting.uploadSliceSize}KB"),
                  ],
                ),
                onTap: () async {
                  _controller.text = setting.uploadSliceSize.toString();

                  final result = await showEditingDialog(
                    context,
                    "分片大小(单位：KB)",
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
        Card(
          child: Column(
            children: [
              const ListTile(
                title: Text("文件限制"),
                dense: true,
              ),
              ListTile(
                title: const Text('大小限制'),
                subtitle: const Text(
                  '0表示不限制',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("${setting.uploadLimitSize}MB"),
                  ],
                ),
                onTap: () async {
                  _controller.text = setting.uploadLimitSize.toString();

                  final result = await showEditingDialog(
                    context,
                    "大小限制(单位：MB)",
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  );
                  if (result != null) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(uploadLimitSize: int.parse(result));
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('格式限制'),
                subtitle: const Text(
                  '多个格式使用逗号分隔。例如: .mp4,.png',
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(setting.uploadLimitType == ""
                        ? "未设置"
                        : setting.uploadLimitType),
                  ],
                ),
                onTap: () async {
                  _controller.text = setting.uploadLimitType;

                  final result = await showEditingDialog(
                    context,
                    "格式限制",
                    controller: _controller,
                  );
                  if (result != null) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(uploadLimitType: result);
                    });
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildHelper() {
    Map<String, String> formats = {
      "文件名": "{filename}",
      "文件扩展": "{extension}",
      "年": "{time:year}",
      "月": "{time:month}",
      "日": "{time:day}",
      "时": "{time:hour}",
      "分": "{time:minute}",
      "秒": "{time:second}",
    };
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final key in formats.keys)
          ActionChip(
            label: Text(key),
            labelStyle: TextStyle(
              fontSize: kDefaultFontSize * 0.875,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              _controller.text = "${_controller.text}${formats[key]}";
            },
          ),
      ],
    );
  }
}

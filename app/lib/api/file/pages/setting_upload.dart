import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/platform.dart';

import '../providers/file_setting.dart';

class FileSettingUpload extends ConsumerStatefulWidget {
  const FileSettingUpload({super.key});

  @override
  ConsumerState<FileSettingUpload> createState() => _FileSettingUploadState();
}

class _FileSettingUploadState extends ConsumerState<FileSettingUpload> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text('文件上传'.tr()),
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
    final setting = ref.watch(fileSettingProvider);
    return SliverList.list(
      children: <Widget>[
        CustomListSection(
          hasLeading: false,
          dividerMargin: 20,
          children: [
            CustomListTileSwitch(
              label: '自动重命名'.tr(),
              value: setting.uploadRename,
              onChanged: (result) {
                ref.read(fileSettingProvider.notifier).update((state) {
                  return state.copyWith(uploadRename: result);
                });
              },
            ),
            if (setting.uploadRename)
              CustomListTilePrompt(
                type: CustomListTilePromptType.path,
                label: '重命名格式'.tr(),
                value: setting.uploadFormat,
                subtitle: Text(
                  "默认为 {path}".tr(args: {
                    "path": "{filename}{extension}",
                  }),
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: (result) {
                  ref.read(fileSettingProvider.notifier).update((state) {
                    return state.copyWith(uploadFormat: result);
                  });
                },
              ),
            CustomListTilePrompt(
              type: CustomListTilePromptType.number,
              label: '分片大小'.tr(),
              value: "${setting.uploadSliceSize}",
              subtitle: Text(
                '文件上传分片大小(单位：KB)'.tr(),
                style: const TextStyle(fontSize: 12),
              ),
              onTap: (result) {
                ref.read(fileSettingProvider.notifier).update((state) {
                  return state.copyWith(uploadSliceSize: int.parse(result));
                });
              },
            ),
          ],
        ),
        CustomListSection(
          hasLeading: false,
          dividerMargin: 20,
          children: [
            CustomListTilePrompt(
              type: CustomListTilePromptType.number,
              label: '大小限制'.tr(),
              value: "${setting.uploadLimitSize}",
              subtitle: Text(
                '0表示不限制(单位：MB)'.tr(),
                style: const TextStyle(fontSize: 12),
              ),
              onTap: (result) {
                ref.read(fileSettingProvider.notifier).update((state) {
                  return state.copyWith(uploadLimitSize: int.parse(result));
                });
              },
            ),
            CustomListTilePrompt(
              label: '格式限制'.tr(),
              value: setting.uploadLimitType,
              subtitle: Text(
                '多个格式使用逗号分隔。例如: .mp4,.png'.tr(),
                style: const TextStyle(fontSize: 12),
              ),
              onTap: (result) {
                ref.read(fileSettingProvider.notifier).update((state) {
                  return state.copyWith(uploadLimitType: result);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

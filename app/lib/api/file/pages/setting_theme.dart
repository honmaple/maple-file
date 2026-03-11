import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/platform.dart';
import 'package:maple_file/api/setting/providers/setting_appearance.dart';

import '../providers/file_setting.dart';

class FileSettingTheme extends ConsumerStatefulWidget {
  const FileSettingTheme({super.key});

  @override
  ConsumerState<FileSettingTheme> createState() => _FileSettingThemeState();
}

class _FileSettingThemeState extends ConsumerState<FileSettingTheme> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final setting = ref.watch(fileSettingProvider);
    final thumbSetting = setting.thumb ?? FileThumbSetting();
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text('显示设置'.tr()),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          CustomListSection(
            hasLeading: false,
            dividerMargin: 20,
            children: [
              CustomListTileOptions(
                label: '布局'.tr(),
                value: setting.view,
                options: FileListView.values.map((item) {
                  return CustomOption(label: item.label, value: item);
                }).toList(),
                onTap: (result) {
                  ref.read(fileSettingProvider.notifier).update((state) {
                    return state.copyWith(view: result);
                  });
                },
              ),
              PlatformListTile(
                title: Text('排序'.tr()),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '按{sort}排序'.tr(
                        args: {"sort": setting.sort.label},
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    PlatformListTileChevron(),
                  ],
                ),
                onTap: () async {
                  final result = await showCustomListOptions(
                    context: context,
                    options: FileListSort.values.map((item) {
                      return CustomOption(
                        label: item.label,
                        value: item,
                        trailing: setting.sort == item
                            ? Text(setting.sortReversed ? "倒序".tr() : "正序".tr())
                            : null,
                      );
                    }).toList(),
                  );
                  if (result != null) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      if (result == setting.sort) {
                        return state.copyWith(
                            sortReversed: !state.sortReversed);
                      }
                      return state.copyWith(sort: result);
                    });
                  }
                },
              ),
              CustomListTilePrompt(
                type: CustomListTilePromptType.number,
                label: '分页大小'.tr(),
                value: "${setting.paginationSize}",
                subtitle: Text(
                  "为0时表示不分页".tr(),
                  maxLines: 3,
                ),
                onTap: (result) {
                  ref.read(fileSettingProvider.notifier).update((state) {
                    return state.copyWith(
                      paginationSize: int.parse(result),
                    );
                  });
                },
              ),
            ],
          ),
          CustomListSection(
            hasLeading: false,
            dividerMargin: 20,
            children: [
              CustomListTileOptions(
                label: '图标'.tr(),
                value: setting.icon,
                options: FileListIcon.values.map((item) {
                  return CustomOption(label: item.label, value: item);
                }).toList(),
                onTap: (result) {
                  ref.read(fileSettingProvider.notifier).update((state) {
                    return state.copyWith(icon: result);
                  });
                },
              ),
              PlatformListTile(
                title: Text('图标颜色'.tr()),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      setting.iconColor ?? "默认".tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    PlatformListTileChevron(),
                  ],
                ),
                onTap: () async {
                  final appearance = ref.read(appearanceProvider);
                  final result = await showCustomDialog<FlexScheme>(
                    context,
                    height: MediaQuery.sizeOf(context).height * 0.618,
                    child: ListView(
                      children: [
                        PlatformListTile(
                          title: Text("默认".tr()),
                          leading: Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: appearance.scheme.primaryColor(context),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          // selected: setting.iconColor == null,
                          onTap: () {
                            Navigator.of(context).pop(appearance.scheme);
                          },
                        ),
                        for (final scheme in FlexScheme.values)
                          PlatformListTile(
                            title: Text(scheme.name.capitalize),
                            leading: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                color: scheme.primaryColor(context),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                            // selected: setting.iconColor == scheme.name,
                            onTap: () {
                              Navigator.of(context).pop(scheme);
                            },
                          ),
                      ],
                    ),
                  );
                  if (result != null) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(
                        iconColor: result.name == appearance.scheme.name
                            ? null
                            : result.name,
                      );
                    });
                  }
                },
              ),
            ],
          ),
          if (setting.icon == FileListIcon.thumb)
            CustomListSection(
              header: Container(
                alignment: Alignment.centerLeft,
                child: Text("缩略图设置".tr(), style: themeData.textTheme.bodySmall),
              ),
              hasLeading: false,
              dividerMargin: 20,
              children: [
                CustomListTilePrompt(
                  type: CustomListTilePromptType.number,
                  label: "宽度".tr(),
                  value: "${thumbSetting.width}",
                  onTap: (result) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(
                        thumb: thumbSetting.copyWith(width: int.parse(result)),
                      );
                    });
                  },
                ),
                CustomListTilePrompt(
                  type: CustomListTilePromptType.number,
                  label: "高度".tr(),
                  value: "${thumbSetting.height}",
                  onTap: (result) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(
                        thumb: thumbSetting.copyWith(height: int.parse(result)),
                      );
                    });
                  },
                ),
                CustomListTilePrompt(
                  type: CustomListTilePromptType.number,
                  label: "质量".tr(),
                  value: "${thumbSetting.quality}",
                  onTap: (result) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(
                        thumb:
                            thumbSetting.copyWith(quality: int.parse(result)),
                      );
                    });
                  },
                ),
                CustomListTileSwitch(
                  label: "自动清理".tr(),
                  value: thumbSetting.autoClean,
                  subtitle: Text(
                    "开启后将自动清理最近一个月未访问的缩略图".tr(),
                    maxLines: 3,
                  ),
                  onChanged: (result) {
                    ref.read(fileSettingProvider.notifier).update((state) {
                      return state.copyWith(
                        thumb: thumbSetting.copyWith(autoClean: result),
                      );
                    });
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}

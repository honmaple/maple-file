import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/platform.dart';

import '../providers/setting_appearance.dart';

extension ThemeModeExtension on ThemeMode {
  String get label {
    Map<ThemeMode, String> labels = {
      ThemeMode.system: "系统".tr(),
      ThemeMode.light: "亮色".tr(),
      ThemeMode.dark: "深色".tr(),
    };
    return labels[this] ?? "未知".tr();
  }

  IconData? get icon {
    final Map<ThemeMode, IconData> icons = {
      ThemeMode.system: Util.isMobile
          ? Util.isIOS
              ? Icons.phone_iphone
              : Icons.phone_android
          : Icons.computer,
      ThemeMode.light: Icons.light_mode,
      ThemeMode.dark: Icons.dark_mode,
    };
    return icons[this];
  }
}

class SettingTheme extends ConsumerStatefulWidget {
  const SettingTheme({super.key});

  @override
  ConsumerState<SettingTheme> createState() => _SettingThemeState();
}

class _SettingThemeState extends ConsumerState<SettingTheme> {
  @override
  Widget build(BuildContext context) {
    final appearance = ref.watch(appearanceProvider);
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text('主题'.tr()),
        cupertino: (context, t) {
          return CupertinoNavigationBarData(
            previousPageTitle: "设置".tr(),
          );
        },
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: PlatformSegmentedButton(
              padding: EdgeInsets.symmetric(vertical: 8),
              segments: [
                for (final value in ThemeMode.values)
                  PlatformSegment(
                    value: value,
                    label: Text(value.label),
                    icon: Icon(value.icon, size: 16),
                  ),
              ],
              groupValue: appearance.themeMode,
              onValueChanged: (ThemeMode mode) {
                ref.read(appearanceProvider.notifier).update((state) {
                  return state.copyWith(themeMode: mode);
                });
              },
            ),
          ),
          CustomListSection(
            children: [
              PlatformListTile(
                title: Text("默认".tr()),
                // visualDensity: VisualDensity(vertical: -2),
                leading: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: defaultFlexScheme.primaryColor(context),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                trailing: appearance.themeColor == null
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                // selected: appearance.themeColor == null,
                onTap: () {
                  ref.read(appearanceProvider.notifier).update((state) {
                    return state.copyWith(themeColor: null);
                  });
                },
              ),
              for (final scheme in FlexScheme.values)
                PlatformListTile(
                  title: Text(scheme.name.capitalize),
                  // visualDensity: VisualDensity(vertical: -2),
                  leading: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      color: scheme.primaryColor(context),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  trailing: appearance.scheme == scheme
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                  onTap: () {
                    ref.read(appearanceProvider.notifier).update((state) {
                      return state.copyWith(themeColor: scheme.name);
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

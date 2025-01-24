import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';

import '../providers/setting_appearance.dart';

class SettingTheme extends ConsumerStatefulWidget {
  const SettingTheme({super.key});

  @override
  ConsumerState<SettingTheme> createState() => _SettingThemeState();
}

class _SettingThemeState extends ConsumerState<SettingTheme> {
  @override
  Widget build(BuildContext context) {
    final appearance = ref.watch(appearanceProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('主题'.tr()),
      ),
      body: Container(
        // margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: [
            ListTile(
              title: SegmentedButton<ThemeMode>(
                segments: <ButtonSegment<ThemeMode>>[
                  ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text("系统".tr()),
                      icon: Icon(Util.isMobile
                          ? Icons.phone_android
                          : Icons.computer)),
                  ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('亮色'.tr()),
                      icon: const Icon(Icons.light_mode)),
                  ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('暗色'.tr()),
                      icon: const Icon(Icons.dark_mode)),
                ],
                selected: <ThemeMode>{appearance.themeMode},
                onSelectionChanged: (Set<ThemeMode> newSelection) {
                  ref.read(appearanceProvider.notifier).update((state) {
                    return state.copyWith(themeMode: newSelection.first);
                  });
                },
              ),
            ),
            ListTile(
              title: Text("默认".tr()),
              leading: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: defaultFlexScheme.primaryColor(context),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
              ),
              selected: appearance.themeColor == null,
              onTap: () {
                ref.read(appearanceProvider.notifier).update((state) {
                  return state.copyWith(themeColor: null);
                });
              },
            ),
            for (final scheme in FlexScheme.values)
              ListTile(
                title: Text(scheme.name.capitalize),
                leading: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: scheme.primaryColor(context),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                selected: appearance.scheme == scheme,
                onTap: () {
                  ref.read(appearanceProvider.notifier).update((state) {
                    return state.copyWith(themeColor: scheme.name);
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

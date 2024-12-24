import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        title: Text('Theme'.tr()),
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
                      label: Text("System".tr()),
                      icon: Icon(Util.isMobile()
                          ? Icons.phone_android
                          : Icons.computer)),
                  ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('Light'.tr()),
                      icon: const Icon(Icons.light_mode)),
                  ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('Dark'.tr()),
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
            for (final model in ThemeModel.themes)
              ListTile(
                title: Text(model.name),
                leading: Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: model.color,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                selected: appearance.color == model.color,
                onTap: () {
                  ref.read(appearanceProvider.notifier).update((state) {
                    return state.copyWith(themeColor: model.name);
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

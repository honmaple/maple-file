import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';

import '../providers/setting_appearance.dart';

class SettingLocale extends ConsumerStatefulWidget {
  const SettingLocale({super.key});

  @override
  ConsumerState<SettingLocale> createState() => _SettingLocaleState();
}

class _SettingLocaleState extends ConsumerState<SettingLocale> {
  @override
  Widget build(BuildContext context) {
    final currentLocale =
        ref.watch(appearanceProvider.select((state) => state.locale));
    return Scaffold(
      appBar: AppBar(
        title: Text('Language'.tr()),
      ),
      body: Container(
        // margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: ListView(
          children: [
            RadioListTile(
              title: const Text("中文"),
              groupValue: currentLocale,
              value: "zh",
              onChanged: (val) {
                if (val != null) {
                  ref.read(appearanceProvider.notifier).update((state) {
                    return state.copyWith(locale: val);
                  });
                }
              },
            ),
            RadioListTile(
              title: const Text("English"),
              groupValue: currentLocale,
              value: "en",
              onChanged: (val) {
                if (val != null) {
                  ref.read(appearanceProvider.notifier).update((state) {
                    return state.copyWith(locale: val);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

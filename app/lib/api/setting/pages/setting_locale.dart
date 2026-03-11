import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/platform.dart';

import '../providers/setting_appearance.dart';

class SettingLocale extends ConsumerStatefulWidget {
  const SettingLocale({super.key});

  @override
  ConsumerState<SettingLocale> createState() => _SettingLocaleState();
}

class _SettingLocaleState extends ConsumerState<SettingLocale> {
  final List<(String, String)> _locales = [
    ("zh", "中文"),
    ("en", "English"),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocale =
        ref.watch(appearanceProvider.select((state) => state.locale));
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('语言'.tr()),
        cupertino: (context, _) {
          return CupertinoNavigationBarData(
            previousPageTitle: "设置".tr(),
          );
        },
      ),
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      body: ListView(
        children: [
          CustomListSection(
            hasLeading: false,
            dividerMargin: 20,
            children: [
              for (final locale in _locales)
                PlatformListTile(
                  title: Text(locale.$2),
                  trailing: PlatformRadio(
                    value: locale.$1,
                    groupValue: currentLocale,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (result) {
                      if (result != null) {
                        ref.read(appearanceProvider.notifier).update((state) {
                          return state.copyWith(locale: result);
                        });
                      }
                    },
                  ),
                  onTap: () {
                    ref.read(appearanceProvider.notifier).update((state) {
                      return state.copyWith(locale: locale.$1);
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

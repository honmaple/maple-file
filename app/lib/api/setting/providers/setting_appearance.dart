import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import 'setting.dart';

part 'setting_appearance.freezed.dart';
part 'setting_appearance.g.dart';

const defaultFlexScheme = FlexScheme.redM3;

extension FlexSchemeExtension on FlexScheme {
  Color primaryColor(BuildContext context) {
    switch (MediaQuery.of(context).platformBrightness) {
      case Brightness.light:
        return colors(Brightness.light).primary;
      case Brightness.dark:
        return colors(Brightness.dark).primary;
    }
  }
}

@freezed
class AppearanceSetting with _$AppearanceSetting {
  const AppearanceSetting._();

  const factory AppearanceSetting({
    @Default(ThemeMode.system) @JsonKey(name: 'theme.mode') ThemeMode themeMode,
    @JsonKey(name: 'theme.color') String? themeColor,
    @Default("zh") @JsonKey(name: 'locale') String locale,
  }) = _AppearanceSetting;

  factory AppearanceSetting.fromJson(Map<String, Object?> json) =>
      _$AppearanceSettingFromJson(json);

  FlexScheme get scheme => FlexScheme.values.firstWhere(
        (item) => item.name == themeColor,
        orElse: () => defaultFlexScheme,
      );
}

final appearanceProvider = newSettingNotifier(
  "app.appearance",
  const AppearanceSetting(),
  AppearanceSetting.fromJson,
);

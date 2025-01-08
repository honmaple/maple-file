import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';

import 'setting.dart';

part 'setting_appearance.freezed.dart';
part 'setting_appearance.g.dart';

class ThemeModel {
  final String name;
  final Color color;

  const ThemeModel({
    required this.name,
    required this.color,
  });

  // static const defaultColor = Color.fromRGBO(32, 82, 67, 1);
  static const defaultColor = Color.fromRGBO(244, 63, 94, 0.2);

  static final defaultTheme = ThemeModel(
    name: '默认'.tr(),
    color: defaultColor,
  );

  static final themes = [
    defaultTheme,
    const ThemeModel(
      name: 'Blue',
      color: Colors.blue,
    ),
    const ThemeModel(
      name: 'Red',
      color: Colors.red,
    ),
    const ThemeModel(
      name: 'Pink',
      color: Colors.pink,
    ),
    const ThemeModel(
      name: 'Purple',
      color: Colors.purple,
    ),
    const ThemeModel(
      name: 'DeepPurple',
      color: Colors.deepPurple,
    ),
    const ThemeModel(
      name: 'Indigo',
      color: Colors.indigo,
    ),
    const ThemeModel(
      name: 'LightBlue',
      color: Colors.lightBlue,
    ),
    const ThemeModel(
      name: 'Cyan',
      color: Colors.cyan,
    ),
    const ThemeModel(
      name: 'Teal',
      color: Colors.teal,
    ),
    const ThemeModel(
      name: 'LightGreen',
      color: Colors.lightGreen,
    ),
    const ThemeModel(
      name: 'Lime',
      color: Colors.lime,
    ),
    const ThemeModel(
      name: 'Yellow',
      color: Colors.yellow,
    ),
    const ThemeModel(
      name: 'Amber',
      color: Colors.amber,
    ),
    const ThemeModel(
      name: 'Orange',
      color: Colors.orange,
    ),
    const ThemeModel(
      name: 'DeepOrange',
      color: Colors.deepOrange,
    ),
    const ThemeModel(
      name: 'Brown',
      color: Colors.brown,
    ),
    const ThemeModel(
      name: 'Grey',
      color: Colors.grey,
    ),
    const ThemeModel(
      name: 'BlueGrey',
      color: Colors.blueGrey,
    ),
  ];
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

  Color get color => ThemeModel.themes
      .firstWhere(
        (item) => item.name == themeColor,
        orElse: () => ThemeModel.defaultTheme,
      )
      .color;

  bool isDefaultColor() {
    return color == ThemeModel.defaultColor;
  }
}

final appearanceProvider = newSettingNotifier(
  "app.appearance",
  const AppearanceSetting(),
  AppearanceSetting.fromJson,
);

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'i18n/en_us.dart';
import 'i18n/zh_cn.dart';

const translations = {
  "en": enUS,
  "zh": zhCN,
};

extension I18nContext on BuildContext {
  String tr(String key, {Object? args}) {
    final t = I18n.of(this);
    if (t == null) {
      return key;
    }
    return t.tr(key, args: args);
  }

  String? localeName() {
    final t = I18n.of(this);
    return t?.localeName;
  }
}

extension I18nString on String {
  String tr(BuildContext context, {Object? args}) {
    final t = I18n.of(context);
    if (t == null) {
      return this;
    }
    return t.tr(this, args: args);
  }
}

extension I18nText on Text {
  Text tr(BuildContext context, {Object? args}) {
    final t = I18n.of(context);
    if (t == null || data == null) {
      return this;
    }
    return Text(t.tr(data ?? '', args: args),
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis);
  }
}

class I18n {
  I18n(this.locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.languageCode);

  final Locale locale;
  final String localeName;

  static I18n? of(BuildContext context) {
    return Localizations.of<I18n>(context, I18n);
  }

  static const LocalizationsDelegate<I18n> delegate = _I18nDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  String tr(String key, {Object? args}) {
    final l = translations[localeName];
    if (l == null) {
      return key;
    }
    String result = l[key] ?? key;
    if (result == "") {
      return key;
    }
    if (args == null) {
      return result;
    }
    if (args is List<Object>) {
      return _tr(result, args: args);
    }
    if (args is Map<String, Object>) {
      return _tr(result, namedArgs: args);
    }
    return result;
  }

  String _tr(
    String key, {
    List<Object>? args,
    Map<String, Object>? namedArgs,
  }) {
    String result = key;
    if (args != null) {
      for (final arg in args) {
        result = result.replaceFirst(RegExp("{}"), "$arg");
      }
      return result;
    }
    if (namedArgs != null) {
      namedArgs.forEach((name, arg) {
        result = result.replaceAll(RegExp("{$name}"), "$arg");
      });
    }
    return result;
  }
}

class _I18nDelegate extends LocalizationsDelegate<I18n> {
  const _I18nDelegate();

  @override
  Future<I18n> load(Locale locale) {
    return SynchronousFuture<I18n>(lookupI18n(locale));
  }

  @override
  bool isSupported(Locale locale) {
    for (final l in I18n.supportedLocales) {
      if (l.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  @override
  bool shouldReload(_I18nDelegate old) => false;
}

I18n lookupI18n(Locale locale) {
  return I18n(locale);
}

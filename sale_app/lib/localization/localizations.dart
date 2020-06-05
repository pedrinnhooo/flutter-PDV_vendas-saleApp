import 'package:flutter/material.dart';
import 'package:fluggy/generated/locale_base.dart';

class LocDelegate extends LocalizationsDelegate<LocaleBase> {
  const LocDelegate();
  final idMap = const {'pt': 'locales/PT_BR.json', 'en': 'locales/EN_US.json', 'es': 'locales/ES.json'};

  @override
  bool isSupported(Locale locale) => ['pt', 'en', 'es'].contains(locale.languageCode);

  @override
  Future<LocaleBase> load(Locale locale) async {
    var lang = 'pt';
    if (isSupported(locale)) lang = locale.languageCode;
    final loc = LocaleBase();
    await loc.load(idMap[lang]);
    return loc;
  }

  @override
  bool shouldReload(LocDelegate old) => false;
}
import 'package:flutter/material.dart' show Locale, LocalizationsDelegate;

import 'app_localization.dart';

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['vi','en','ko', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocalizations = AppLocalizations(locale);
    await appLocalizations.load();
    return appLocalizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

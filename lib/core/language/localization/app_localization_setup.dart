// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localization.dart';

class AppLocalizationSetup {
  static const Iterable<Locale> supportedLanguage = [
    Locale('vi'),  
    Locale('en'),  
    Locale('ko'),  
    Locale('ja'), 
  ];

  static Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  static Locale localeResolutionCallback(
      Locale? locale, Iterable<Locale> supportedLocales) {
    for (Locale supportedLocal in supportedLanguage) {
      if (supportedLocal.languageCode == locale!.languageCode &&
          supportedLocal.countryCode == locale.countryCode) {
        return supportedLocal;
      }
    }
    return supportedLanguage.first;
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum SupportedL10N {
  en,
  ar;

  String readableFormat() {
    switch (this) {
      case SupportedL10N.en:
        return "English";
      case SupportedL10N.ar:
        return "العربية";
    }
  }

  static SupportedL10N? fromString(String langName) {
    return SupportedL10N.values
        .firstWhere((l10n) => l10n.readableFormat() == langName);
  }
}

@lazySingleton
class LocalizationService {
  String get langAssetPath => 'assets/translations';

  List<Locale> get supportedLocales =>
      SupportedL10N.values.map((langCode) => Locale(langCode.name)).toList();

  bool get saveLocale => true;

  void setLocale(BuildContext context, String langCode) {
    context.setLocale(Locale(langCode));
  }

  String getCurrentLanguageCode(BuildContext context) =>
      context.locale.languageCode;

  /// Gets the current locale from the context
  Locale getCurrentLocale(BuildContext context) => context.locale;

  /// Sets the locale using a Locale object
  void setLocaleFromLocale(BuildContext context, Locale locale) {
    context.setLocale(locale);
  }
}

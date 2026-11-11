import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// Loads a localized HTML asset from `assets/{baseName}_{locale}.html` if available,
/// seamlessly falling back to `assets/{baseName}.html`.
Future<String> loadLocalizedHtmlAsset(
  BuildContext context,
  String baseName,
) async {
  final locale = Localizations.localeOf(context).languageCode;
  if (locale != 'en') {
    try {
      return await rootBundle.loadString('assets/${baseName}_$locale.html');
    } catch (_) {
      // Fall back to default English document
    }
  }
  return await rootBundle.loadString('assets/$baseName.html');
}

/// Manages and persists the user's manual in-app locale choice.
/// A `null` value indicates that the app automatically adopts the device/browser locale.
class LocaleController {
  static const String _keyLocale = 'app_locale';
  static const Locale autoLocale = Locale('auto');
  static final ValueNotifier<Locale?> currentLocale = ValueNotifier<Locale?>(
    null,
  );

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('de'),
    Locale('fr'),
    Locale('ja'),
    Locale('lt'),
    Locale('pt'),
    Locale('zh'),
  ];

  static String languageDisplayName(Locale? locale) {
    if (locale == null) return 'System Default';
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'ja':
        return '日本語';
      case 'lt':
        return 'Lietuvių';
      case 'pt':
        return 'Português';
      case 'zh':
        return '中文 (简体)';
      default:
        return locale.toLanguageTag();
    }
  }

  static Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_keyLocale);
      if (code != null && code.isNotEmpty) {
        currentLocale.value = Locale(code);
      }
    } catch (_) {}
  }

  static Future<void> setLocale(Locale? locale) async {
    final effective =
        (locale == null ||
            locale == autoLocale ||
            locale.languageCode == 'auto')
        ? null
        : locale;
    currentLocale.value = effective;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (effective == null) {
        await prefs.remove(_keyLocale);
      } else {
        await prefs.setString(_keyLocale, effective.languageCode);
      }
    } catch (_) {}
  }
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

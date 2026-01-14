import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, dynamic> _localizedMap;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    )!;
  }

  Future<void> load() async {
    final jsonString = await rootBundle.loadString(
      'assets/i18n/${locale.languageCode}-${locale.countryCode}.json',
    );

    _localizedMap = json.decode(jsonString);
  }

  /// Uso: tr('home.welcome', params: {'userName': 'Derek'})
  String tr(
    String key, {
    Map<String, String>? params,
  }) {
    final keys = key.split('.');
    dynamic value = _localizedMap;

    for (final k in keys) {
      if (value is Map && value.containsKey(k)) {
        value = value[k];
      } else {
        return key; // fallback
      }
    }

    if (value is! String) return '[$key]';

    var text = value;

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        text = text.replaceAll('{$paramKey}', paramValue);
      });
    }

    return text;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  static const _supportedLanguageCodes = [
    'pt',
    'en',
    'es',
    'fr',
    'it',
    'de',
    'ja',
  ];

  @override
  bool isSupported(Locale locale) {
    return _supportedLanguageCodes.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_) => false;
}
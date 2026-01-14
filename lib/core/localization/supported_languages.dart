import 'package:bagaer/feature/language/domain/entities/app_language.dart';
import 'package:flutter/material.dart';

const supportedLanguages = [
  AppLanguage(
    locale: Locale('pt', 'BR'),
    label: 'Português - BR',
    flag: '🇧🇷',
  ),
  AppLanguage(
    locale: Locale('en', 'US'),
    label: 'English - US',
    flag: '🇺🇸',
  ),
  AppLanguage(
    locale: Locale('es', 'ES'),
    label: 'Español - ES',
    flag: '🇪🇸',
  ),
  AppLanguage(
    locale: Locale('fr', 'FR'),
    label: 'Français - FR',
    flag: '🇫🇷',
  ),
  AppLanguage(
    locale: Locale('it', 'IT'),
    label: 'Italiano - IT',
    flag: '🇮🇹',
  ),
  AppLanguage(
    locale: Locale('de', 'DE'),
    label: 'Deutsch - DE',
    flag: '🇩🇪',
  ),
  AppLanguage(
    locale: Locale('ja', 'JP'),
    label: '日本語 - JP',
    flag: '🇯🇵',
  ),
];
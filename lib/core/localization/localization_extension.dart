import 'package:flutter/widgets.dart';
import 'app_localization.dart';

extension LocalizationExtension on BuildContext {
  String tr(
    String key, {
    Map<String, String>? params,
  }) {
    return AppLocalizations.of(this).tr(key, params: params);
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_event.dart';
part 'language_state.dart';


class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  static const _storageKey = 'app_language';

  LanguageBloc() : super(const LanguageInitial()) {
    on<LoadSavedLanguage>(_onLoadSavedLanguage);
    on<LanguageChanged>(_onLanguageChanged);
  }

  Future<void> _onLoadSavedLanguage(LoadSavedLanguage event, Emitter<LanguageState> emit,) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_storageKey);

    if (saved != null) {
      final parts = saved.split('-');

      if (parts.length == 2) {
        emit(LanguageLoaded(Locale(parts[0], parts[1])));
        return;
      }
    }

    // fallback seguro
    emit(const LanguageLoaded(Locale('pt', 'BR')));
  }

  Future<void> _onLanguageChanged(LanguageChanged event, Emitter<LanguageState> emit,) async {
    emit(LanguageLoaded(event.locale));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, '${event.locale.languageCode}_${event.locale.countryCode}',);
  }
}

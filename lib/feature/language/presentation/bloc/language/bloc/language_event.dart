part of 'language_bloc.dart';

sealed class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object> get props => [];
}


/// Disparado no startup do app
class LoadSavedLanguage extends LanguageEvent {
  const LoadSavedLanguage();
}

/// Disparado ao trocar manualmente o idioma
class LanguageChanged extends LanguageEvent {
  final Locale locale;

  const LanguageChanged(this.locale);

  @override
  List<Object> get props => [locale];
}
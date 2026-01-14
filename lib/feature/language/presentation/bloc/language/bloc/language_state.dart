part of 'language_bloc.dart';

sealed class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState(this.locale);

  @override
  List<Object> get props => [locale];
}

/// Estado inicial (antes de carregar do storage)
class LanguageInitial extends LanguageState {
  const LanguageInitial() : super(const Locale('pt', 'BR'));
}

/// Estado após carregamento/troca
class LanguageLoaded extends LanguageState {
  const LanguageLoaded(Locale locale) : super(locale);
}
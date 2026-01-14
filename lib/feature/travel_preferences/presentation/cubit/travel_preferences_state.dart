import 'package:bagaer/feature/travel_preferences/domain/entities/travel_preferences_entity.dart';

sealed class TravelPreferencesState {}

class TravelPreferencesInitial extends TravelPreferencesState {}

class TravelPreferencesLoading extends TravelPreferencesState {}

class TravelPreferencesLoaded extends TravelPreferencesState {
  final List<TravelPreference> preferences;

  TravelPreferencesLoaded(this.preferences);
}

class TravelPreferencesError extends TravelPreferencesState {
  final String message;

  TravelPreferencesError(this.message);
}
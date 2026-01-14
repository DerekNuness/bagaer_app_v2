
import 'package:bagaer/feature/meal_preference/domain/entities/meal_preferences_entity.dart';

sealed class MealPreferencesState {}

class MealPreferencesInitial extends MealPreferencesState {}

class MealPreferencesLoading extends MealPreferencesState {}

class MealPreferencesLoaded extends MealPreferencesState {
  final List<MealPreference> preferences;

  MealPreferencesLoaded(this.preferences);
}

class MealPreferencesError extends MealPreferencesState {
  final String message;

  MealPreferencesError(this.message);
}
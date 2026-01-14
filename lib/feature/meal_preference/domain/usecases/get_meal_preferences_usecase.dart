import 'package:bagaer/feature/meal_preference/domain/entities/meal_preferences_entity.dart';
import 'package:bagaer/feature/meal_preference/domain/repositories/meal_preferences_repository.dart';

class GetMealPreferences {
  final MealPreferencesRepository repository;

  GetMealPreferences(this.repository);

  Future<List<MealPreference>> call() {
    return repository.getMealPreferences();
  }
}
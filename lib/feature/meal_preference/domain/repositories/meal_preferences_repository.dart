
import 'package:bagaer/feature/meal_preference/domain/entities/meal_preferences_entity.dart';

abstract class MealPreferencesRepository {
  Future<List<MealPreference>> getMealPreferences();
}
import 'package:bagaer/feature/meal_preference/data/model/meal_preferences_model.dart';

abstract class MealPreferencesRemoteDatasource {
  Future<List<MealPreferencesModel>> getMealPreferences();
}

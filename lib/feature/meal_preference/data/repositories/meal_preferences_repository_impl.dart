
import 'package:bagaer/feature/meal_preference/data/datasources/meal_preferences_remote_datasource.dart';
import 'package:bagaer/feature/meal_preference/domain/entities/meal_preferences_entity.dart';
import 'package:bagaer/feature/meal_preference/domain/repositories/meal_preferences_repository.dart';

class MealPreferencesRepositoryImpl implements MealPreferencesRepository {
  final MealPreferencesRemoteDatasource remoteDatasource;

  MealPreferencesRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<MealPreference>> getMealPreferences() {
    return remoteDatasource.getMealPreferences();
  }
}

import 'package:bagaer/feature/travel_preferences/domain/entities/travel_preferences_entity.dart';

abstract class TravelPreferencesRepository {
  Future<List<TravelPreference>> getTravelPreferences();
}
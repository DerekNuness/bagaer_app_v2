import 'package:bagaer/feature/travel_preferences/domain/entities/travel_preferences_entity.dart';
import 'package:bagaer/feature/travel_preferences/domain/repositories/travel_preferences_repository.dart';

class GetTravelPreferences {
  final TravelPreferencesRepository repository;

  GetTravelPreferences(this.repository);

  Future<List<TravelPreference>> call() {
    return repository.getTravelPreferences();
  }
}
import 'package:bagaer/feature/travel_preferences/data/model/travel_preferences_model.dart';

abstract class TravelPreferencesRemoteDatasource {
  Future<List<TravelPreferenceModel>> getTravelPreferences();
}

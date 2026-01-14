import 'package:bagaer/feature/travel_preferences/data/datasources/travel_preferences_remote_datasource.dart';
import 'package:bagaer/feature/travel_preferences/domain/entities/travel_preferences_entity.dart';
import 'package:bagaer/feature/travel_preferences/domain/repositories/travel_preferences_repository.dart';

class TravelPreferencesRepositoryImpl implements TravelPreferencesRepository {
  final TravelPreferencesRemoteDatasource remoteDatasource;

  TravelPreferencesRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<TravelPreference>> getTravelPreferences() {
    return remoteDatasource.getTravelPreferences();
  }
}
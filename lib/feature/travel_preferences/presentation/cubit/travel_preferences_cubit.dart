import 'package:bagaer/core/errors/register/register_failures.dart';
import 'package:bagaer/feature/travel_preferences/domain/usecases/get_travel_preferences_usecase.dart';
import 'package:bagaer/feature/travel_preferences/presentation/cubit/travel_preferences_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TravelPreferencesCubit extends Cubit<TravelPreferencesState> {
  final GetTravelPreferences getTravelPreferences;
  bool _isLoading = false;

  TravelPreferencesCubit(this.getTravelPreferences): super(TravelPreferencesInitial());

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    emit(TravelPreferencesLoading());
    try {
      final result = await getTravelPreferences();
      emit(TravelPreferencesLoaded(result));
      _isLoading = false;
    } on UserUnathenticated catch (f) {
      emit(TravelPreferencesError(f.message));
      _isLoading = false;
    } on RegisterNetworkFailure catch (f) {
      emit(TravelPreferencesError(f.message));
      _isLoading = false;
    } on RegisterUnknownAuthFailure catch (f) {
      emit(TravelPreferencesError(f.message));
      _isLoading = false;
    }
  }
}
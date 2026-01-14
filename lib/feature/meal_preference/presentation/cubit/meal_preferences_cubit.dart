
import 'package:bagaer/core/errors/register/register_failures.dart';
import 'package:bagaer/feature/meal_preference/domain/usecases/get_meal_preferences_usecase.dart';
import 'package:bagaer/feature/meal_preference/presentation/cubit/meal_preferences_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MealPreferencesCubit extends Cubit<MealPreferencesState> {
  final GetMealPreferences getMealPreferences;
  bool _isLoading = false;

  MealPreferencesCubit(this.getMealPreferences): super(MealPreferencesInitial());

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    emit(MealPreferencesLoading());
    print("Emitiu o loading");
    try {
      final result = await getMealPreferences();
      emit(MealPreferencesLoaded(result));
      print("Emitiu o loaded");
      _isLoading = false;
    } on UserUnathenticated catch (f) {
      emit(MealPreferencesError(f.message));
      print("Emitiu o erro 1");
      _isLoading = false;
    } on RegisterNetworkFailure catch (f) {
      emit(MealPreferencesError(f.message));
      print("Emitiu o erro 2");
      _isLoading = false;
    } on RegisterUnknownAuthFailure catch (f) {
      emit(MealPreferencesError(f.message));
      print("Emitiu o erro 3");
      _isLoading = false;
    }
  }
}
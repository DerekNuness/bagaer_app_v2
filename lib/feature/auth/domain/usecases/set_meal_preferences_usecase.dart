import '../repositories/auth_repository.dart';

class SetMealPreferencesUseCase {
  final AuthRepository repository;
  SetMealPreferencesUseCase(this.repository);

  Future<void> call({
    required String token,
    required List<int> mealPreferences,
  }) {
    return repository.setMealPreferences(
      token: token,
      mealPreferences: mealPreferences,
    );
  }
}
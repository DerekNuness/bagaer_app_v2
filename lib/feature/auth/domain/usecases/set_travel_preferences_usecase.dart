import '../repositories/auth_repository.dart';

class SetTravelPreferencesUseCase {
  final AuthRepository repository;
  SetTravelPreferencesUseCase(this.repository);

  Future<void> call({
    required String token,
    required List<int> travelPreferences,
  }) {
    return repository.setTravelPreferences(
      token: token,
      travelPreferences: travelPreferences,
    );
  }
}
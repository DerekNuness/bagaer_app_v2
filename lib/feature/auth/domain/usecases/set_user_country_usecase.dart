import '../repositories/auth_repository.dart';

class SetUserCountryUseCase {
  final AuthRepository repository;
  SetUserCountryUseCase(this.repository);

  Future<void> call({
    required String token,
    required int countryId,
  }) {
    return repository.setUserCountry(token: token, countryId: countryId);
  }
}
import '../repositories/auth_repository.dart';

class GetCachedTokenUseCase {
  final AuthRepository repository;

  GetCachedTokenUseCase(this.repository);

  Future<String?> call() {
    return repository.getCachedToken();
  }
}
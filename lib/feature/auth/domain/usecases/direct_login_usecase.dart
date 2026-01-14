import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class DirectLoginUseCase {
  final AuthRepository repository;
  DirectLoginUseCase(this.repository);

  Future<AuthSession> call({
    required String token,
    required String appVersion,
    required String deviceOs,
  }) {
    return repository.directLogin(
      token: token,
      appVersion: appVersion,
      deviceOs: deviceOs,
    );
  }
}
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<AuthSession> call({
    required String phoneNumber,
    required String password,
    required String appVersion,
    required String deviceOs,
  }) {
    return repository.login(
      phoneNumber: phoneNumber,
      password: password,
      appVersion: appVersion,
      deviceOs: deviceOs,
    );
  }
}
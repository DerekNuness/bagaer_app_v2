import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class RegisterCreateUserUseCase {
  final AuthRepository repository;
  RegisterCreateUserUseCase(this.repository);

  Future<AuthSession> call({
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
    required bool newsletter,
    required bool notifications,
  }) {
    return repository.createUser(
      phoneNumber: phoneNumber,
      password: password,
      passwordConfirmation: passwordConfirmation,
      newsletter: newsletter,
      notifications: notifications,
    );
  }
}
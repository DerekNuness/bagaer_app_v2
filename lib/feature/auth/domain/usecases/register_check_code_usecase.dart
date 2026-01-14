import '../repositories/auth_repository.dart';

class RegisterCheckCodeUseCase {
  final AuthRepository repository;
  RegisterCheckCodeUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required String code,
  }) {
    return repository.checkRegisterCode(
      phoneNumber: phoneNumber,
      code: code,
    );
  }
}
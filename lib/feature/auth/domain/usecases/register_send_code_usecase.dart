import '../repositories/auth_repository.dart';

class RegisterSendCodeUseCase {
  final AuthRepository repository;
  RegisterSendCodeUseCase(this.repository);

  Future<void> call({
    required String phoneNumber,
    required String autoCompleteCode,
  }) {
    return repository.sendRegisterCode(
      phoneNumber: phoneNumber,
      autoCompleteCode: autoCompleteCode,
    );
  }
}
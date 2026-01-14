import 'package:bagaer/feature/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUsecase {
  final AuthRepository repository;

  DeleteAccountUsecase(this.repository);

  Future<bool> call({
    required String token,
    required String password,
  }) {
    return repository.deleteAccount(
      token: token, 
      password: password
    );
  }
}
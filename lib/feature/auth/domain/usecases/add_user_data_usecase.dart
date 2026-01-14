import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class AddUserDataUseCase {
  final AuthRepository repository;
  AddUserDataUseCase(this.repository);

  Future<AuthSession> call({
    required String token,
    required String name,
    required String surname,
    required String email,
    required String docIdent,
    required String docIdentType,
    required bool newsletter,
    required String appVersion,
    required String deviceOs,
  }) {
    return repository.addUserData(
      token: token,
      name: name,
      surname: surname,
      email: email,
      docIdent: docIdent,
      docIdentType: docIdentType,
      newsletter: newsletter,
      appVersion: appVersion,
      deviceOs: deviceOs,
    );
  }
}
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class UploadProfilePictureUseCase {
  final AuthRepository repository;
  UploadProfilePictureUseCase(this.repository);

  Future<AuthSession> call({
    required String token,
    required String filePath,
  }) {
    return repository.uploadProfilePicture(token: token, filePath: filePath);
  }
}
import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase {
  final AuthRepository repository;
  CheckAuthUseCase(this.repository);

  Future<AuthSession?> call() => repository.checkAuth();
}
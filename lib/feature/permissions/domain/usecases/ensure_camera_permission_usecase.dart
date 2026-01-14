import '../entities/permission_status.dart';
import '../repositories/permission_repository.dart';

class EnsureCameraPermissionUseCase {
  final PermissionRepository repository;

  EnsureCameraPermissionUseCase(this.repository);

  Future<PermissionStatus> call() {
    return repository.ensureCamera();
  }
}
import '../entities/permission_status.dart';
import '../repositories/permission_repository.dart';

class EnsureMicrophonePermissionUseCase {
  final PermissionRepository repository;

  EnsureMicrophonePermissionUseCase(this.repository);

  Future<PermissionStatus> call() {
    return repository.ensureMicrophone();
  }
}
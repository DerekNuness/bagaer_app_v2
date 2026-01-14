import '../entities/permission_status.dart';

abstract class PermissionRepository {
  Future<PermissionStatus> ensureCamera();
  Future<PermissionStatus> ensureMicrophone();
}
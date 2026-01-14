import '../../domain/entities/permission_status.dart';

abstract class PermissionDataSource {
  Future<PermissionStatus> ensureCamera();
  Future<PermissionStatus> ensureMicrophone();
}
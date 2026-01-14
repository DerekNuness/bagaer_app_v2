import '../../domain/entities/permission_status.dart';
import '../../domain/repositories/permission_repository.dart';
import '../datasources/permission_datasource.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionDataSource dataSource;

  PermissionRepositoryImpl(this.dataSource);

  @override
  Future<PermissionStatus> ensureCamera() => dataSource.ensureCamera();

  @override
  Future<PermissionStatus> ensureMicrophone() => dataSource.ensureMicrophone();
}
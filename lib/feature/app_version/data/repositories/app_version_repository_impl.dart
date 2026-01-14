import 'package:bagaer/feature/app_version/data/datasources/app_version_datasource.dart';
import 'package:bagaer/feature/app_version/domain/entities/app_version_info.dart';
import 'package:bagaer/feature/app_version/domain/repositories/app_version_repository.dart';

class AppVersionRepositoryImpl implements AppVersionRepository {
  final AppVersionRemoteDatasource remoteDatasource;

  AppVersionRepositoryImpl(this.remoteDatasource);

  @override
  Future<AppVersionInfo> getAppVersion() {
    return remoteDatasource.getAppVersion();
  }
}
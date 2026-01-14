import 'package:bagaer/feature/app_version/domain/entities/app_version_info.dart';
import 'package:bagaer/feature/app_version/domain/repositories/app_version_repository.dart';

class GetAppVersionInfo {
  final AppVersionRepository repository;

  GetAppVersionInfo(this.repository);

  Future<AppVersionInfo> call() {
    return repository.getAppVersion();
  }
}
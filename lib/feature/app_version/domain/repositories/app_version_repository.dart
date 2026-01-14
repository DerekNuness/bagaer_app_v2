import 'package:bagaer/feature/app_version/domain/entities/app_version_info.dart';

abstract class AppVersionRepository {
  Future<AppVersionInfo> getAppVersion();
}
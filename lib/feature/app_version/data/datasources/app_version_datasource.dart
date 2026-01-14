import 'package:bagaer/feature/app_version/data/models/app_version_model.dart';

abstract class AppVersionRemoteDatasource {
  Future<AppVersionInfoModel> getAppVersion();
}
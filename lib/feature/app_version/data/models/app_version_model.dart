import 'package:bagaer/feature/app_version/domain/entities/app_version_info.dart';

class AppVersionInfoModel extends AppVersionInfo {
  AppVersionInfoModel({
    required super.version,
    required super.mandatoryUpdate,
    required super.url,
    required super.releaseNotes,
  });

  factory AppVersionInfoModel.fromJson(Map<String, dynamic> json) {
    return AppVersionInfoModel(
      version: json['version'],
      mandatoryUpdate: json['mandatory_update'],
      url: json['url'],
      releaseNotes: json['release_notes'],
    );
  }
}
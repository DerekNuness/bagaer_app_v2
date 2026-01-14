import 'dart:io';

import 'package:bagaer/core/network/api_client.dart';
import 'package:bagaer/core/network/api_endpoints.dart';
import 'package:bagaer/feature/app_version/data/datasources/app_version_datasource.dart';
import 'package:bagaer/feature/app_version/data/models/app_version_model.dart';
import 'package:dio/dio.dart';

class AppVersionRemoteDatasourceImpl implements AppVersionRemoteDatasource {

  final ApiClient client;

  AppVersionRemoteDatasourceImpl(this.client);

  @override
  Future<AppVersionInfoModel> getAppVersion() async {
    final platform = Platform.operatingSystem;

    final url = (platform == "android") ? ApiEndpoints.androidAppVersion : ApiEndpoints.iosAppVersion;

    final response = await client.dio.get(
      url, // path relativo
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    return AppVersionInfoModel.fromJson(response.data['app_version']);
  }
}
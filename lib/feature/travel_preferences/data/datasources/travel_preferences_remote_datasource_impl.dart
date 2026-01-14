import 'package:bagaer/core/errors/register/register_failures.dart';
import 'package:bagaer/core/network/api_client.dart';
import 'package:bagaer/core/network/api_endpoints.dart';
import 'package:bagaer/feature/travel_preferences/data/datasources/travel_preferences_remote_datasource.dart';
import 'package:bagaer/feature/travel_preferences/data/model/travel_preferences_model.dart';
import 'package:dio/dio.dart';

class TravelPreferencesRemoteDatasourceImpl implements TravelPreferencesRemoteDatasource {
  final ApiClient client;

  TravelPreferencesRemoteDatasourceImpl(this.client);

  @override
  Future<List<TravelPreferenceModel>> getTravelPreferences() async {
    try {
      final response = await client.dio.get(
        ApiEndpoints.getTravelPreferences,
      );
      
      /// ⚠️ A API retorna uma lista dentro de outra lista
      final List list = response.data.first;
      
      return list.map((e) => TravelPreferenceModel.fromJson(e)).toList();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 401 && message == "Unauthorized - missing api key") {
        throw const UserUnathenticated();
      }

      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const RegisterNetworkFailure();
      }

      throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
    }
  }
}
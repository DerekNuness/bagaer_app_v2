import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiClient {
  final Dio dio;
  final String apiKey;

  // ApiClient({required this.dio, required this.apiKey}) {
  //   dio.options.headers['x-api-key'] = apiKey;
  //   dio.options.headers['Content-Type'] = 'application/json';
  // }
  ApiClient({required this.dio, required this.apiKey}) {
    dio.options.headers['x-api-key'] = apiKey;
    dio.options.headers['Content-Type'] = 'application/json';

    /// 🔍 DEBUG INTERCEPTOR
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('➡️ ${options.method} ${options.uri}');
          debugPrint('Headers: ${options.headers}');
          debugPrint('Data: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ ${response.statusCode} ${response.requestOptions.uri}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('❌ ERROR ${error.response?.statusCode}');
          debugPrint('❌ ${error.requestOptions.uri}');
          debugPrint('❌ Response: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );
  }
  
  /// Para endpoints que EXIGEM autenticação
  Options authOptions(String token) {
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  /// Para endpoints públicos (default)
  Options publicOptions() {
    return Options();
  }
}
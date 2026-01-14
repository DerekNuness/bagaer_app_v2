import 'package:bagaer/core/errors/login/login_failures.dart';
import 'package:bagaer/core/errors/register/register_failures.dart';
import 'package:bagaer/core/utils/img_upload/multpart_upload_util.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_session_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient client;

  AuthRemoteDatasourceImpl(this.client);

  @override
  Future<AuthSessionModel> login({
    required String phoneNumber,
    required String password,
    required String appVersion,
    required String deviceOs,
  }) async {
    try {
      final res = await client.dio.post(
        ApiEndpoints.login,
        data: {
          'phone_number': phoneNumber,
          'password': password,
          'app_version': appVersion,
          'device_os': deviceOs,
        },
      );
      
      return AuthSessionModel.fromJson(res.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 401 && message == 'Invalid credentials') {
        throw const LoginInvalidCredentialsFailure();
      }

      if (status == 403) {
        throw const UserBlockedFailure();
      }

      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const LoginNetworkFailure();
      }

      throw LoginUnknownFailure(message ?? 'Erro inesperado');
    }
  }

  @override
  Future<bool> deleteAccount({
    required String token, 
    required String password
  }) async {
    try {

      final res = await client.dio.post(
        ApiEndpoints.deleteAccount,
        data: {
          'password': password,
        },
        options: client.authOptions(token),
      );

      return true;
    } on Exception catch (e) {
      return false;
    }
  }

  @override
  Future<AuthSessionModel> directLogin({required String token, required String appVersion, required String deviceOs}) async {
    final res = await client.dio.get('${ApiEndpoints.directLogin}?app_version=$appVersion&device_os=$deviceOs',
      options: client.authOptions(token),
    );
    try {
      final model = AuthSessionModel.fromJson(res.data, token: token);
      return model;
    } catch (e, stack) {
      rethrow;
    }
  }

  @override
  Future<void> sendRegisterCode({required String phoneNumber, required String autoCompleteCode}) async {
    try {
      await client.dio.post(
        ApiEndpoints.sendRegisterCode,
        data: {
          'phone_number': phoneNumber,
          'auto_complete_code': autoCompleteCode,
        },
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 400 && message == "user already registered") {
        throw const UserAlreadyRegistered();
      }

      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const RegisterNetworkFailure();
      }

      throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
    }
    
  }

  @override
  Future<void> checkRegisterCode({required String phoneNumber, required String code}) async {
    try {
      final res = await client.dio.post(
        ApiEndpoints.checkRegisterCode,
        data: {
          'code': code,
          'phone_number': phoneNumber,
        },
      );

      if (res.data['message'] != "success") throw RegisterUnknownAuthFailure();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 403 && message == "invalid code") {
        throw const InvalidRegisterCode();
      }

      if (status == 403 && message == "your code has expired") {
        throw const CodeExpired();
      }

      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const RegisterNetworkFailure();
      }

      throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
    }
  }

  @override
  Future<AuthSessionModel> createUser({
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
    required bool newsletter,
    required bool notifications,
  }) async {
    try {
      final res = await client.dio.post(
        ApiEndpoints.createUser,
        data: {
          'phone_number': phoneNumber,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'newsletter': newsletter,
          'notifications': notifications,
        },
      );
      
      return AuthSessionModel.fromJson(res.data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 422 && message == "The password field must be at least 6 characters.") {
        throw const PasswordFailure();
      }

      if (status == 422 && message == "The password field confirmation does not match.") {
        throw const PasswordDoesntMatch();
      }

      if (status == 401 && message == "the code sent to the phone was not checked") {
        throw const PhoneNotVerified();
      }

      if (status == 401 && message == "user register session expired") {
        throw const SessionExpired();
      }

      throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
    }
  }

  @override
  Future<void> setUserCountry({required String token, required int countryId}) async {
    try {
      await client.dio.post(
        ApiEndpoints.setUserCountry,
        data: {'country_id': countryId},
        options: client.authOptions(token),
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 401 && message == "Unauthenticated.") {
        throw const UserUnathenticated();
      }

      throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
    }
  }

  @override
  Future<AuthSessionModel> addUserData({
    required String token,
    required String name,
    required String surname,
    required String email,
    required String docIdent,
    required String docIdentType,
    required bool newsletter,
    required String appVersion,
    required String deviceOs,
  }) async {
    try {
      final res = await client.dio.post(
        ApiEndpoints.addUserData,
        data: {
          'name': name.trim(),
          'surname': surname.trim(),
          'email': email.trim(),
          'doc_ident': docIdent.trim(),
          'doc_ident_type': docIdentType,
          'newsletter': newsletter,
          'app_version': appVersion,
          'device_os': deviceOs,
        },
        options: client.authOptions(token),
      );
      
      return AuthSessionModel.fromJson(res.data, token: token);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 422) {
        if (message == "The email has already been taken.") {
          throw const EmailAlreadyInUse();
        }
        if (message == "The doc ident has already been taken.") {
          throw const DocumentAlreadyInUse();
        }
        if (message == "The name field is required.") {
          throw const NameRequired();
        }
        if (message == "The surname field is required.") {
          throw const SurnameRequired();
        }
        if (message == "The email field is required.") {
          throw const EmailRequired();
        }
        if (message == "The doc ident field is required.") {
          throw const DocIdentRequired();
        }
        if (message == "The doc ident type field must be a string.") {
          throw const DocTypeRequired();
        }
      }

      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const RegisterNetworkFailure();
      }

      throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
    }
  }

  @override
  Future<void> setTravelPreferences({required String token, required List<int> travelPreferences}) async {
    try {
      await client.dio.post(
        ApiEndpoints.setTravelPreferences,
        data: {'travel_preferences': travelPreferences},
        options: client.authOptions(token),
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 401 && message == "Unauthenticated.") {
        throw const UserUnathenticated();
      }

      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const RegisterNetworkFailure();
      }

      throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
    }
  }

  @override
  Future<void> setMealPreferences({required String token, required List<int> mealPreferences}) async {
    try {
      await client.dio.post(
        ApiEndpoints.setMealPreferences,
        data: {'meal_preferences': mealPreferences},
        options: client.authOptions(token),
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 401 && message == "Unauthenticated.") {
        throw const UserUnathenticated();
      }

      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const RegisterNetworkFailure();
      }

      throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
    }
  }

  // @override
  // Future<AuthSessionModel> uploadProfilePicture({required String token, required String filePath}) async {
  //   try {
  //     final formData = FormData.fromMap({
  //       'profile_picture': await MultipartFile.fromFile(
  //         filePath,
  //         contentType: MediaType('image', 'jpeg'),
  //       ),
  //     });
      
  //     final res = await client.dio.post(
  //       ApiEndpoints.setProfilePicture,
  //       data: formData,
  //       options: client.authOptions(token).copyWith(
  //         headers: {
  //           ...?client.authOptions(token).headers,
  //           'Content-Type': 'multipart/form-data',
  //         },
  //       ),
  //     );
      
  //     return AuthSessionModel.fromJson(res.data, token: token);
  //   } on DioException catch (e) {
  //     final status = e.response?.statusCode;
  //     final message = e.response?.data?['message'];

  //     if (status == 401 && message == "Unauthenticated.") {
  //       throw const UserUnathenticated();
  //     }

  //     if (status == 422 && message == "The profile picture field has invalid image dimensions.") {
  //       throw const WrongDimensions();
  //     }

  //     if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
  //       throw const RegisterNetworkFailure();
  //     }

  //     throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
  //   }
  // }
  @override
  Future<AuthSessionModel> uploadProfilePicture({
    required String token,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'profile_picture': await multipartFromAnyPath(filePath),
      });

      final res = await client.dio.post(
        ApiEndpoints.setProfilePicture,
        data: formData,
        options: client.authOptions(token).copyWith(
          headers: {
            ...?client.authOptions(token).headers,
            // ✅ deixe o Dio setar boundary automaticamente
            // 'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return AuthSessionModel.fromJson(res.data, token: token);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final message = e.response?.data?['message'];

      if (status == 401 && message == "Unauthenticated.") {
        throw const UserUnathenticated();
      }

      if (status == 422 &&
          message == "The profile picture field has invalid image dimensions.") {
        throw const WrongDimensions();
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const RegisterNetworkFailure();
      }

      throw RegisterUnknownAuthFailure(message ?? 'Erro inesperado');
    }
  }
}
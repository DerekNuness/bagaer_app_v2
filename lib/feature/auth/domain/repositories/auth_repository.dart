
import 'package:bagaer/feature/auth/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession?> checkAuth(); // token cache -> direct login se existir

  Future<String?> getCachedToken();
  
  Future<AuthSession> login({
    required String phoneNumber,
    required String password,
    required String appVersion,
    required String deviceOs,
  });

  Future<AuthSession> directLogin({
    required String token,
    required String appVersion,
    required String deviceOs,
  });

  Future<bool> deleteAccount({
    required String token,
    required String password,
  });

  Future<void> logout();

  // Cadastro (etapas)
  Future<void> sendRegisterCode({
    required String phoneNumber,
    required String autoCompleteCode,
  });

  Future<void> checkRegisterCode({
    required String phoneNumber,
    required String code,
  });

  Future<AuthSession> createUser({
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
    required bool newsletter,
    required bool notifications,
  });

  Future<void> setUserCountry({
    required String token,
    required int countryId,
  });

  Future<AuthSession> addUserData({
    required String token,
    required String name,
    required String surname,
    required String email,
    required String docIdent,
    required String docIdentType,
    required bool newsletter,
    required String appVersion,
    required String deviceOs,
  });

  Future<void> setTravelPreferences({
    required String token,
    required List<int> travelPreferences,
  });

  Future<void> setMealPreferences({
    required String token,
    required List<int> mealPreferences,
  });

  Future<AuthSession> uploadProfilePicture({
    required String token,
    required String filePath,
  });
}
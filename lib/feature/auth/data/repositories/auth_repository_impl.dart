import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource local;

  AuthRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<AuthSession?> checkAuth() async {
    final token = await local.getToken();
    if (token == null || token.trim().isEmpty) return null;

    // appVersion/deviceOs são responsabilidade do EntryPoint/UI passar
    // então esse método deve ser usado via UseCase de directLogin se você preferir.
    // Aqui vamos só retornar null e deixar o bloc chamar directLogin com params.
    return null;
  }

  @override
  Future<String?> getCachedToken() {
    return local.getToken();
  }

  @override
  Future<AuthSession> login({
    required String phoneNumber,
    required String password,
    required String appVersion,
    required String deviceOs,
  }) async {
    final session = await remote.login(
      phoneNumber: phoneNumber,
      password: password,
      appVersion: appVersion,
      deviceOs: deviceOs,
    );

    await local.saveToken(session.accessToken);

    return session;
  }

  @override
  Future<bool> deleteAccount({
    required String token,
    required String password,
  }) async {
    try {
      final deleted = remote.deleteAccount(
        token: token, 
        password: password
      );

      print("esse é o deleted: $deleted");
      
      await local.clearToken();

      return deleted;
    } on Exception catch (e) {
      return false;
    }
  }

  @override
  Future<AuthSession> directLogin({
    required String token,
    required String appVersion,
    required String deviceOs,
  }) async {
    final session = await remote.directLogin(
      token: token,
      appVersion: appVersion,
      deviceOs: deviceOs,
    );

    await local.saveToken(session.accessToken);

    return session;
  }

  @override
  Future<void> logout() async {
    await local.clearToken();
  }

  @override
  Future<void> sendRegisterCode({
    required String phoneNumber,
    required String autoCompleteCode,
  }) {
    return remote.sendRegisterCode(
      phoneNumber: phoneNumber,
      autoCompleteCode: autoCompleteCode,
    );
  }

  @override
  Future<void> checkRegisterCode({
    required String phoneNumber,
    required String code,
  }) {
    return remote.checkRegisterCode(phoneNumber: phoneNumber, code: code);
  }

  @override
  Future<AuthSession> createUser({
    required String phoneNumber,
    required String password,
    required String passwordConfirmation,
    required bool newsletter,
    required bool notifications,
  }) async {
    final session = await remote.createUser(
      phoneNumber: phoneNumber,
      password: password,
      passwordConfirmation: passwordConfirmation,
      newsletter: newsletter,
      notifications: notifications,
    );

    return session;
  }

  @override
  Future<void> setUserCountry({
    required String token,
    required int countryId,
  }) {
    return remote.setUserCountry(token: token, countryId: countryId);
  }

  @override
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
  }) async {
    final session = await remote.addUserData(
      token: token,
      name: name,
      surname: surname,
      email: email,
      docIdent: docIdent,
      docIdentType: docIdentType,
      newsletter: newsletter,
      appVersion: appVersion,
      deviceOs: deviceOs,
    );

    // backend pode retornar user atualizado; mantemos token salvo
    await local.saveToken(session.accessToken);

    return session;
  }

  @override
  Future<void> setTravelPreferences({
    required String token,
    required List<int> travelPreferences,
  }) {
    return remote.setTravelPreferences(
      token: token,
      travelPreferences: travelPreferences,
    );
  }

  @override
  Future<void> setMealPreferences({
    required String token,
    required List<int> mealPreferences,
  }) {
    return remote.setMealPreferences(
      token: token,
      mealPreferences: mealPreferences,
    );
  }

  @override
  Future<AuthSession> uploadProfilePicture({
    required String token,
    required String filePath,
  }) async {
    final session = await remote.uploadProfilePicture(
      token: token,
      filePath: filePath,
    );

    await local.saveToken(session.accessToken);

    return session;
  }
}
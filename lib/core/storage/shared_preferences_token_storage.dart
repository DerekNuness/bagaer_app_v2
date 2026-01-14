import 'package:shared_preferences/shared_preferences.dart';
import 'token_storage.dart';

class SharedPreferencesTokenStorage implements TokenStorage {
  static const _tokenKey = 'access_token';

  final SharedPreferences prefs;

  SharedPreferencesTokenStorage(this.prefs);

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> clear() async {
    await prefs.remove(_tokenKey);
  }
}
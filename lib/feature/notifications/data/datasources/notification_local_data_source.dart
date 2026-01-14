import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationLocalDataSource {
  Future<void> cacheDeviceToken(String token);
  Future<String?> getCachedDeviceToken();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final SharedPreferences _prefs;
  static const _tokenKey = 'fcm_device_token';

  NotificationLocalDataSourceImpl(this._prefs);

  @override
  Future<void> cacheDeviceToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getCachedDeviceToken() async {
    return _prefs.getString(_tokenKey);
  }
}

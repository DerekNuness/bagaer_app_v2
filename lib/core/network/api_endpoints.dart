class ApiEndpoints {
  static const baseUrl = 'https://api.bagaer.com';

  static const login = '/api/v1/user/login';
  static const directLogin = '/api/v1/user/direct-login';

  static const deleteAccount = '/api/v1/user/deactivate-user';

  static const sendRegisterCode = '/api/v1/comtele/send-user-register-code';
  static const checkRegisterCode = '/api/v1/comtele/check-user-register-code';
  static const createUser = '/api/v1/user/register/create-user';

  static const setUserCountry = '/api/v1/user/set-user-country';
  static const addUserData = '/api/v1/user/register/add-user-data';

  static const getTravelPreferences = '/api/v1/preferences/get-travel-preferences';
  static const setTravelPreferences = '/api/v1/user/preferences/set-user-travel-preferences';
  static const getMealPreferences = '/api/v1/preferences/get-meal-preferences';
  static const setMealPreferences = '/api/v1/user/preferences/set-user-meal-preferences';

  static const setProfilePicture = '/api/v1/user/config/set-profile-picture';

  // App version verification
  static String androidAppVersion = "/api/v1//app-version/android/app";
  static String iosAppVersion = "/api/v1//app-version/ios/app";
}
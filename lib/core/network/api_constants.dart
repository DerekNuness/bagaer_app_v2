class ApiConstants {
  static String apiKey = 'JDG9E823A3C9A544F531DEF3F1CC2GENG';

  // Login 
  static String loginWithGoogle = 'user/login/social/google';

  // Register
  static String registerWithGoogle = 'user/social/google/set-firebase-google-id';

  // Baggages api URLs
  static String getUserBaggages = 'user/baggage/get-user-baggage';

  // Tracker api URLs
  static String getDocumentTracker = "user/documents/bagaer-document/tracker/get-document-tracker-url";

  static String setDocumentTracker = "user/documents/bagaer-document/tracker/set-document-tracker-url";

  static String unsetDocumentTracker = "user/documents/bagaer-document/tracker/unset-document-tracker-url";

  // Dispatch baggage url
  static String dispatchBaggage = 'user/baggage/dispatch-baggage';

  // Get App Version
  static String androidAppVersion = "app-version/android/app";
  static String iosAppVersion = "app-version/ios/app";
}

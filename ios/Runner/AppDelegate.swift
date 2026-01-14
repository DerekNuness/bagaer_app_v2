import UIKit
import Flutter
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import FirebaseAuth

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FirebaseApp.configure()

    // Se você precisa criar a window manualmente, pode manter este bloco.
    // (Muitos projetos não precisam; o super já cria via Main.storyboard).
    let flutterViewController = FlutterViewController()
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = flutterViewController
    self.window?.makeKeyAndVisible()

    // Delegates (OK manter)
    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self

    // ⚠️ NÃO peça autorização aqui. Remover esta parte:
    // UNUserNotificationCenter.current().requestAuthorization(...)

    // Registrar para push NÃO mostra o popup — pode manter.
    application.registerForRemoteNotifications()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("✅ FCM Token recebido (AppDelegate): \(fcmToken ?? "nenhum")")
  }

  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }

  override func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    if Auth.auth().canHandleNotification(userInfo) {
      completionHandler(.noData)
      return
    }
    completionHandler(.newData)
  }

  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .badge, .sound])
  }
}
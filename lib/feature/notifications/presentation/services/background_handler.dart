
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma('vm:entry-point')
// Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
//   // 1. Garantir que o motor do Flutter esteja pronto para plugins
//   WidgetsFlutterBinding.ensureInitialized();

//   // 2. Se for notificação com título/corpo (Notification Message), o Android já exibiu.
//   // Abortamos para não duplicar.
//   if (message.notification != null) {
//     return;
//   }

//   print('[BackgroundHandler] Mensagem Data-Only recebida: ${message.data}');

//   try {
//     // 3. Inicializar Firebase (necessário para alguns recursos, boa prática)
//     await Firebase.initializeApp();

//     // 4. Configurar o plugin de notificação manualmente (sem depender de injeção de dependência)
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('ic_stat_notify'); // Garanta que esse ícone existe em drawable

//     // Configuração mínima para iOS (se necessário som em background)
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings();

//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//     );

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//     // 5. Configurar os detalhes da notificação (Canal + Som)
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'channel_custom_sound', // Tem que ser o mesmo ID usado no app principal
//       'Notificações Importantes',
//       channelDescription: 'Notificações de atualização de bagagem',
//       importance: Importance.max,
//       priority: Priority.high,
//       icon: 'ic_stat_notify',
//       sound: RawResourceAndroidNotificationSound('tim_tom'),
//       // Adicione estas flags para garantir que apareça sobre outros apps
//       fullScreenIntent: true, 
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidDetails,
//       iOS: DarwinNotificationDetails(sound: 'bagaer_notification_sound.mp3'),
//     );

//     // 6. Exibir a notificação
//     // Usamos DateTime para gerar um ID único e não substituir a anterior
//     final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
//     await flutterLocalNotificationsPlugin.show(
//       notificationId,
//       message.data['title'] ?? 'Nova Atualização', // Fallback se não vier título no data
//       message.data['body'] ?? 'Verifique o app para mais detalhes.', // Fallback
//       notificationDetails,
//       payload: message.data.toString(), // Passa os dados para o clique
//     );
    
//     print('[BackgroundHandler] Sucesso! Notificação exibida.');

//   } catch (e, s) {
//     print('[BackgroundHandler] ERRO FATAL: $e');
//     print('[BackgroundHandler] Stack: $s');
//   }
// }
@pragma('vm:entry-point')
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  // 1. Garantir que o motor do Flutter esteja pronto para plugins
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Se for notificação com título/corpo (Notification Message), o Android já exibiu.
  // Abortamos para não duplicar.
  if (message.notification != null) {
    return;
  }

  print('[BackgroundHandler] Mensagem Data-Only recebida: ${message.data}');

  try {
    // 3. Inicializar Firebase (necessário para alguns recursos, boa prática)
    await Firebase.initializeApp();

    // 4. Configurar o plugin de notificação manualmente (sem depender de injeção de dependência)
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_notify'); // Garanta que esse ícone existe em drawable

    // Configuração mínima para iOS (se necessário som em background)
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // 5. Configurar os detalhes da notificação (Canal + Som)
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel_id', // Tem que ser o mesmo ID usado no app principal
      'Notificações Importantes',
      channelDescription: 'Notificações de atualização de bagagem',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_stat_notify',
      sound: RawResourceAndroidNotificationSound('tim_tom'),
      // Adicione estas flags para garantir que apareça sobre outros apps
      fullScreenIntent: true, 
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(sound: 'bagaer_notification_sound.mp3'),
    );

    // 6. Exibir a notificação
    // Usamos DateTime para gerar um ID único e não substituir a anterior
    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      message.data['title'] ?? 'Nova Atualização', // Fallback se não vier título no data
      message.data['body'] ?? 'Verifique o app para mais detalhes.', // Fallback
      notificationDetails,
      payload: message.data.toString(), // Passa os dados para o clique
    );
    
    print('[BackgroundHandler] Sucesso! Notificação exibida.');

  } catch (e, s) {
    print('[BackgroundHandler] ERRO FATAL: $e');
    print('[BackgroundHandler] Stack: $s');
  }
}
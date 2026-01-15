import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  LocalNotificationService._(this._plugin);

  static Future<LocalNotificationService> create() async {
    final plugin = FlutterLocalNotificationsPlugin();

    const androidSettings = AndroidInitializationSettings(
      'ic_stat_notify',
    );
    const iosSettings = DarwinInitializationSettings();

    await plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
        // Handle tap on notification when app in foreground/background
        print("[LocalNotificationService] Abri o app pela notificação usando");
      },
    );

    return LocalNotificationService._(plugin);
  }

  // Adicione este método para criar o canal proativamente
  Future<void> createNotificationChannel() async {
    const androidDetails = AndroidNotificationChannel(
      'default_channel_id',
      'Canal padrão de notificações', // Nome visível ao usuário nas configs
      description: 'Usado para notificações importantes do app',
      importance: Importance.high,
    );
    
    // Isso força a criação do canal no Android system settings
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(androidDetails);
  }

  Future<void> showNotification({
    required String id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel_id',
      'Canal padrão de notificações',
      channelDescription: 'Usado para notificações importantes do app',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_stat_notify',
    );

    const iosDetails = DarwinNotificationDetails();

    await _plugin.show(
      id.hashCode,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: data?.toString(),
    );
  }
}

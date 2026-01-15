import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bagaer/feature/notifications/data/models/notification_model.dart';
import 'package:bagaer/feature/notifications/presentation/services/local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  try {
    print('[firebaseBackgroundHandler] start messageId=${message.messageId}');

    // Se existir message.notification, o Android já exibiu a notificação automaticamente.
    // Nós retornamos aqui para evitar duplicidade.
    if (message.notification != null) {
      print('[firebaseBackgroundHandler] Notificação exibida pelo sistema (Notification Message).');
      return; 
    }

    // O código abaixo só deve rodar se for uma "Data Message" (sem o campo 'notification')
    
    final model = NotificationModel.fromRemoteMessage({
      'messageId': message.messageId,
      'notification': null, // Já sabemos que é null aqui
      'data': message.data,
      'sentTime': message.sentTime?.toIso8601String(),
    });

    print("Essa é o data: ${model.data}");

    final local = await LocalNotificationService.create();

    print('[firebaseBackgroundHandler] showing local notification for DATA message');

    await local.showNotification(
      id: model.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: model.title ?? message.data['title'] ?? 'Nova notificação', // Fallback para dados
      body: model.body ?? message.data['body'] ?? '',
      data: model.data,
    );
  } catch (e, st) {
    // Minimal error logging
    print('[firebaseBackgroundHandler] ERROR: $e');
    print(st);
  }
}

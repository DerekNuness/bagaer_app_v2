import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bagaer/feature/notifications/data/models/notification_model.dart';
import 'package:bagaer/feature/notifications/presentation/services/local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  try {
    // Minimal log: entry and message identifier
    print('[firebaseBackgroundHandler] start messageId=${message.messageId}');

    // Converta a mensagem para o model de domínio
    final model = NotificationModel.fromRemoteMessage({
      'messageId': message.messageId,
      'notification': message.notification == null
          ? null
          : {
              'title': message.notification?.title,
              'body': message.notification?.body,
            },
      'data': message.data,
      'sentTime': message.sentTime?.toIso8601String(),
    });

    print("Essa é o data: ${model.data}");

    // Cria o plugin local de notificações diretamente — evita inicializar todo o DI em isolate
    final local = await LocalNotificationService.create();

    // Log antes de mostrar a notificação (útil para confirmar ação no isolate)
    print('[firebaseBackgroundHandler] showing notification id=${model.id ?? 'generated'}');

    await local.showNotification(
      id: model.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: model.title,
      body: model.body,
      data: model.data,
    );
  } catch (e, st) {
    // Minimal error logging
    print('[firebaseBackgroundHandler] ERROR: $e');
    print(st);
  }
}

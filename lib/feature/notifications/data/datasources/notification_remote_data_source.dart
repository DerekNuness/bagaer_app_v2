import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<void> initialize();

  Future<String?> getDeviceToken();

  Stream<NotificationModel> get onMessage;

  Future<void> setBackgroundHandler(Future<void> Function(RemoteMessage) handler);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseMessaging _messaging;

  NotificationRemoteDataSourceImpl(this._messaging);

  @override
  Future<void> initialize() async {
    print('[NotificationRemoteDataSource] initialize() called');
    await _messaging.requestPermission();
    // Optionally subscribe to topics or set settings here
  }

  @override
  Future<String?> getDeviceToken() async {
    print('[NotificationRemoteDataSource] getDeviceToken() called');
    final token = await _messaging.getToken();
    print('[NotificationRemoteDataSource] token=$token');
    return token;
  }

  @override
  Stream<NotificationModel> get onMessage {
    return FirebaseMessaging.onMessage.map((rm) {
      print('[NotificationRemoteDataSource] onMessage received: messageId=${rm.messageId}, data=${rm.data}');
      return NotificationModel.fromRemoteMessage(_remoteMessageToMap(rm));
    });
  }

  @override
  Future<void> setBackgroundHandler(Future<void> Function(RemoteMessage) handler) async {
    print('[NotificationRemoteDataSource] registering background handler');
    FirebaseMessaging.onBackgroundMessage(handler);
  }

  Map<String, dynamic> _remoteMessageToMap(RemoteMessage rm) {
    return {
      'messageId': rm.messageId,
      'notification': rm.notification == null
          ? null
          : {
              'title': rm.notification?.title,
              'body': rm.notification?.body,
            },
      'data': rm.data,
      'sentTime': rm.sentTime?.toIso8601String(),
    };
  }
}

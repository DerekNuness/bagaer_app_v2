import 'package:bagaer/feature/notifications/domain/entities/push_notification.dart';

class NotificationModel extends PushNotification {
  const NotificationModel({
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    DateTime? sentTime,
  }) : super(id: id, title: title, body: body, data: data, sentTime: sentTime);

  factory NotificationModel.fromRemoteMessage(Map<String, dynamic> message) {
    // message is expected to be a map similar to Firebase RemoteMessage.toMap()
    final notification = message['notification'] as Map<String, dynamic>?;
    final data = message['data'] as Map<String, dynamic>?;

    DateTime? sentTime;
    if (message['sentTime'] != null) {
      try {
        sentTime = DateTime.parse(message['sentTime'].toString());
      } catch (_) {}
    }

    return NotificationModel(
      id: message['messageId']?.toString(),
      title: notification?['title']?.toString() ?? data?['title']?.toString(),
      body: notification?['body']?.toString() ?? data?['body']?.toString(),
      data: data ?? {},
      sentTime: sentTime,
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id']?.toString(),
      title: map['title']?.toString(),
      body: map['body']?.toString(),
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      sentTime:
          map['sentTime'] != null ? DateTime.parse(map['sentTime'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'body': body,
        'data': data,
        'sentTime': sentTime?.toIso8601String(),
      };
}

import '../../domain/entities/push_notification.dart';

abstract class NotificationEvent {}

class InitializeNotificationsEvent extends NotificationEvent {}

class RequestPermissionEvent extends NotificationEvent {}

class DeviceTokenLoadedEvent extends NotificationEvent {
  final String? token;
  DeviceTokenLoadedEvent(this.token);
}

class IncomingNotificationEvent extends NotificationEvent {
  final PushNotification notification;
  IncomingNotificationEvent(this.notification);
}

class NotificationErrorEvent extends NotificationEvent {
  final String message;
  NotificationErrorEvent(this.message);
}

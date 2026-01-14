import '../../domain/entities/push_notification.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationPermissionGranted extends NotificationState {}

class NotificationPermissionDenied extends NotificationState {}

class NotificationTokenLoaded extends NotificationState {
  final String? token;
  NotificationTokenLoaded(this.token);
}

class NotificationReceivedState extends NotificationState {
  final PushNotification notification;
  NotificationReceivedState(this.notification);
}

class NotificationFailureState extends NotificationState {
  final String message;
  NotificationFailureState(this.message);
}

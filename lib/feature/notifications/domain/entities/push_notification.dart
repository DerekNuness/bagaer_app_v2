import 'package:equatable/equatable.dart';

class PushNotification extends Equatable {
  final String? id;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  final DateTime? sentTime;

  const PushNotification({
    this.id,
    this.title,
    this.body,
    this.data,
    this.sentTime,
  });

  @override
  List<Object?> get props => [id, title, body, data, sentTime];
}
import 'package:fpdart/fpdart.dart';
import 'package:bagaer/core/errors/failures.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../domain/entities/push_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_data_source.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;
  final NotificationLocalDataSource local;

  NotificationRepositoryImpl({required this.remote, required this.local});

  @override
  Future<Either<Failure, Unit>> requestPermission() async {
    try {
      await remote.initialize();
      return Right(unit);
    } catch (e) {
      return Left(UnknownFailure("Unkown failure"));
    }
  }

  @override
  Stream<PushNotification> get onMessageStream => remote.onMessage.map((m) => NotificationModel.fromMap(m.toMap()));

  @override
  Future<Either<Failure, String?>> getDeviceToken() async {
    try {
      final token = await remote.getDeviceToken();
      if (token != null) await local.cacheDeviceToken(token);
      return Right(token);
    } catch (e) {
      final cached = await local.getCachedDeviceToken();
      if (cached != null) return Right(cached);
      return Left(UnknownFailure(e.toString()));
    }
  }
}

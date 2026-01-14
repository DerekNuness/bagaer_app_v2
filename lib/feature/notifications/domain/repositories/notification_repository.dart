import 'package:fpdart/fpdart.dart';
import 'package:bagaer/feature/notifications/domain/entities/push_notification.dart';
import 'package:bagaer/core/errors/failures.dart';

abstract class NotificationRepository {
  /// Solicita permissão de notificações ao usuário.
  /// Retorna [Unit] em caso de sucesso ou [Failure] em caso de erro.
  Future<Either<Failure, Unit>> requestPermission();

  /// Retorna o token do dispositivo (FCM) ou null se não disponível.
  Future<Either<Failure, String?>> getDeviceToken();

  /// Stream de notificações recebidas enquanto o app está em foreground/background.
  Stream<PushNotification> get onMessageStream;
}

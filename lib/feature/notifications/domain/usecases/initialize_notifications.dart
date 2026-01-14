import 'package:fpdart/fpdart.dart';
import 'package:bagaer/core/errors/failures.dart';
import '../repositories/notification_repository.dart';

class InitializeNotificationsUseCase {
  final NotificationRepository repository;

  InitializeNotificationsUseCase(this.repository);

  /// Chama [requestPermission] e obtém o token do dispositivo.
  /// Retorna [Right(Unit)] em sucesso encadeado ou [Left(Failure)] em erro.
  Future<Either<Failure, Unit>> call() async {
    final perm = await repository.requestPermission();
    return await perm.match(
      (l) => Future.value(Left(l)),
      (r) async {
        final tokenRes = await repository.getDeviceToken();
        return tokenRes.map((_) => unit);
      },
    );
  }
}

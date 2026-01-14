import 'package:fpdart/fpdart.dart';
import 'package:bagaer/core/errors/failures.dart';
import '../repositories/notification_repository.dart';

class RequestPermissionUseCase {
  final NotificationRepository repository;

  RequestPermissionUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.requestPermission();
  }
}

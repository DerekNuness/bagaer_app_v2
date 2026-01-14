import 'package:fpdart/fpdart.dart';
import 'package:bagaer/core/errors/failures.dart';
import '../repositories/notification_repository.dart';

class GetDeviceTokenUseCase {
  final NotificationRepository repository;

  GetDeviceTokenUseCase(this.repository);

  Future<Either<Failure, String?>> call() {
    return repository.getDeviceToken();
  }
}

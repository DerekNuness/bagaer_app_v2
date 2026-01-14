abstract class Failure {
  final String? message;
  const Failure([this.message]);
}

class TooManyRequestsFailure extends Failure {}

class NetworkFailure extends Failure {}

class UnknownFailure extends Failure {
  const UnknownFailure([String? message]) : super(message);
}
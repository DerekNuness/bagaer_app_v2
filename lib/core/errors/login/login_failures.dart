abstract class LoginFailure {
  final String message;
  const LoginFailure(this.message);
}

class LoginInvalidCredentialsFailure extends LoginFailure {
  const LoginInvalidCredentialsFailure() : super('login_page.login_errors.invalid_credentials');
}

class UserBlockedFailure extends LoginFailure {
  const UserBlockedFailure() : super('login_page.login_errors.user_blocked');
}

class LoginNetworkFailure extends LoginFailure {
  const LoginNetworkFailure() : super('login_page.login_errors.network_failure');
}

class LoginUnknownFailure extends LoginFailure {
  const LoginUnknownFailure([String msg = 'Erro inesperado']) : super(msg);
}
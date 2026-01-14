part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginHasToken extends LoginState {
  final String token;
  const LoginHasToken(this.token);

  @override
  List<Object?> get props => [token];
}

class LoginSuccess extends LoginState {
  final AuthSession session;
  const LoginSuccess(this.session);

  @override
  List<Object?> get props => [session];
}

class LoginNeedsInfo extends LoginState {
  final AuthSession session;
  const LoginNeedsInfo(this.session);

  @override
  List<Object?> get props => [session];
}

class LoginFailureState extends LoginState {
  final LoginFailure failure;
  const LoginFailureState(this.failure);

  @override
  List<Object?> get props => [failure];
}

class LoginLoggedOut extends LoginState {}

class LoginAccountDeleted extends LoginState {}
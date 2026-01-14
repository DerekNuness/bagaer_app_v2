part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

/// Boot: verifica se existe token no cache (SharedPreferences)
class CheckCachedTokenRequested extends LoginEvent {}

/// Boot: token existe → tenta direct login
class DirectLoginRequested extends LoginEvent {
  final String token;
  final String appVersion;
  final String deviceOs;

  const DirectLoginRequested({
    required this.token,
    required this.appVersion,
    required this.deviceOs,
  });

  @override
  List<Object?> get props => [token, appVersion, deviceOs];
}

class LoginRequested extends LoginEvent {
  final String phoneNumber;
  final String password;
  final String appVersion;
  final String deviceOs;

  const LoginRequested({
    required this.phoneNumber,
    required this.password,
    required this.appVersion,
    required this.deviceOs,
  });

  @override
  List<Object?> get props => [phoneNumber, password, appVersion, deviceOs];
}

class DeleteAccountRequested extends LoginEvent {
  final String token;
  final String password;

  const DeleteAccountRequested({
    required this.token,
    required this.password,
  });

  @override
  List<Object?> get props => [token, password];
}

class LogoutRequested extends LoginEvent {}
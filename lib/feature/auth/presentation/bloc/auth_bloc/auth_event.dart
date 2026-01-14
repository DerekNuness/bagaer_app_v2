// auth_event.dart
part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Chamado pelo AppEntryPoint após AppVersionAllowed
class AuthCheckRequested extends AuthEvent {
  final String appVersion;
  final String deviceOs;

  const AuthCheckRequested({
    required this.appVersion,
    required this.deviceOs,
  });

  @override
  List<Object?> get props => [appVersion, deviceOs];
}

/// Disparado quando Login/Register finaliza com sucesso
class AuthSessionChanged extends AuthEvent {
  final AuthSession session;

  const AuthSessionChanged(this.session);

  @override
  List<Object?> get props => [session];
}


/// Logout explícito
class AuthLogoutRequested extends AuthEvent {}

/// Para quando o usuario deletar a conta
class AuthAccountDeleted extends AuthEvent {}
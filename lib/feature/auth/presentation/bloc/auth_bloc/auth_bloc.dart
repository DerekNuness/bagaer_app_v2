// auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_cached_token_usecase.dart';
import '../../../domain/usecases/direct_login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/entities/auth_session.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCachedTokenUseCase getCachedToken;
  final DirectLoginUseCase directLogin;
  final LogoutUseCase logout;

  AuthBloc({
    required this.getCachedToken,
    required this.directLogin,
    required this.logout,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthSessionChanged>(_onSessionChanged);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthAccountDeleted>(_onAccountDeleted);
  }

  /// 🔍 Verifica token + sessão
  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthChecking());

    try {
      final token = await getCachedToken();

      if (token == null) {
        emit(AuthUnauthenticated());
        return;
      }

      final session = await directLogin(
        token: token,
        appVersion: event.appVersion,
        deviceOs: event.deviceOs,
      );

      emit(AuthAuthenticated(session));
    } catch (e) {
      /// token inválido / expirado / erro
      emit(AuthUnauthenticated());
    }
  }

  /// 🔁 Sessão mudou (login ou registro concluído)
  void _onSessionChanged(
    AuthSessionChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthAuthenticated(event.session));
  }

  /// 🚪 Logout
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logout();
    emit(AuthUnauthenticated());
  }
  
  void _onAccountDeleted(
    AuthAccountDeleted event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthUnauthenticated());
  }
}
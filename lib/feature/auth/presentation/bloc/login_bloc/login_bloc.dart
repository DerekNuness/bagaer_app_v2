import 'package:bagaer/core/errors/login/login_failures.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/auth_session.dart';
import '../../../domain/usecases/get_cached_token_usecase.dart';
import '../../../domain/usecases/direct_login_usecase.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/delete_account_usecase.dart';

// seus failures (ex.: LoginInvalidCredentialsFailure etc.)

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GetCachedTokenUseCase getCachedToken;
  final DirectLoginUseCase directLogin;
  final LoginUseCase login;
  final LogoutUseCase logout;
  final DeleteAccountUsecase deleteAccount;

  LoginBloc({
    required this.getCachedToken,
    required this.directLogin,
    required this.login,
    required this.logout,
    required this.deleteAccount,
  }) : super(LoginInitial()) {
    on<CheckCachedTokenRequested>(_onCheckToken);
    on<DirectLoginRequested>(_onDirectLogin);
    on<LoginRequested>(_onLogin);
    on<LogoutRequested>(_onLogout);
    on<DeleteAccountRequested>(_onDeleteAccount);
  }

  Future<void> _onCheckToken(CheckCachedTokenRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    final token = await getCachedToken();
    if (token == null || token.isEmpty) {
      emit(LoginInitial());
      return;
    }
    emit(LoginHasToken(token));
  }

  Future<void> _onDirectLogin(DirectLoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final session = await directLogin(
        token: event.token,
        appVersion: event.appVersion,
        deviceOs: event.deviceOs,
      );

      // decide se precisa completar dados
      final needsInfo = session.user.needsProfileData || !session.user.hasRequiredProfileData;
      emit(needsInfo ? LoginNeedsInfo(session) : LoginSuccess(session));
    } on LoginUnknownFailure catch (e) {
      emit(LoginFailureState(e));
    }
  }

  Future<void> _onLogin(LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final session = await login(
        phoneNumber: event.phoneNumber,
        password: event.password,
        appVersion: event.appVersion,
        deviceOs: event.deviceOs,
      );

      final needsInfo = session.user.needsProfileData || !session.user.hasRequiredProfileData;
      emit(needsInfo ? LoginNeedsInfo(session) : LoginSuccess(session));
    } on LoginFailure catch (f) {
      emit(LoginFailureState(f));
    } catch (e) {
      emit(LoginFailureState(LoginUnknownFailure()));
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<LoginState> emit) async {
    await logout();
    emit(LoginLoggedOut());
  }

  Future<void> _onDeleteAccount(DeleteAccountRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final deleted = await deleteAccount(token: event.token, password: event.password);
      if (deleted == true) {
        emit(LoginAccountDeleted());
      } else {
        emit(LoginFailureState(LoginUnknownFailure()));
      }
    } catch (e) {
      emit(LoginFailureState(LoginUnknownFailure()));
    }
  }
}
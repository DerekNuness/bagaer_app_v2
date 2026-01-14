import 'dart:io';

import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/core/navigation/main_scaffold.dart';
import 'package:bagaer/core/navigation/service/navigation_service.dart';
import 'package:bagaer/feature/app_version/presentation/bloc/app_version_bloc.dart';
import 'package:bagaer/feature/app_version/presentation/pages/force_update_page.dart';
import 'package:bagaer/feature/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:bagaer/feature/auth/presentation/pages/auth_decision/auth_decision_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/register_flow_view.dart';
import 'package:bagaer/feature/splashscreen/presentation/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  /// controle da splash
  bool _splashFinished = false;

  /// estados pendentes
  AppVersionState? _versionState;
  AuthState? _authState;

  late PackageInfo _packageInfo;
  late String _platform;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _platform = Platform.operatingSystem;

    /// 🚀 começa IMEDIATAMENTE
    context.read<AppVersionBloc>().add(
          CheckAppVersionEvent(_packageInfo.version),
        );
  }

  /// Splash terminou
  void _onSplashFinished() {
    _splashFinished = true;
    _tryResolveFlow();
  }

  /// 🔁 Resolve fluxo final (version + auth)
  void _tryResolveFlow() {
    if (!_splashFinished) return;
    if (_versionState == null) return;

    /// 1️⃣ versão sempre tem prioridade
    if (_versionState is AppVersionBlocked) {
      sl<NavigationService>().pushAndRemoveUntilBottomTopAnimation(
        context,
        ForceUpdatePage(
          appConfig: (_versionState as AppVersionBlocked).info,
        ),
      );
      _clearStates();
      return;
    }

    /// 2️⃣ versão OK → precisa auth
    if (_versionState is AppVersionAllowed) {
      if (_authState == null) return;

      final auth = _authState!;

      if (auth is AuthUnauthenticated) {
        sl<NavigationService>().pushAndRemoveUntilBottomTopAnimation(
          context,
          const AuthDecisionPage(),
        );
      }

      if (auth is AuthAuthenticated) {
        if (auth.session.user.needsProfileData) {
          sl<NavigationService>().pushAndRemoveUntilBottomTopAnimation(
            context,
            BlocProvider(
              create: (context) => sl<RegisterBloc>()..add(SendToProfileDataStep(session: auth.session)),
              child: const RegisterFlowView(),
            ),
          );
        } else {
          // print("Entrou aqui");
          sl<NavigationService>().pushAndRemoveUntilBottomTopAnimation(
            context,
            const MainScaffold(),
          );
        }
        
      }
    }

    _clearStates();
  }

  void _clearStates() {
    _versionState = null;
    _authState = null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// ==========================
        /// 📦 App Version
        /// ==========================
        BlocListener<AppVersionBloc, AppVersionState>(
          listener: (context, state) {
            _versionState = state;

            /// se versão permitida, já dispara auth
            if (state is AppVersionAllowed) {
              context.read<AuthBloc>().add(AuthCheckRequested(
                    appVersion: _packageInfo.version,
                    deviceOs: _platform,
                  ));
            }

            _tryResolveFlow();
          },
        ),

        /// ==========================
        /// 🔐 Auth
        /// ==========================
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            _authState = state;
            _tryResolveFlow();
          },
        ),
      ],
      child: SplashPage(
        onAnimationFinished: _onSplashFinished,
      ),
    );
  }
}

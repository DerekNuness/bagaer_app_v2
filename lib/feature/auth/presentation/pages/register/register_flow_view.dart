import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/feature/auth/presentation/bloc/register_bloc/register_bloc.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/account_created_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_code_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_create_user_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_meal_preferences_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_phone_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_travel_preferences_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_upload_photo_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_user_info_page.dart';
import 'package:bagaer/feature/auth/presentation/pages/register/steps/register_welcome_page.dart';
import 'package:bagaer/feature/meal_preference/presentation/cubit/meal_preferences_cubit.dart';
import 'package:bagaer/feature/media/presentation/bloc/media_capture_bloc/media_capture_bloc.dart';
import 'package:bagaer/feature/travel_preferences/presentation/cubit/travel_preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class _RegisterRoutes {
  static const phone = '/phone';
  static const code = '/code';
  static const createUser = '/createUser';
  static const userCreated = '/userCreated';
  static const profileData = '/profileData';
  static const travelPrefs = '/travelPrefs';
  static const mealPrefs = '/mealPrefs';
  static const uploadPhoto = '/uploadPhoto';
  static const done = '/done';
}

class RegisterFlowView extends StatelessWidget {
  const RegisterFlowView({super.key});

  static final GlobalKey<NavigatorState> _navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: (prev, curr) =>
          prev.step != curr.step && curr.status == RegisterStatus.success,
      listener: (context, state) {
        print(state.step);
        final navigator = _navigatorKey.currentState;
        print(navigator);
        if (navigator == null) return;

        switch (state.step) {
          case RegisterStep.code:
            navigator.pushNamed(
              _RegisterRoutes.code,
              arguments: state.phoneNumber!,
            );
            break;

          case RegisterStep.createUser:
            navigator.pushReplacementNamed(_RegisterRoutes.createUser);
            break;

          case RegisterStep.userCreated:
            navigator.pushNamedAndRemoveUntil(
                _RegisterRoutes.userCreated, (_) => false);
            break;

          case RegisterStep.profileData:
            navigator.pushNamedAndRemoveUntil(
                _RegisterRoutes.profileData, (_) => false);
            break;

          case RegisterStep.travelPrefs:
            navigator.pushNamedAndRemoveUntil(
                _RegisterRoutes.travelPrefs, (_) => false);
            break;

          case RegisterStep.mealPrefs:
            navigator.pushNamedAndRemoveUntil(
                _RegisterRoutes.mealPrefs, (_) => false);
            break;

          case RegisterStep.uploadPhoto:
            navigator.pushNamedAndRemoveUntil(
                _RegisterRoutes.uploadPhoto, (_) => false);
            break;

          case RegisterStep.done:
            navigator.pushNamedAndRemoveUntil(_RegisterRoutes.done, (_) => false);
            break;

          default:
            break;
        }
      },

      /// 🔽 NAVIGATOR INTERNO
      child: Navigator(
        key: _navigatorKey,
        initialRoute: _RegisterRoutes.phone,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case _RegisterRoutes.phone:
              return _buildRoute(
                RegisterPhonePage()
              );

            case _RegisterRoutes.code:
              final phone = settings.arguments as String;
              return _buildRoute(
                RegisterCodePage(phoneNumber: phone),
              );

            case _RegisterRoutes.createUser:
              return _buildRoute(
                RegisterCreateUserPage(),
              );

            case _RegisterRoutes.userCreated:
              return _buildRoute(
                AccountCreatedPage(),
              );

            case _RegisterRoutes.profileData:
              return _buildRouteBottomTop(
                RegisterUserInfoPage(),
              );

            case _RegisterRoutes.travelPrefs:
              return _buildRoute(
                BlocProvider(
                  create: (context) => sl<TravelPreferencesCubit>()..load(),
                  child: RegisterTravelPreferencesPage(),
                ),
              );

            case _RegisterRoutes.mealPrefs:
              return _buildRoute(
                BlocProvider(
                  create: (context) => sl<MealPreferencesCubit>()..load(),
                  child: RegisterMealPreferencesPage(),
                ),
              );

            case _RegisterRoutes.uploadPhoto:
              return _buildRoute(
                BlocProvider(
                  create: (context) => sl<MediaCaptureBloc>(),
                  child: RegisterUploadPhotoPage(),
                ),
              );

            case _RegisterRoutes.done:
              return _buildRoute(
                RegisterWelcomePage()
              );

            default:
              return _buildRoute(
                const RegisterPhonePage(),
              );
          }
        },
      ),
    );
  }

  PageRoute _buildRoute(Widget child) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, animation, __) => child,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(
          CurveTween(curve: Curves.easeInOutQuart),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  PageRoute _buildRouteBottomTop(Widget child) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (_, animation, __) => child,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(0.0, 3.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOutQuart));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

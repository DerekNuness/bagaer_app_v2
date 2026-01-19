// lib/app.dart
import 'package:bagaer/app_entry_point.dart';
import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/core/localization/app_localization.dart';
import 'package:bagaer/core/localization/supported_locales.dart';
import 'package:bagaer/core/navigation/service/navigation_service.dart';
import 'package:bagaer/core/theme/app_theme.dart';
import 'package:bagaer/feature/app_version/presentation/bloc/app_version_bloc.dart';
import 'package:bagaer/feature/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bagaer/feature/language/presentation/bloc/language/bloc/language_bloc.dart';
import 'package:bagaer/feature/notifications/presentation/bloc/notification_bloc.dart';
import 'package:bagaer/feature/notifications/presentation/bloc/notification_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LanguageBloc>()),
        BlocProvider(create: (_) => sl<AppVersionBloc>()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider<NotificationBloc>(
          // 1. ADICIONE ISTO: Desativa o lazy loading
          lazy: false, 
          
          // 2. Garanta que o evento de inicialização é chamado aqui
          create: (context) => sl<NotificationBloc>()..add(InitializeNotificationsEvent()),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: state.locale,
            supportedLocales: supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            scrollBehavior: const MaterialScrollBehavior().copyWith(scrollbars: false),
            navigatorKey: sl<NavigationService>().navigatorKey,
            title: 'Bagaer',
            theme: AppTheme.light,
            home: const AppEntryPoint(),
          );
        },
      ),
    );
  }
}

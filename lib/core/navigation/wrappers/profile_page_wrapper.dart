import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/feature/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:bagaer/feature/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePageWrapper extends StatefulWidget {
  final GlobalKey<NavigatorState> profilePageControllerNavigationKey;
  const ProfilePageWrapper(
      {super.key, required this.profilePageControllerNavigationKey});

  @override
  State<ProfilePageWrapper> createState() => _ProfilePageWrapperState();
}

class _ProfilePageWrapperState extends State<ProfilePageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.profilePageControllerNavigationKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            // if (settings.name == '/avaliados') {
            //   return const MaisAvaliadosScreen();
            // } else if (settings.name == '/recentes') {
            //   return const RecentesScreen();
            // }
            return BlocProvider(
              create: (context) => sl<LoginBloc>(),
              child: ProfilePage(),
            ); // Rota principal
          },
        );
      },
    );
  }
}

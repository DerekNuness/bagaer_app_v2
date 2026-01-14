import 'package:bagaer/feature/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class HomePageWrapper extends StatefulWidget {
  final GlobalKey<NavigatorState> homePageControllerNavigationKey;
  const HomePageWrapper({
    super.key,
    required this.homePageControllerNavigationKey,
  });

  @override
  State<HomePageWrapper> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.homePageControllerNavigationKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            // if (settings.name == '/avaliados') {
            //   return const MaisAvaliadosScreen();
            // } else if (settings.name == '/recentes') {
            //   return const RecentesScreen();
            // }
            return HomePage(); // Rota principal
          },
        );
      },
    );
  }
}

import 'package:bagaer/feature/baggage/presentation/pages/baggage_page.dart';
import 'package:flutter/material.dart';

class BaggagesPageWrapper extends StatefulWidget {
  final GlobalKey<NavigatorState> baggagePageControllerNavigationKey;
  const BaggagesPageWrapper({super.key, required this.baggagePageControllerNavigationKey});

  @override
  State<BaggagesPageWrapper> createState() => _BaggagesPageWrapperState();
}

class _BaggagesPageWrapperState extends State<BaggagesPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.baggagePageControllerNavigationKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            // if (settings.name == '/avaliados') {
            //   return const MaisAvaliadosScreen();
            // } else if (settings.name == '/recentes') {
            //   return const RecentesScreen();
            // }
            return BaggagePage(); // Rota principal
          },
        );
      },
    );
  }
}
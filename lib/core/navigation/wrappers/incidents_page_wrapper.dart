import 'package:bagaer/feature/incidents/presentation/pages/incidents_page.dart';
import 'package:flutter/material.dart';

class IncidentsPageWrapper extends StatefulWidget {
  final GlobalKey<NavigatorState> incidentsPageControllerNavigationKey;
  const IncidentsPageWrapper({super.key, required this.incidentsPageControllerNavigationKey});

  @override
  State<IncidentsPageWrapper> createState() => _IncidentsPageWrapperState();
}

class _IncidentsPageWrapperState extends State<IncidentsPageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.incidentsPageControllerNavigationKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            // if (settings.name == '/avaliados') {
            //   return const MaisAvaliadosScreen();
            // } else if (settings.name == '/recentes') {
            //   return const RecentesScreen();
            // }
            return IncidentsPage(); // Rota principal
          },
        );
      },
    );
  }
}
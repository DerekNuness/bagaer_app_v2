import 'package:bagaer/core/di/injection_container.dart';
import 'package:bagaer/core/navigation/service/navigation_service.dart';
import 'package:bagaer/core/navigation/wrappers/baggages_page_wrapper.dart';
import 'package:bagaer/core/navigation/wrappers/home_page_wrapper.dart';
import 'package:bagaer/core/navigation/wrappers/incidents_page_wrapper.dart';
import 'package:bagaer/core/navigation/wrappers/profile_page_wrapper.dart';
import 'package:bagaer/core/theme/app_colors.dart';
import 'package:bagaer/core/widgets/navbar/custom_nav_bar_widget.dart';
import 'package:bagaer/feature/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:bagaer/feature/auth/presentation/pages/auth_decision/auth_decision_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _index = 0;
  final GlobalKey<NavigatorState> homePageNavigationKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> baggagePageNavigationKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> incidentsPageNavigationKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> profilePageNavigationKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {}
  }

  List<Widget> _setNavigators() {
    return <Widget>[
      HomePageWrapper(
        homePageControllerNavigationKey: homePageNavigationKey,
      ),
      BaggagesPageWrapper(
          baggagePageControllerNavigationKey: baggagePageNavigationKey),
      IncidentsPageWrapper(
          incidentsPageControllerNavigationKey: incidentsPageNavigationKey),
      ProfilePageWrapper(
          profilePageControllerNavigationKey: profilePageNavigationKey)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Segurança extra: se deslogar, não fica no scaffold
          sl<NavigationService>().pushAndRemoveUntilLeftRightAnimation(
            context, 
            AuthDecisionPage()
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.errorRed,
        extendBody: true,
        body: IndexedStack(
          index: _index,
          children: _setNavigators(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF2E4482), // Cor azul do seu print
          elevation: 8,
          onPressed: () {},
          child: Icon(Icons.add, size: 35.sp, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BagaerNavBar(
          currentIndex: _index, 
          onTap: _onItemTapped
        )
      ),
    );
  }

}

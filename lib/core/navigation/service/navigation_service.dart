import 'package:flutter/material.dart';

class NavigationService {
  
  late GlobalKey<NavigatorState> navigatorKey;

  NavigationService(){
    navigatorKey = GlobalKey<NavigatorState>();
  }

  pop(){
    return navigatorKey.currentState?.pop();
  }

  navigate(Widget widget){
    return navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => widget)
    );
  }

  navigateWithResponse(MaterialPageRoute<Map<String, dynamic>?> widget){
    return navigatorKey.currentState?.push<Map<String, dynamic>?>(
      widget
    );
  }

  navigateReplace(Widget widget){
    return navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => widget)
    );
  }

  navigateAndRemoveAll(Widget widget){
    return navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false, // false remove todas as rotas
    );
  }
  
  pushBottomTopAnimation(BuildContext context, Widget widget){
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => widget,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutQuart));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  pushReplacementBottomTopAnimation(BuildContext context, Widget widget){
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => widget,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutQuart));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  pushAndRemoveUntilBottomTopAnimation(BuildContext context, Widget widget){
    return Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => widget,
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
      ),
      (_) => false,
    );
  }

  pushRightLeftAnimation(BuildContext context, Widget widget){
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => widget,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutQuart));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  pushReplacementRightLeftAnimation(BuildContext context, Widget widget){
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => widget,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutQuart));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  pushAndRemoveUntilRightLeftAnimation(BuildContext context, Widget widget){
    return Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => widget,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutQuart));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
      (_) => false,
    );
  }

  pushLeftRightAnimation(BuildContext context, Widget widget){
    return Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => widget,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutQuart));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  pushReplacementLeftRightAnimation(BuildContext context, Widget widget){
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => widget,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutQuart));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  pushAndRemoveUntilLeftRightAnimation(BuildContext context, Widget widget){
    return Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => widget,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOutQuart));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
      (_) => false,
    );
  }

}
import 'package:flutter/material.dart';

class InternalNavigator {

  Future<T?> pushRightLeftAnimation<T>(BuildContext context, Widget widget, {bool rootNavigator = false}){
    return Navigator.of(context, rootNavigator: rootNavigator).push<T>(_route(widget) as Route<T>);
  }

  Future pushReplacementRightLeftAnimation(BuildContext context, Widget widget, {bool rootNavigator = false}){
    return Navigator.of(context, rootNavigator: rootNavigator).pushReplacement(_route(widget));
  }

  Future pushAndRemoveUntilRightLeftAnimation(BuildContext context, Widget widget, {bool rootNavigator = false}){
    return Navigator.of(context, rootNavigator: rootNavigator).pushAndRemoveUntil(_route(widget), (_) => false);
  }

  
  // pushReplacementRightLeftAnimation(BuildContext context, Widget widget){
  //   return Navigator.pushReplacement(
  //     context,
  //     PageRouteBuilder(
  //       transitionDuration: const Duration(milliseconds: 500),
  //       pageBuilder: (_, animation, __) => widget,
  //       transitionsBuilder: (_, animation, __, child) {
  //         final tween = Tween(
  //           begin: const Offset(1.0, 0.0),
  //           end: Offset.zero,
  //         ).chain(CurveTween(curve: Curves.easeInOutQuart));

  //         return SlideTransition(
  //           position: animation.drive(tween),
  //           child: child,
  //         );
  //       },
  //     ),
  //   );
  // }

  // pushAndRemoveUntilRightLeftAnimation(BuildContext context, Widget widget){
  //   return Navigator.pushAndRemoveUntil(
  //     context,
  //     PageRouteBuilder(
  //       transitionDuration: const Duration(milliseconds: 500),
  //       pageBuilder: (_, animation, __) => widget,
  //       transitionsBuilder: (_, animation, __, child) {
  //         final tween = Tween(
  //           begin: const Offset(1.0, 0.0),
  //           end: Offset.zero,
  //         ).chain(CurveTween(curve: Curves.easeInOutQuart));

  //         return SlideTransition(
  //           position: animation.drive(tween),
  //           child: child,
  //         );
  //       },
  //     ),
  //     (_) => false,
  //   );
  // }

  PageRouteBuilder _route(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, animation, __) => page,
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
}
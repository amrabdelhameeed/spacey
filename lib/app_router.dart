import 'package:flutter/material.dart';
import 'package:spacey/features/home/home.dart';
import 'package:spacey/features/intro/intro_screen.dart';

import '/core/constants/app_routes.dart';

class AppRouter {
  AppRouter() {}
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (context) {
            return Home();
          },
        );
      case AppRoutes.intro:
        return MaterialPageRoute(
          builder: (context) {
            return IntroScreen();
          },
        );
    }
  }
  // MaterialPageRoute<dynamic> _routeError() {
  //   return MaterialPageRoute(
  //     builder: (_) {
  //       return const Scaffold(
  //         body: Center(
  //           child: Text('Route Error'),
  //         ),
  //       );
  //     },
  //   );
  // }
}

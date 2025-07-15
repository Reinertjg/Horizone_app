import 'package:flutter/material.dart';

import '../presentation/pages/dashboard_screen.dart';
import '../presentation/pages/getstarted_screen.dart';
import '../presentation/pages/profilesetup_screen.dart';
import '../presentation/pages/splash_screen.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreen(),
    '/getStarted': (context) => const GetStartedScreen(),
    '/profileSetup': (context) => const ProfileSetUpScreen(),
    '/dashboard': (context) => const DashboardScreen(),
  };
}

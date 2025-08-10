import 'package:flutter/material.dart';

import 'pages/dashboard_screen.dart';
import 'pages/getstarted_screen.dart';
import 'pages/home_screen.dart';
import 'pages/interview_screen.dart';
import 'pages/profilesetup_screen.dart';
import 'pages/splash_screen.dart';


/// Centralized route management for the app.
abstract class AppRoutes {
  // Private constructor to prevent instantiation.
  AppRoutes._();
  /// Centralized route management for the app.
  /// Good practice: makes navigation easier to maintain and scale.
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreen(),

    /// Initial onboarding or welcome screen
    '/getStarted': (context) => const GetStartedScreen(),

    /// First-time profile setup screen
    '/profileSetup': (context) => const ProfileSetUpScreen(),


    '/homeScreen': (context) => const HomeScreen(),

    /// Main screen after login/setup
    '/dashboard': (context) => const DashboardScreen(),

    /// Screen for managing or input interviews/trip
    '/interview': (context) => const InterviewScreen(),

  };
}


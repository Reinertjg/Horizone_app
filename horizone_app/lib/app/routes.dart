import 'package:flutter/material.dart';

import '../presentation/pages/dashboard_screen.dart';
import '../presentation/pages/getstarted_screen.dart';
import '../presentation/pages/interview_screen.dart';
import '../presentation/pages/profilesetup_screen.dart';
import '../presentation/pages/splash_screen.dart';
import '../presentation/pages/trip_participants_screen.dart';

class AppRoutes {
  /// Centralized route management for the app.
  /// Good practice: makes navigation easier to maintain and scale.
  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreen(),

    /// Initial onboarding or welcome screen
    '/getStarted': (context) => const GetStartedScreen(),

    /// First-time profile setup screen
    '/profileSetup': (context) => const ProfileSetUpScreen(),

    /// Main screen after login/setup
    '/dashboard': (context) => const DashboardScreen(),

    /// Screen for managing or input interviews/trip
    '/interview': (context) => const InterviewScreen(),

    /// Screen for managing or input trip participants
    '/tripParticipants': (context) => const TripParticipantsScreen(),
  };
}


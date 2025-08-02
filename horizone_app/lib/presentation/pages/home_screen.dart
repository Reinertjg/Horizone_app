import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../generated/l10n.dart';

import '../theme_color/app_colors.dart';
import '../widgets/iconbutton_notifications.dart';
import '../widgets/iconbutton_settings.dart';
import '../widgets/profile_widgets/bottom_navigationbar.dart';
import 'dashboard_screen.dart';
import 'interview_screen.dart';

/// The main screen displayed after user login,
/// showing a personalized welcome and main navigation options.
class HomeScreen extends StatefulWidget {
  /// Creates a [HomeScreen] widget.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State class for [HomeScreen], responsible for UI rendering and loading.
class _HomeScreenState extends State<HomeScreen> {
  int _selectedScreenIndex = 0;
  final List _screens = [
    {'screen': const DashboardScreen(), 'title': 'Screen A Title'},
    {'screen': const InterviewScreen(), 'title': 'Screen B Title'}
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      body: _screens[_selectedScreenIndex]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        backgroundColor: colors.primary,
        unselectedItemColor: colors.tertiary,
        selectedItemColor: colors.tertiary,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: colors.secondary),
            label: S.of(context).home,
            backgroundColor: colors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mode_of_travel_outlined, color: colors.secondary),
            backgroundColor: colors.primary,
            label: S.of(context).planning,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: colors.secondary),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_rounded, color: colors.secondary),
            label: S.of(context).profile,
          ),
        ],
        currentIndex: _selectedScreenIndex,
      ),
    );
  }
}

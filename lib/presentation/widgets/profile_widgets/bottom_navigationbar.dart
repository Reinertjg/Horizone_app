import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../theme_color/app_colors.dart';

/// Creates a bottom navigation bar for the application.
///
/// The [currentIndex] parameter indicates the currently selected item.
BottomNavigationBar bottomNavigationBar(
  BuildContext context,
  int currentIndex,
) {
  final colors = Theme.of(context).extension<AppColors>()!;
  return BottomNavigationBar(
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
    currentIndex: currentIndex,

  );
}

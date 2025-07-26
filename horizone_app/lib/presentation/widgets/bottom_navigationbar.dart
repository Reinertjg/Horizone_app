import 'package:flutter/material.dart';

import '../../AppColors.dart';
import '../../generated/l10n.dart';

BottomNavigationBar bottomNavigationBar(
  BuildContext context,
  int currentIndex,
)
{
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
        icon: Icon(
          Icons.mode_of_travel_outlined,
          color: colors.secondary,
        ),
        backgroundColor: colors.primary,
        label: S.of(context).planning,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month, color: colors.secondary),
        label: 'Notifications',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person_pin_rounded,
          color: colors.secondary,
        ),
        label: S.of(context).profile,
      ),
    ],
    currentIndex: currentIndex,
    // Set the current index to the first item
    onTap: (index) {
      switch (index) {
        case 0:
          if (currentIndex != 0) {
            Navigator.pushNamed(context, '/dashboard');
          }
          break;
        case 1:
          if (currentIndex != 1) {
            Navigator.pushNamed(context, '/interview');
          }
          break;
        case 2:
          break;
        case 3:
          break;
      }
    },
  );
}

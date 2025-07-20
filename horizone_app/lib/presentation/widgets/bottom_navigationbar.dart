import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

BottomNavigationBar bottomNavigationBar(
  BuildContext context,
  int currentIndex,
) {
  return BottomNavigationBar(
    backgroundColor: Theme.of(context).primaryColor,
    unselectedItemColor: Theme.of(context).hintColor,
    selectedItemColor: Theme.of(context).hintColor,
    elevation: 0,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home, color: Theme.of(context).primaryColor),
        label: S.of(context).home,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.mode_of_travel_outlined,
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        label: S.of(context).planning,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
        label: 'Notifications',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.person_pin_rounded,
          color: Theme.of(context).primaryColor,
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

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

 BottomNavigationBar bottomNavigationBar (BuildContext context) {
   return BottomNavigationBar(
     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
     unselectedItemColor: Theme.of(context).hintColor,
     selectedItemColor: Theme.of(context).hintColor,
     items: [
       BottomNavigationBarItem(
         icon: Icon(Icons.home, color: Theme.of(context).primaryColor),
         label: S.of(context).home,
         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
       ),
       BottomNavigationBarItem(
         icon: Icon(
           Icons.travel_explore,
           color: Theme.of(context).primaryColor,
         ),
         label: 'Search',
       ),
       BottomNavigationBarItem(
         icon: Icon(
           Icons.calendar_month,
           color: Theme.of(context).primaryColor,
         ),
         label: 'Notifications',
       ),
       BottomNavigationBarItem(
         icon: Icon(
           Icons.person_pin_rounded,
           color: Theme.of(context).primaryColor,
         ),
         label: 'Profile',
       ),
     ],
     currentIndex: 0,
     // Set the current index to the first item
     onTap: (index) {
       switch (index) {
         case 0:
           break;
         case 1:
           break;
         case 2:
           break;
         case 3:
           break;
       }
     },
   );
 }

import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Theme.of(context).primaryColor,),
            label: 'Home',
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore, color: Theme.of(context).primaryColor,),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month, color: Theme.of(context).primaryColor,),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin_rounded, color: Theme.of(context).primaryColor,),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // Set the current index to the first item
        onTap: (index) {
          switch(index) {
            case 0:
              print('Home tapped');
              break;
            case 1:
              print('Search tapped');
              break;
            case 2:
              print('Notifications tapped');
              break;
            case 3:
              print('Profile tapped');
              break;
          }
        },
      ),
    );
  }
}

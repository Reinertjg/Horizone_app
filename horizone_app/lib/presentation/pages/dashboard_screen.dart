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
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Hi, %name%',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        leading: Material(
          color: Theme.of(context).primaryColor,
          shape: const CircleBorder(),
          child: ClipOval(
            child: Image.network(
              'https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg',
              width: 60, // defina uma largura
              height: 60, // e uma altura iguais
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              Material(
                color: Theme.of(context).primaryColor,
                shape: CircleBorder(),
                child: IconButton(
                  onPressed: () {

                  },
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).highlightColor,
                  ),
                ),
              ),
              Material(
                color: Theme.of(context).primaryColor,
                shape: CircleBorder(),
                child: IconButton(
                  onPressed: () {
                    print('Notifications tapped');
                  },
                  icon: Icon(
                    Icons.notifications_none,
                    color: Theme.of(context).highlightColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Theme.of(context).primaryColor),
            label: 'Home',
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
        currentIndex: 0, // Set the current index to the first item
        onTap: (index) {
          switch (index) {
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

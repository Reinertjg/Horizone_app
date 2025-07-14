import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../state/locale_provider.dart';
import '../state/theme_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 100,
        title: Text(
          '${S.of(context).welcome}, John Willans',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 28, left: 10.0, bottom: 25.0),
          child: Material(
            color: Theme.of(context).primaryColor,
            shape: const CircleBorder(),
            child: ClipOval(
              child: Image.network(
                'https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Material(
                  color: Theme.of(context).primaryColor,
                  shape: CircleBorder(),
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.settings,
                        color: Theme.of(context).highlightColor,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return Consumer<ThemeProvider>(
                              builder: (context, themeProvider, child) {
                                return Container(
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        S.of(context).settings,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ListTile(
                                        title: Text(
                                          S.of(context).theme,
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  S.of(context).selectTheme,
                                                ),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        S.of(context).lightTheme,
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          themeProvider.setTheme(
                                                            ThemeMode.light,
                                                          );
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        S.of(context).darkTheme,
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          themeProvider.setTheme(
                                                            ThemeMode.dark,
                                                          );
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        S.of(context).systemTheme,
                                                      ),
                                                      onTap: () {
                                                        setState(() {
                                                          themeProvider.setTheme(
                                                            ThemeMode.system,
                                                          );
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      ListTile(
                                        title: Text(
                                          S.of(context).language,
                                          style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward,
                                          color: Theme.of(context).primaryColor,
                                          size: 20,
                                        ),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                  S.of(context).selectLanguage,
                                                ),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      title: Text('English'),
                                                      onTap: () {
                                                        localeProvider.setLocale(
                                                          Locale('en'),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: Text('Português'),
                                                      onTap: () {
                                                        localeProvider.setLocale(
                                                          Locale('pt'),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: Text('Español'),
                                                      onTap: () {
                                                        localeProvider.setLocale(
                                                          Locale('es'),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: Theme.of(context).primaryColor,
                  shape: CircleBorder(),
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.notifications_none,
                        color: Theme.of(context).highlightColor,
                      ),
                      onPressed: () {},

                    ),
                  ),
                ),
              ],
            ),
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
      ),
    );
  }
}

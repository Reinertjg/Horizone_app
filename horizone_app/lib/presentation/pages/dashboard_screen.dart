import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/daos/profile_dao.dart';
import '../../generated/l10n.dart';
import '../state/locale_provider.dart';
import '../state/theme_provider.dart';
import '../widgets/bottom_navigationbar.dart';
import '../widgets/settings_widgets/delete_accoun_ttile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final profileDao = ProfileDao();
  var profiles;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    final perfilBuscado = await profileDao.getProfile();
    setState(() {
      profiles = perfilBuscado;
    });
  }

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
          '${S.of(context).welcome}, ${profiles != null && profiles.isNotEmpty ? profiles[0]['name'] : 'User'}',
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
                                          S.of(context).language,
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
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
                                                backgroundColor: Theme.of(
                                                  context,
                                                ).scaffoldBackgroundColor,
                                                title: Text(
                                                  S.of(context).selectLanguage,
                                                  style: TextStyle(
                                                    color: Theme.of(
                                                      context,
                                                    ).primaryColor,
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        'English',
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        localeProvider
                                                            .setLocale(
                                                              Locale('en'),
                                                            );
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        'Português',
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        localeProvider
                                                            .setLocale(
                                                              Locale('pt'),
                                                            );
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        'Español',
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        localeProvider
                                                            .setLocale(
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
                                      DeleteAccountTile(),
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
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }
}

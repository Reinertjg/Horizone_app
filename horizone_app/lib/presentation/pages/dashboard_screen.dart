import 'package:flutter/material.dart';
import '../../database/daos/profile_dao.dart';
import '../../generated/l10n.dart';
import '../widgets/bottom_navigationbar.dart';
import '../widgets/settings_widgets/settingsbottom_sheetcontent.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final profileDao = ProfileDao();
  List<Map<String, dynamic>> profiles = [];

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

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 100,
        title: Text(
          '${S.of(context).welcome}, ${profiles.isNotEmpty ? profiles[0]['name'] : 'User'}',
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
                        SettingsBottomSheetContent();
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

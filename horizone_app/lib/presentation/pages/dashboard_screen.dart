import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:horizone_app/AppColors.dart';
import 'package:horizone_app/presentation/widgets/iconbutton_notifications.dart';
import '../../database/daos/profile_dao.dart';
import '../../generated/l10n.dart';
import '../widgets/bottom_navigationbar.dart';
import '../widgets/iconbutton_settings.dart';

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
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      backgroundColor: colors.primary,
      appBar: AppBar(
        backgroundColor: colors.primary,
        elevation: 0,
        toolbarHeight: 100,
        title: Text(
          '${S.of(context).welcome}, ${profiles.isNotEmpty ? profiles[0]['name'] : 'User'}',
          style: GoogleFonts.nunito(color: colors.secondary),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 28, left: 10.0, bottom: 25.0),
          child: Material(
            color: colors.secondary,
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
                IconbuttonSettings(),
                const SizedBox(width: 10),
                IconbuttonNotifications(),
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
      bottomNavigationBar: bottomNavigationBar(context, 0),
    );
  }
}

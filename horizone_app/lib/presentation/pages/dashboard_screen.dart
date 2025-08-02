import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../generated/l10n.dart';

import '../theme_color/app_colors.dart';
import '../widgets/iconbutton_notifications.dart';
import '../widgets/iconbutton_settings.dart';
import '../widgets/profile_widgets/bottom_navigationbar.dart';

/// The main screen displayed after user login,
/// showing a personalized welcome and main navigation options.
class DashboardScreen extends StatefulWidget {
  /// Creates a [DashboardScreen] widget.
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

/// State class for [DashboardScreen], responsible for UI rendering and loading.
class _DashboardScreenState extends State<DashboardScreen> {
  /// The repository used to fetch profile data.
  final repository = ProfileRepositoryImpl();

  /// The list of profiles loaded from the data source.
  List<Profile> profiles = [];

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  /// Loads all profiles from the repository and updates the UI.
  Future<void> _carregarPerfil() async {
    final perfilBuscado = await repository.getAllProfiles();
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
          '${S.of(context).welcome}, '
              '${profiles.isNotEmpty ? profiles[0].name : 'User'}',
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
    );
  }
}

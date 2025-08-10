import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../generated/l10n.dart';

import '../theme_color/app_colors.dart';
import '../widgets/iconbutton_notifications.dart';
import '../widgets/iconbutton_settings.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 380,
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colors.secondary.withValues(
                                    alpha: 0.1,
                                  ),
                                  width: 2,
                                ),
                                color: colors.secondary,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/user_default_photo.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${S.of(context).welcome}, '
                                '${profiles.isNotEmpty ? profiles[0].name : 'User'}',
                                style: GoogleFonts.nunito(
                                  color: colors.secondary,
                                  fontSize: 22,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                IconbuttonSettings(),
                                const SizedBox(width: 6),
                                IconbuttonNotifications(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

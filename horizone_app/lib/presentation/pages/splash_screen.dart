import 'package:flutter/material.dart';

import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../generated/l10n.dart';

/// Splash screen shown when the app starts.
/// It checks whether a user profile exists and navigates accordingly
/// to either the dashboard or the get started screen.
class SplashScreen extends StatefulWidget {
  /// Creates a [SplashScreen] widget.
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// State class for [SplashScreen], handles initial logic and navigation.
class _SplashScreenState extends State<SplashScreen> {
  /// Repository used to retrieve stored profile data.
  final repository = ProfileRepositoryImpl();

  /// List of profiles loaded from the database.
  late List<Profile> profiles;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  /// Loads the profile data and navigates based on existence of profile.
  Future<void> _carregarPerfil() async {
    final perfilBuscado = await repository.getAllProfiles();
    setState(() {
      profiles = perfilBuscado;
    });

    if (!mounted) return;

    if (profiles.isNotEmpty) {
      await Navigator.pushReplacementNamed(context, '/homeScreen');
    } else {
      await Navigator.pushReplacementNamed(context, '/getStarted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff003566),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: Image.asset(
                'assets/images/logo_horizone.png',
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Text(
                  S.of(context).newHorizons,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

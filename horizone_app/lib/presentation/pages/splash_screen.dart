import 'package:flutter/material.dart';
import 'package:horizone_app/generated/l10n.dart';

import '../../database/daos/profile_dao.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final profileDao = ProfileDao();
  var profiles;

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
    Future.delayed(Duration(seconds: 2), () {
      if (context.mounted) {
        if(profiles.isNotEmpty) {
          Navigator.pushNamed(context, '/dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/getStarted');
        }
      }
    });
    return Scaffold(
      backgroundColor: Color(0xff003566),
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
                child: Text(S.of(context).newHorizons,
                  style: TextStyle(
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

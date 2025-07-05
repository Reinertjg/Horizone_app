import 'package:flutter/material.dart';
import 'package:horizone_app/generated/l10n.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/getStarted');
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

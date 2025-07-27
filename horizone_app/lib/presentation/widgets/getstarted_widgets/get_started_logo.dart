import 'package:flutter/material.dart';

class GetStartedLogo extends StatelessWidget {
  const GetStartedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 250),
        child: Image.asset(
          'assets/images/logo_horizone.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

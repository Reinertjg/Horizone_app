import 'package:flutter/material.dart';

/// A widget that displays the Horizone logo at the top center of the screen.
///
/// Typically used on onboarding or splash screens like Get Started.
class GetStartedLogo extends StatelessWidget {
  /// Creates a [GetStartedLogo] widget.
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

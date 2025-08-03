import 'package:flutter/material.dart';
import '../widgets/getstarted_widgets/get_started_bottom_card.dart';
import '../widgets/getstarted_widgets/get_started_header.dart';
import '../widgets/getstarted_widgets/get_started_logo.dart';

/// The initial screen presented to the user,
/// typically used to introduce the app and guide them to onboarding or login.
class GetStartedScreen extends StatelessWidget {
  /// Creates a [GetStartedScreen] widget.
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/landscape_misurina.png',
                  fit: BoxFit.cover,
                ),
              ),
              const GetStartedHeader(),
              const GetStartedLogo(),
              const GetStartedBottomCard(),
            ],
          ),
        ),
      ),
    );
  }
}

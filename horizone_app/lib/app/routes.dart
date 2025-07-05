import 'package:flutter/material.dart';
import 'package:horizone_app/presentation/pages/getstarted_screen.dart';
import 'package:horizone_app/presentation/pages/profilesetup_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../generated/l10n.dart';
import '../presentation/pages/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt'),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('pt'), // Portuguese
      ],
      title: 'Horizone',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/getStarted': (context) => const GetStartedScreen(),
        '/profileSetUp': (context) => const ProfileSetUpScreen(),
      },
    );
  }
}

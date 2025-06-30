import 'package:flutter/material.dart';
import 'package:horizone_app/presentation/pages/getstarted_screen.dart';

import '../presentation/pages/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Horizone',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/getStarted': (context) => const GetStartedScreen(),
        // '/difficulty': (context) => const DifficultyScreen(),
      },
    );
  }
}

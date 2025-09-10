import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';
import 'presentation/routes.dart';
import 'presentation/state/travel_provider.dart';
import 'presentation/state/locale_provider.dart';
import 'presentation/state/participant_provider.dart';
import 'presentation/state/profile_provider.dart';
import 'presentation/state/theme_provider.dart';
import 'presentation/state/stop_provider.dart';
import 'presentation/theme_color/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
    runApp(
    MultiProvider(
      providers: [
        /// Provides the current app locale (e.g., 'pt' for Portuguese)
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(const Locale('pt')),
        ),

        /// Manages light/dark theme switching
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        /// Manages the state of the profile form (e.g., ProfileFormScreen)
        ChangeNotifierProvider(create: (_) => ProfileProvider()),

        /// Manages interview-related state and logic
        ChangeNotifierProvider(create: (_) => TravelProvider()),

        /// Manages participant-related state and logic
        ChangeNotifierProvider(create: (_) => ParticipantProvider()),

        /// Manages travel stop-related state and logic
        ChangeNotifierProvider(create: (_) => StopProvider()),

      ],

      /// Root widget of the app
      child: const MyApp(),
    ),
  );
}

/// The root widget of the application.
///
/// Sets up localization, theme, routing, and providers
/// such as locale and theme mode.
class MyApp extends StatelessWidget {
  /// Constructs the [MyApp] widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
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
      routes: AppRoutes.routes,
    );
  }
}

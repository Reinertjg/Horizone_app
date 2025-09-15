import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../state/locale_provider.dart';
import '../theme_color/app_colors.dart';

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
              const _BackgroundImage(),
              const _LanguageSelector(),
              const _GetStartedLogo(),
              const _BottomCardWithAirplane(),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that displays a background image on the screen.
class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/landscape_misurina.png',
        fit: BoxFit.cover,
      ),
    );
  }
}

/// A widget displayed at the top right of the Get Started screen,
/// allowing the user to select the app's language. Renamed for clarity.
class _LanguageSelector extends StatelessWidget {
  /// Creates a [_LanguageSelector] widget.
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.locale!;
    final selectedLanguage = getLanguageName(locale);
    final colors = Theme.of(context).extension<AppColors>()!;

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, right: 10.0),
        child: DropdownButton<Locale>(
          value: locale,
          underline: SizedBox(),
          elevation: 2,
          selectedItemBuilder: (_) => List.generate(3, (_) {
            return Align(
              alignment: Alignment.centerRight,
              child: Text(
                selectedLanguage,
                style: TextStyle(color: Colors.white),
              ),
            );
          }),
          icon: Icon(Icons.arrow_drop_down, size: 22, color: Colors.white),
          style: TextStyle(color: Colors.white, fontSize: 16),
          dropdownColor: colors.secondary,
          borderRadius: BorderRadius.circular(10),
          onChanged: (newLocale) {
            if (newLocale != null) {
              localeProvider.setLocale(newLocale);
            }
          },
          items: const [
            DropdownMenuItem(value: Locale('en'), child: Text('English')),
            DropdownMenuItem(value: Locale('pt'), child: Text('Português')),
            DropdownMenuItem(value: Locale('es'), child: Text('Español')),
          ],
        ),
      ),
    );
  }

  /// Returns the human-readable name of the given [locale].
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Português';
      case 'es':
        return 'Español';
      default:
        return 'Unknown';
    }
  }
}

/// A widget that displays the Horizone logo at the top center of the screen.
class _GetStartedLogo extends StatelessWidget {
  /// Creates a [_GetStartedLogo] widget.
  const _GetStartedLogo();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 250),
        child: Text(
          'HORIZONE',
          style: GoogleFonts.abel(
            color: Colors.white,
            fontSize: 60,
            letterSpacing: 9.0,
          ),
        ),
      ),
    );
  }
}

/// A widget displayed at the bottom of the Get Started screen,
/// containing a title and a button to start the profile setup flow.
class _GetStartedBottomCard extends StatelessWidget {
  /// Creates a [_GetStartedBottomCard] widget.
  const _GetStartedBottomCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: colors.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  S.of(context).readyExplore,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.07,
                    color: colors.quaternary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/profileSetup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 52,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  S.of(context).startJourney,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget that combines the bottom card and the airplane icon.
/// This ensures the icon is perfectly positioned relative to the card.
class _BottomCardWithAirplane extends StatelessWidget {
  /// Creates a [_BottomCardWithAirplane] widget.
  const _BottomCardWithAirplane();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.40,
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.height * 0.10,
              child: Transform.rotate(
                angle: 25.9, // 90 degrees in radians
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedAirplane01,
                  color: colors.primary,
                  size: 40,
                ),
              ),
            ),
            const _GetStartedBottomCard(),
          ],
        ),
      ),
    );
  }
}

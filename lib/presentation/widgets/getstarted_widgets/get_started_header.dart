import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/locale_provider.dart';
import '../../theme_color/app_colors.dart';

/// A widget displayed at the top right of the Get Started screen,
/// allowing the user to select the app's language.
class GetStartedHeader extends StatelessWidget {
  /// Creates a [GetStartedHeader] widget.
  const GetStartedHeader({super.key});

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

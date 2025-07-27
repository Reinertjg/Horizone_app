import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../AppColors.dart';
import '../state/locale_provider.dart';

class GetStartedHeader extends StatelessWidget {
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

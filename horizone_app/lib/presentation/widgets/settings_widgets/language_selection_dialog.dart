import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../state/locale_provider.dart';

class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key, required this.localeProvider});

  final LocaleProvider localeProvider;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(
        context,
      ).scaffoldBackgroundColor,
      title: Text(
        S.of(context).selectLanguage,
        style: TextStyle(
          color: Theme.of(
            context,
          ).primaryColor,
        ),
      ),
      content: Column(
        mainAxisSize:
        MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'English',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).primaryColor,
              ),
            ),
            onTap: () {
              localeProvider
                  .setLocale(
                Locale('en'),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Português',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).primaryColor,
              ),
            ),
            onTap: () {
              localeProvider
                  .setLocale(
                Locale('pt'),
              );
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Español',
              style: TextStyle(
                color: Theme.of(
                  context,
                ).primaryColor,
              ),
            ),
            onTap: () {
              localeProvider
                  .setLocale(
                Locale('es'),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

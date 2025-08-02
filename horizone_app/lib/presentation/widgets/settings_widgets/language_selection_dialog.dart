import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../state/locale_provider.dart';

/// A dialog that allows the user to select the app's language.
///
/// This widget shows a list of available languages
/// (English, Portuguese, Spanish),
/// and updates the locale using the provided [LocaleProvider].
class LanguageSelectionDialog extends StatelessWidget {
  /// Creates a custom [InterviewTextField] with the given parameter.
  const LanguageSelectionDialog({super.key, required this.localeProvider});

  /// The [LocaleProvider] used to update the app's locale.
  final LocaleProvider localeProvider;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        S.of(context).selectLanguage,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'English',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () {
              localeProvider.setLocale(Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Português',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () {
              localeProvider.setLocale(Locale('pt'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Español',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () {
              localeProvider.setLocale(Locale('es'));
              Navigator.pushNamed(context, '/interview');
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../state/locale_provider.dart';
import '../../theme_color/app_colors.dart';

/// A dialog that allows the user to select the app's language.
///
/// This widget shows a list of available languages
/// (English, Portuguese, Spanish),
/// and updates the locale using the provided [LocaleProvider].
class LanguageSelectionDialog extends StatelessWidget {
  /// Creates a custom [InterviewTextField] with the given parameter.
  const LanguageSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    final localeProvider = Provider.of<LocaleProvider>(
        context, listen: false);
    return AlertDialog(
      backgroundColor: colors.primary,
      title: Text(
        S.of(context).selectLanguage,
        style: TextStyle(color: colors.secondary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              'English',
              style: TextStyle(color: colors.secondary),
            ),
            onTap: () {
              localeProvider.setLocale(Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Português',
              style: TextStyle(color: colors.secondary),
            ),
            onTap: () {
              localeProvider.setLocale(Locale('pt'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Español',
              style: TextStyle(color: colors.secondary),
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

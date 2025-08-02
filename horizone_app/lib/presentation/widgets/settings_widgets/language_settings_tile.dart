
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../state/locale_provider.dart';
import 'language_selection_dialog.dart';

/// A tile used in the settings screen
/// allow users to change the app's language.
///
/// When tapped, this tile opens a [LanguageSelectionDialog] where the user
/// can choose between English, Portuguese, or Spanish.
class LanguageSettingsTile extends StatelessWidget {
  /// Creates a custom [LanguageSettingsTile] with the given parameter.
  const LanguageSettingsTile({super.key, required this.localeProvider});

  /// The [LocaleProvider] used to update the app's locale.
  final LocaleProvider localeProvider;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        S.of(context).language,
        style: TextStyle(
          color: Theme.of(
            context,
          ).primaryColor,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).primaryColor,
        size: 20,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return LanguageSelectionDialog(localeProvider: localeProvider);
          },
        );
      },
    );
  }
}

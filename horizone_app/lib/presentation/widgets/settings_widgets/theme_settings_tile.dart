import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../state/theme_provider.dart';
import 'theme_selection_dialog.dart';

/// A widget that displays a theme selection dialog.
class ThemeSettingsTile extends StatelessWidget {
  /// Creates a custom [ThemeSettingsTile].
  const ThemeSettingsTile({super.key, required this.themeProvider});

  /// The [ThemeProvider] to use for theme changes.
  final ThemeProvider themeProvider;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        S.of(context).theme,
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
            return ThemeSelectionDialog(themeProvider: themeProvider,);
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../state/theme_provider.dart';

/// A dialog that allows users to select between
/// Light, dark, or system theme modes.
///
/// Uses [ThemeProvider] to update the application's theme.
class ThemeSelectionDialog extends StatefulWidget {
  /// Creates a custom [ThemeSelectionDialog] with the given parameter.
  const ThemeSelectionDialog({super.key,  required this.themeProvider});

  /// The [ThemeProvider] used to update the application's theme.
  final ThemeProvider themeProvider;

  @override
  State<ThemeSelectionDialog> createState() => _ThemeSelectionDialogState();
}

class _ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        S.of(context).selectTheme,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              S.of(context).lightTheme,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () {
              setState(() {
                widget.themeProvider.setTheme(ThemeMode.light);
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).darkTheme,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () {
              setState(() {
                widget.themeProvider.setTheme(ThemeMode.dark);
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).systemTheme,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onTap: () {
              setState(() {
                widget.themeProvider.setTheme(ThemeMode.system);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

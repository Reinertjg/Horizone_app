import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../state/theme_provider.dart';
import '../../theme_color/app_colors.dart';

/// A dialog that allows users to select between
/// Light, dark, or system theme modes.
///
/// Uses [ThemeProvider] to update the application's theme.
class ThemeSelectionDialog extends StatefulWidget {
  /// Creates a custom [ThemeSelectionDialog] with the given parameter.
  const ThemeSelectionDialog({super.key});

  @override
  State<ThemeSelectionDialog> createState() => _ThemeSelectionDialogState();
}

class _ThemeSelectionDialogState extends State<ThemeSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;

    return AlertDialog(
      backgroundColor: colors.primary,
      title: Text(
        S.of(context).selectTheme,
        style: TextStyle(color: colors.secondary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              S.of(context).lightTheme,
              style: TextStyle(color: colors.secondary),
            ),
            onTap: () {
              setState(() {
                themeProvider.setTheme(ThemeMode.light);
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).darkTheme,
              style: TextStyle(color: colors.secondary),
            ),
            onTap: () {
              setState(() {
                themeProvider.setTheme(ThemeMode.dark);
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).systemTheme,
              style: TextStyle(color: colors.secondary),
            ),
            onTap: () {
              setState(() {
                themeProvider.setTheme(ThemeMode.system);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

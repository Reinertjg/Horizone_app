import 'package:flutter/material.dart';
import 'package:horizone_app/presentation/state/theme_provider.dart';
import '../../../generated/l10n.dart';

class ThemeSelectionDialog extends StatefulWidget {
  const ThemeSelectionDialog({super.key,  required this.themeProvider});

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

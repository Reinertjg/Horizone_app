import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../state/locale_provider.dart';
import '../../state/theme_provider.dart';
import 'delete_accoun_ttile.dart';
import 'language_settings_tile.dart';
import 'theme_settings_tile.dart';

/// A widget that displays the content of the settings bottom sheet.
class SettingsBottomSheetContent extends StatelessWidget {
  /// Creates a custom [SettingsBottomSheetContent].
  const SettingsBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final localeProvider = Provider.of<LocaleProvider>(
            context, listen: false);


        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).settings,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ThemeSettingsTile(themeProvider: themeProvider),
              LanguageSettingsTile(localeProvider: localeProvider),
              DeleteAccountTile(),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../state/locale_provider.dart';
import '../../state/theme_provider.dart';
import '../../theme_color/app_colors.dart';
import 'delete_accoun_tile.dart';
import 'language_settings_tile.dart';
import 'theme_settings_tile.dart';

/// A widget that displays the content of the settings bottom sheet.
class SettingsBottomSheetContent extends StatelessWidget {
  /// Creates a custom [SettingsBottomSheetContent].
  const SettingsBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            color: colors.primary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).settings,
                style: TextStyle(
                  fontSize: 18,
                  color: colors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ThemeSettingsTile(),
              LanguageSettingsTile(),
              DeleteAccountTile(),
            ],
          ),
        );
      },
    );
  }
}

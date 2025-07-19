import 'package:flutter/material.dart';
import 'package:horizone_app/presentation/widgets/settings_widgets/theme_settings_tile.dart';
import 'package:provider/provider.dart';

import '../../../database/daos/profile_dao.dart';
import '../../../generated/l10n.dart';
import '../../state/locale_provider.dart';
import '../../state/theme_provider.dart';
import 'delete_accoun_ttile.dart';
import 'language_settings_tile.dart';

class SettingsBottomSheetContent extends StatelessWidget {
  const SettingsBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
        final profileDao = Provider.of<ProfileDao>(context, listen: false);

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
              DeleteAccountTile(profileDao: profileDao),
            ],
          ),
        );
      },
    );
  }
}

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../state/locale_provider.dart';
import '../../state/theme_provider.dart';
import '../../theme_color/app_colors.dart';

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
              _ThemeSettingsTile(),
              _LanguageSettingsTile(),
            ],
          ),
        );
      },
    );
  }
}

/// A widget that displays a theme selection dialog.
class _ThemeSettingsTile extends StatelessWidget {
  /// Creates a custom [_ThemeSettingsTile].
  const _ThemeSettingsTile();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      title: Text(
        S.of(context).theme,
        style: TextStyle(color: colors.secondary),
      ),
      trailing: Icon(Icons.arrow_forward, color: colors.secondary, size: 20),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return _ThemeSelectionDialog();
          },
        );
      },
    );
  }
}

/// A dialog that allows users to select between
/// Light, dark, or system theme modes.
class _ThemeSelectionDialog extends StatelessWidget {
  /// Creates a custom [_ThemeSelectionDialog] with the given parameter.
  const _ThemeSelectionDialog();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = Theme.of(context).extension<AppColors>()!;
    ThemeMode? selectedTheme = themeProvider.themeMode;

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
              style: TextStyle(
                color: selectedTheme == ThemeMode.light
                    ? colors.tertiary
                    : colors.quaternary,
              ),
            ),
            trailing: HugeIcon(
              icon: HugeIcons.strokeRoundedSun03,
              color: selectedTheme == ThemeMode.light
                  ? colors.tertiary
                  : colors.quaternary,
            ),
            onTap: () {
              themeProvider.setTheme(ThemeMode.light);
              selectedTheme = ThemeMode.light;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).darkTheme,
              style: TextStyle(
                color: selectedTheme == ThemeMode.dark
                    ? colors.tertiary
                    : colors.quaternary,
              ),
            ),
            trailing: HugeIcon(
              icon: HugeIcons.strokeRoundedMoon02,
              color: selectedTheme == ThemeMode.dark
                  ? colors.tertiary
                  : colors.quaternary,
            ),
            onTap: () {
              themeProvider.setTheme(ThemeMode.dark);
              selectedTheme = ThemeMode.dark;
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              S.of(context).systemTheme,
              style: TextStyle(
                color: selectedTheme == ThemeMode.system
                    ? colors.secondary
                    : colors.quaternary,
              ),
            ),
            trailing: HugeIcon(
              icon: HugeIcons.strokeRoundedSettings01,
              color: selectedTheme == ThemeMode.system
                  ? colors.secondary
                  : colors.quaternary,
            ),
            onTap: () {
              themeProvider.setTheme(ThemeMode.system);
              selectedTheme = ThemeMode.system;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

/// A tile used in the settings screen
/// allow users to change the app's language.
class _LanguageSettingsTile extends StatelessWidget {
  /// Creates a custom [_LanguageSettingsTile] with the given parameter.
  const _LanguageSettingsTile();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      title: Text(
        S.of(context).language,
        style: TextStyle(color: colors.secondary),
      ),
      trailing: Icon(Icons.arrow_forward, color: colors.secondary, size: 20),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return _LanguageSelectionDialog();
          },
        );
      },
    );
  }
}

/// A dialog that allows the user to select the app's language.
///
/// (English, Portuguese, Spanish),
class _LanguageSelectionDialog extends StatelessWidget {
  /// Creates a custom [InterviewTextField] with the given parameter.
  const _LanguageSelectionDialog();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final selectLocale = localeProvider.locale;
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
              style: TextStyle(
                color: selectLocale == Locale('en')
                    ? colors.tertiary
                    : colors.quaternary,
              ),
            ),
            trailing: CountryFlag.fromCountryCode('USA', shape: const Circle()),
            onTap: () {
              localeProvider.setLocale(Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Português',
              style: TextStyle(
                color: selectLocale == Locale('pt')
                    ? colors.tertiary
                    : colors.quaternary,
              ),
            ),
            trailing: CountryFlag.fromCountryCode('BR', shape: const Circle()),
            onTap: () {
              localeProvider.setLocale(Locale('pt'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Español',
              style: TextStyle(
                color: selectLocale == Locale('es')
                    ? colors.tertiary
                    : colors.quaternary,
              ),
            ),
            trailing: CountryFlag.fromCountryCode('ES', shape: const Circle()),
            onTap: () {
              localeProvider.setLocale(Locale('es'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

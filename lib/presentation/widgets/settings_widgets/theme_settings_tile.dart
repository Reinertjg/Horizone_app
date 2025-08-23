import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../theme_color/app_colors.dart';
import 'theme_selection_dialog.dart';

/// A widget that displays a theme selection dialog.
class ThemeSettingsTile extends StatelessWidget {
  /// Creates a custom [ThemeSettingsTile].
  const ThemeSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      title: Text(
        S.of(context).theme,
        style: TextStyle(
          color: colors.secondary
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward,
        color: colors.secondary,
        size: 20,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ThemeSelectionDialog();
          },
        );
      },
    );
  }
}

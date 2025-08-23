
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../theme_color/app_colors.dart';
import 'language_selection_dialog.dart';

/// A tile used in the settings screen
/// allow users to change the app's language.
///
/// When tapped, this tile opens a [LanguageSelectionDialog] where the user
/// can choose between English, Portuguese, or Spanish.
class LanguageSettingsTile extends StatelessWidget {
  /// Creates a custom [LanguageSettingsTile] with the given parameter.
  const LanguageSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return ListTile(
      title: Text(
        S.of(context).language,
        style: TextStyle(
          color: colors.secondary,
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
            return LanguageSelectionDialog();
          },
        );
      },
    );
  }
}

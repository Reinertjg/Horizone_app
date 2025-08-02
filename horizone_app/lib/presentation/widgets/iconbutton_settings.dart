import 'package:flutter/material.dart';

import '../theme_color/app_colors.dart';
import 'settings_widgets/settingsbottom_sheetcontent.dart';

/// A widget that displays an icon button for settings.
class IconbuttonSettings extends StatelessWidget {
  /// Creates a custom [IconbuttonSettings].
  const IconbuttonSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Material(
      color: colors.secondary,
      shape: CircleBorder(),
      child: SizedBox(
        height: 35,
        width: 35,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.settings, color: colors.quaternary),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (/*BuildContext*/ innerContext) {
                return SettingsBottomSheetContent();
              },
            );
          },
        ),
      ),
    );
  }
}

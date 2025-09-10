import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../theme_color/app_colors.dart';
import 'settings_widgets/settingsbottom_sheetcontent.dart';

/// A widget that displays an icon button for settings.
class IconbuttonSettings extends StatelessWidget {
  /// Creates a custom [IconbuttonSettings].
  const IconbuttonSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Card(
      color: colors.quinary,
      shape: CircleBorder(),
      elevation: 2,
      child: SizedBox(
        height: 38,
        width: 38,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedSettings01,
            color: colors.quaternary,
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (innerContext) {
                return SettingsBottomSheetContent();
              },
            );
          },
        ),
      ),
    );
  }
}

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
      color: colors.secondary,
      shape: CircleBorder(),
      child: SizedBox(
        height: 35,
        width: 35,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(HugeIcons.strokeRoundedSettings02, color: colors.quinary),
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

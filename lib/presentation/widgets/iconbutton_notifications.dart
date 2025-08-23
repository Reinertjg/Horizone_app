import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../theme_color/app_colors.dart';

/// A widget that displays an icon button for notifications.
class IconbuttonNotifications extends StatelessWidget {
  /// Creates a custom [IconbuttonNotifications].
  const IconbuttonNotifications({super.key});

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
          icon: Icon(HugeIcons.strokeRoundedNotification02, color: colors.quinary),
          onPressed: () {},
        ),
      ),
    );
  }
}

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
      color: colors.quinary,
      shape: CircleBorder(),
      elevation: 2,
      child: SizedBox(
        height: 38,
        width: 38,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedNotification02,
            color: colors.quaternary,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

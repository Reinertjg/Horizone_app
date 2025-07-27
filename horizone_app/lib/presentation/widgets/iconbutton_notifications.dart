import 'package:flutter/material.dart';
import '../theme_color/AppColors.dart';

class IconbuttonNotifications extends StatelessWidget {
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
          icon: Icon(Icons.notifications_none, color: colors.quaternary),
          onPressed: () {},
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../theme_color/app_colors.dart';

class ParticipantHandleBar extends StatelessWidget {
  const ParticipantHandleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colors.quaternary.withAlpha(80),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

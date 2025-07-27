import 'package:flutter/material.dart';

import '../../theme_color/AppColors.dart';

class ProfileInfoText extends StatelessWidget {
  const ProfileInfoText({
    required this.tellUs,
    required this.whoYouAre,
    required this.andWellTake,
    super.key,
  });

  final String tellUs;
  final String whoYouAre;
  final String andWellTake;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: colors.tertiary),
        children: [
          TextSpan(text: tellUs),
          TextSpan(
            text: whoYouAre,
            style: TextStyle(color: colors.secondary),
          ),
          TextSpan(
            text: andWellTake,
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

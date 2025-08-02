import 'package:flutter/material.dart';

import '../../theme_color/app_colors.dart';

/// A custom text widget that displays a message with stylized segments.
///
/// Used to show a profile onboarding instruction with emphasis.
class ProfileInfoText extends StatelessWidget {
  /// Creates a custom [ProfileInfoText] with the given parameters.
  const ProfileInfoText({
    required this.tellUs,
    required this.whoYouAre,
    required this.andWellTake,
    super.key,
  });

  /// Text before the emphasized part.
  final String tellUs;
  /// Emphasized part, styled with the secondary color.
  final String whoYouAre;
  /// Text after the emphasized part.
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

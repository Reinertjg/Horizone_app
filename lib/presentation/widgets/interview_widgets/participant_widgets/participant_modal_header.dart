import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme_color/app_colors.dart';

class ParticipantModalHeader extends StatelessWidget {
  const ParticipantModalHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.person_add_rounded,
            color: colors.secondary,
            size: 22,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: colors.quaternary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: colors.quaternary.withValues(alpha: 0.5),
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

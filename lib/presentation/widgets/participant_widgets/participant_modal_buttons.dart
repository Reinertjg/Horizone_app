
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme_color/app_colors.dart';
import '../interview_widgets/interview_fab.dart';

class ParticipantModalButtons extends StatelessWidget {
  const ParticipantModalButtons({
    super.key,
    required this.actionLabel,
    required this.onCancel,
    required this.onConfirm,
  });

  final String actionLabel;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colors.quaternary.withAlpha(100)),
              ),
              foregroundColor: colors.quaternary.withAlpha(180),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          flex: 2,
          child: InterviewFab(
            nameButton: actionLabel,
            onPressed: onConfirm,
          ),
        ),
      ],
    );
  }
}

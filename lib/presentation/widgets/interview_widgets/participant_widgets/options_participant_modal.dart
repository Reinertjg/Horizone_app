import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/participant.dart';
import '../../../../generated/l10n.dart';
import '../../../state/participant_provider.dart';
import '../../../theme_color/app_colors.dart';
import 'modals/update_participant_modal.dart';

/// A widget that displays a options of participants.
///
/// It allows the user to update and delete participants.
class OptionsParticipantModal extends StatelessWidget {
  /// Creates a custom [OptionsParticipantModal].
  const OptionsParticipantModal({super.key, required this.participant});

  /// The participant to be displayed.
  final Participant participant;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle(
          style: GoogleFonts.raleway(color: colors.quaternary),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.quaternary.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                participant.name,
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colors.quaternary,
                ),
              ),
              const SizedBox(height: 20),

              /// Image options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImageOption(
                    icon: CupertinoIcons.delete,
                    label: S.of(context).delete,
                    onTap: () {
                      Provider.of<ParticipantProvider>(
                        context,
                        listen: false,
                      ).delteParticipant(participant);
                    },
                    backgroundColor: Colors.red.withAlpha(50),
                    iconColor: Colors.red,
                  ),
                  _ImageOption(
                    icon: CupertinoIcons.pencil_circle,
                    label: 'Editar',
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) =>
                          UpdateParticipantModal(participant: participant),
                    ),
                    backgroundColor: colors.tertiary.withAlpha(50),
                    iconColor: colors.tertiary,
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  const _ImageOption({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: iconColor),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

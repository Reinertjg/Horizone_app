import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../generated/l10n.dart';
import '../theme_color/app_colors.dart';
import 'interview_widgets/interview_textfield.dart';
import 'orange_text_form.dart';

/// A widget that displays a card with input fields for a travel participant.
///
/// Includes fields for full name and email, and can be used inside a list
/// to collect data from multiple participants.
///
/// The [index] is used to number each participant card.
class ParticipantCard extends StatelessWidget {
  /// The index of the participant card.
  final int index;

  /// Creates a [ParticipantCard] for the given [index].
  const ParticipantCard({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Card(

      color: colors.quinary,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Person ${(index + 1)}',
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.secondary,
              ),
            ),
            const SizedBox(height: 8),
            OrangeTextForm(
              nameButton: S.of(context).name,
              icon: Icons.person,
              controller: TextEditingController(),
            ),
            const SizedBox(height: 8),
            OrangeTextForm(
              nameButton: 'E-mail',
              icon: Icons.email,
              controller: TextEditingController(),
            ),
          ],
        ),
      ),
    );
  }
}

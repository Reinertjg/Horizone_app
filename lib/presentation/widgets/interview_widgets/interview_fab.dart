
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme_color/app_colors.dart';

/// Builds the FAB widget used to validate the form
/// Navigate to the next screen.
class InterviewFab extends StatelessWidget {
  /// Creates a custom [InterviewFab] with the given parameter.
  const InterviewFab({
    super.key,
    required this.nameButton, this.onPressed,
  });

  /// The [NameButton] for the form.
  final String nameButton;

  /// The [onPressed] function for the form.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.secondary,
            colors.secondary.withRed(102).withGreen(178).withBlue(255),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          nameButton,
          style: GoogleFonts.raleway(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme_color/app_colors.dart';

/// Builds the FAB widget used to validate the form
/// Navigate to the next screen.
class InterviewFab extends StatelessWidget {
  /// Creates a custom [InterviewFab] with the given parameter.
  const InterviewFab({super.key, required this.nameButton, this.onPressed});

  /// The [NameButton] for the form.
  final String nameButton;

  /// The [onPressed] function for the form.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final isEnabled = onPressed != null;

    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
        gradient: isEnabled
            ? LinearGradient(
                colors: [
                  colors.secondary,
                  colors.secondary.withRed(102).withGreen(178).withBlue(255),
                ],
              )
            : null,
        color: isEnabled ? null : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isEnabled)
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.lock, color: Colors.white, size: 18),
              ),
            Text(
              nameButton,
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

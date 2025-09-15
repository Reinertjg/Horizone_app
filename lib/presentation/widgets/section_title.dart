import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme_color/app_colors.dart';

/// A reusable widget for displaying a section title with an icon.
///
/// Typically used to separate content sections in a form or screen.
class SectionTitle extends StatelessWidget {
  /// Creates a custom [SectionTitle] with the given parameters.
  const SectionTitle({super.key, required this.title, required this.icon});

  /// The text to be displayed as the section title.
  final String title;

  /// The icon shown at the start of the title.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colors.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: colors.secondary, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colors.quaternary,
          ),
        ),
      ],
    );
  }
}
